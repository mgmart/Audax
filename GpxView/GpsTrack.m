//
//  GpsTrack.m
//  GpxView
//
//  Created by Mario Martelli on 12.03.13.
//  Copyright (c) 2013 Schnuddel Huddel. All rights reserved.
//
//
// 
//        GPXTrack
// 
// Class to manage the model of a GPS Trackfile
// 
// TODO: Introduce elevation to calculate proximate speed regarding the elevation profile of the track.



#import "GpsTrack.h"
#import "SHMapPoint.h"
#import "Controls.h"

@implementation GpsTrack
@synthesize startTime, elapsedTime, remainingTime, sender, segments;


// reports back the length of the track in meters
- (double)length
{
    CLLocationDistance metersApart = 0.0;
    
    for (int i = 1; i < pointCount; i++) {
        metersApart += MKMetersBetweenMapPoints(trackpoints[i], trackpoints[i-1]);
    }
    return metersApart;
}

- (NSArray *)controls
{
    return mapPoints;
}

// calculate segments between controls
- (void)calculateSegments
{
    //
    // Find nearest Trackpoint to Waypoint
    //
    
    NSArray *controls = [[Controls sharedControls] allControls];
    for (SHMapPoint *control in controls){
        // Get current location from control
        CLLocation *pointLocation = [[CLLocation alloc] initWithLatitude:control.coordinate.latitude longitude:control.coordinate.longitude];
        CLLocationDistance distance = 300;
        int index = 0;
        for (CLLocation *curr in coordinates){
            if ([pointLocation distanceFromLocation:curr] < distance) {
                distance = [pointLocation distanceFromLocation:curr];
                [control setNearestPointIndex:[[NSNumber alloc] initWithInt:index]];
            }
            index++;
        }
        // FIXME: if distance is still 300 we need to handle this!
        // NSLog(@"Distance of control: %@ is %f and present at index: %@", [control title], distance, [control nearestPointIndex]);
    }
    
    //
    // Calculate distance between controls
    //
    segments = [[NSMutableArray alloc] initWithCapacity:[controls count] + 1];
    CLLocationDistance metersApart = 0.0;
    for (int i = 0; i < [controls count] - 1; i++) {
        // NSLog(@"Distance between: %i and %i",[[controls[i] nearestPointIndex] intValue], [[controls[i+1] nearestPointIndex] intValue]);
        for (int j = [[controls[i] nearestPointIndex] intValue]; j < [[controls[i+1] nearestPointIndex] intValue]; j++) {
            metersApart += MKMetersBetweenMapPoints(trackpoints[j], trackpoints[j+1]);
        }
        [segments addObject:[[NSNumber alloc] initWithDouble:metersApart]];
        // NSLog(@"Distance of segment: %f", metersApart);
        metersApart = 0.0;
    }
    int k = [controls count] - 1;
    // NSLog(@"Distance between: %i and %i",[[controls[k] nearestPointIndex] intValue], pointCount);

    for (int j = [[controls[k] nearestPointIndex] intValue]; j < pointCount - 1; j++) {
        metersApart += MKMetersBetweenMapPoints(trackpoints[j], trackpoints[j+1]);
    }
    [segments addObject:[[NSNumber alloc] initWithDouble:metersApart]];
    // NSLog(@"Distance of segment: %f", metersApart);
    // NSLog(@"Segments count is: %i", [segments count]);
}

// calculate opening and closing times for controls
- (void)calculateControlTimes
{
    //    The table below gives the minimum and maximum speeds for ACP brevets.
    //
    //    Control location (km)	Minimum Speed (km/hr)	Maximum Speed (km/hr)
    //    0 - 200                       15                      34
    //    200 - 400                     15                      32
    //    400 - 600                     15                      30
    //    600 - 1000                    11.428                  28
    //    1000 - 1300                   13.333                  26
    
    // Further information: http://www.rusa.org/octime_alg.html
    
    // FIXME: Preferences needed for velocity base
    // Calculation is easier when using m/s instead of km/h
    float minSpeed = 15 / 3.6;
    
    // FIXME: Data input for startTime
    NSDate *myStartTime = [NSDate dateWithTimeIntervalSince1970:1364706000];
    
    int timeInterval = 0;
    int counter = 1;
    SHMapPoint *control;
    double total = 0.0;

    for (NSNumber *segment in segments) {
        // timeInterval = [segment doubleValue] / 1000 / minSpeed * 3600;
        
        total += [segment doubleValue];
        
        
        timeInterval = [segment doubleValue] / minSpeed;
        myStartTime = [NSDate dateWithTimeInterval:timeInterval sinceDate:myStartTime];

        control = [[[Controls sharedControls] allControls] objectAtIndex:counter++];
        
        // FIXME: Start and Stop must be proper set!
        if (counter == 6) {
            counter = 0;
        }
        
        [control setTime:myStartTime];
        
        NSLog(@"Control: %@: %@", control.title, control.time);
    }
    NSLog(@"Total:    %f", total);
    NSLog(@"Distance: %f", [self length]);
}

// returns the region for the track
// can be used for showing the entire track in map view
- (MKCoordinateRegion)region
{
    MKCoordinateRegion region;
    CLLocationCoordinate2D coord;
    
    CLLocationDegrees maxLat = -90;
    CLLocationDegrees maxLon = -180;
    CLLocationDegrees minLat = 90;
    CLLocationDegrees minLon = 180;
    
    for(int idx = 0; idx < pointCount; idx++) {
        coord = MKCoordinateForMapPoint(trackpoints[idx]);
        if (coord.latitude > maxLat) {
            maxLat = coord.latitude;
        }
        if (coord.latitude < minLat) {
            minLat = coord.latitude;
        }
        if (coord.longitude > maxLon) {
            maxLon = coord.longitude;
        }
        if (coord.longitude < minLon) {
            minLon = coord.longitude;
        }
    }
    
    region.center.latitude     = (maxLat + minLat) / 2;
    region.center.longitude    = (maxLon + minLon) / 2;
    region.span.latitudeDelta  = maxLat - minLat;
    region.span.longitudeDelta = maxLon - minLon;
    
    return region;
}

#pragma mark XML Parsing
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    
    // Waypoint information
    if ( [elementName isEqualToString:@"trkpt"]) {
        CLLocationCoordinate2D loc;
        loc.latitude = [[attributeDict valueForKey:@"lat" ] doubleValue];
        loc.longitude = [[attributeDict valueForKey:@"lon" ] doubleValue];
        [coordinates addObject:[[CLLocation alloc] initWithLatitude:loc.latitude longitude:loc.longitude]];
        MKMapPoint point = MKMapPointForCoordinate(loc);
        trackpoints[pointCount++] = point;
        return;
    }
    
    if ( [elementName isEqualToString:@"wpt"] ) {
        
        // Make location out of coordinate information
        CLLocationCoordinate2D loc;
        loc.latitude = [[attributeDict valueForKey:@"lat" ] doubleValue];
        loc.longitude = [[attributeDict valueForKey:@"lon" ] doubleValue];
        
        //Create a mapPoint to annotate the Waypoint on the Map
        mapPoint = [[SHMapPoint alloc] initWithCoordinate:loc title:@"Not known at the moment"];
        
        // Parsing starts again, so clear the buffer
        topLevel = @"wpt";
        // currentStringValue = nil;
        return;
    }
    
    if ([topLevel isEqualToString:@"wpt"]) {
        // Prepare the buffer to get a clean name
        currentStringValue = nil;
    }
    // .... continued for remaining elements ....
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"wpt"]) {
        [mapPoints addObject:mapPoint];
        if ([mapPoint order]) {
            [[Controls sharedControls] createControl:mapPoint];
        }
        topLevel = nil;
        currentStringValue = nil;
    }
    
    else if ([elementName isEqualToString:@"time"] && [topLevel isEqualToString:@"wpt"]) {
        // Waypoint time is not important at the moment
        currentStringValue = nil;
    }
    
    else if ([elementName isEqualToString:@"sym"] && [topLevel isEqualToString:@"wpt"]) {
        NSRange range;
        range.length = 1;
        range.location = 7;
        
        if ([currentStringValue hasPrefix:@"Number "]) {
            [mapPoint setOrder:[NSNumber numberWithInteger:[[currentStringValue substringWithRange:range] integerValue]]];
        }
        [mapPoint setFlags:currentStringValue];
        currentStringValue = nil;
    }
    else if ([elementName isEqualToString:@"name"] && [topLevel isEqualToString:@"wpt"]) {
        [mapPoint setTitle:currentStringValue];
        currentStringValue = nil;
    }
    // Extract the comment as a subtitle for the waypoint
    // cmt could also be present in <desc> node.
    else if ([elementName isEqualToString:@"cmt"] && [topLevel isEqualToString:@"wpt"]) {
        [mapPoint setSubtitle:currentStringValue];
        currentStringValue = nil;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    // NSLog(@"foundcharacters: '%@'", string);
    if (!currentStringValue) {
        // currentStringValue is an NSMutableString instance variable
        currentStringValue = [[NSMutableString alloc] initWithCapacity:50];
    }
    [currentStringValue appendString:string];
}

- (void)parseXMLFile:(NSURL *)xmlURL
{
    BOOL success;
    //  NSURL *xmlURL = [NSURL fileURLWithPath:pathToFile];
    addressParser = [[NSXMLParser alloc] initWithContentsOfURL:xmlURL];
    [addressParser setDelegate:self];
    [addressParser setShouldResolveExternalEntities:YES];
    success = [addressParser parse]; // return value not used
    // if not successful, delegate is informed of error
}

#pragma mark Initialising
- (id)initWithFile:(NSURL *)fileName
{
    int pointSpace = INITIAL_POINT_SPACE;
    
    self = [super init];
    if (self) {
        // FIXME: this has to be altered if necessary!
        //        3000 trackpoints are sufficcient for max 600km.
        trackpoints = malloc(sizeof(MKMapPoint) * pointSpace);
        coordinates = [[NSMutableArray alloc] initWithCapacity:1000];
        
        pointCount = 0;
        
        mapPoints = [[NSMutableArray alloc] initWithCapacity:100];
        
        [self parseXMLFile:fileName];
        startTime = [NSDate date];
        NSLog(@"Coordinates: %d", [coordinates count]);

        [self calculateSegments];
        [self calculateControlTimes];
    }
    return self;
}

- (MKPolyline *)poly
{
    // NSLog(@"Pointcount for Poly is: %i", pointCount);
    return [MKPolyline polylineWithPoints:trackpoints count:pointCount];

}

- (id)init
{
    NSURL* url = [[NSBundle mainBundle] URLForResource:@"GpxViewer" withExtension:@"GPX"];
    return [self initWithFile:url];
}

// FIXME is this correct?
-(void) dealloc{
    trackpoints = nil;
}

@end

