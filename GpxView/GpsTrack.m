//
//  GpsTrack.m
//  GpxView
//
//  Created by Mario Martelli on 12.03.13.
//  Copyright (c) 2013 Schnuddel Huddel. All rights reserved.
//

#import "GpsTrack.h"

@implementation GpsTrack
@synthesize startTime, elapsedTime, remainingTime, sender;


// reports back the length of the track in meters
- (double)length
{
    CLLocationDistance metersApart = 0.0;
    
    for (int i = 1; i < pointCount; i++) {
        metersApart += MKMetersBetweenMapPoints(trackpoints[i], trackpoints[i-1]);
    }
    return metersApart;
}

#pragma mark XML Parsing
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    
    // Waypoint information
    if ( [elementName isEqualToString:@"trkpt"]) {
        CLLocationCoordinate2D loc;
        loc.latitude = [[attributeDict valueForKey:@"lat" ] doubleValue];
        loc.longitude = [[attributeDict valueForKey:@"lon" ] doubleValue];
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
        CLLocationCoordinate2D loc = [mapPoint coordinate];
        // [worldView addAnnotation:mapPoint];
        
        // Show the region on the Mapview
        // DELETE this when ready for next steps
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 250, 250);
        [[self sender] showMap:region];

        // Prepare buffer and declare toplevel node
        topLevel = nil;
        currentStringValue = nil;
    }
    
    else if ([elementName isEqualToString:@"time"] && [topLevel isEqualToString:@"wpt"]) {
        // Waypoint time is not important at the moment
        currentStringValue = nil;
    }
    
    else if ([elementName isEqualToString:@"sym"] && [topLevel isEqualToString:@"wpt"]) {
        [mapPoint setFlags:currentStringValue];
        currentStringValue = nil;
    }
    else if ([elementName isEqualToString:@"name"] && [topLevel isEqualToString:@"wpt"]) {
        [mapPoint setTitle:currentStringValue];
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

- (void)initialiseWayPoints
{
    for (mapPoint in mapPoints) {
        NSLog(@"Mappoint: %@", mapPoint);
    }
    // DELETE this when ready
    [sender addAnnotations:mapPoints];
    
    
}


#pragma mark Initialising
- (id)initWithFile:(NSURL *)fileName sender:(id)s
{
    int pointSpace = INITIAL_POINT_SPACE;
    
    self = [super init];
    if (self) {        
        trackpoints = malloc(sizeof(MKMapPoint) * pointSpace);
        pointCount = 0;
        
        mapPoints = [[NSMutableArray alloc] initWithCapacity:100];
        
        sender = s;
        [self parseXMLFile:fileName];
        startTime = [NSDate date];
        
        [self initialiseWayPoints];
      
    }
    return self;
}

- (MKPolyline *)poly
{
    NSLog(@"Pointcount for Poly is: %i", pointCount);
    
    return [MKPolyline polylineWithPoints:trackpoints count:pointCount];

}

- (id)init
{
    NSURL* url = [[NSBundle mainBundle] URLForResource:@"GpxViewer" withExtension:@"GPX"];
    return [self initWithFile:url sender:self];
}
@end
