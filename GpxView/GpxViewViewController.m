//
//  GpxViewViewController.m
//  GpxView
//
//  Created by Mario Martelli on 08.03.13.
//  Copyright (c) 2013 Schnuddel Huddel. All rights reserved.
//

#import "GpxViewViewController.h"

@interface GpxViewViewController ()

@end

@implementation GpxViewViewController


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
//    NSLog(@"elementName: %@", elementName);
//    NSLog(@"namespaceURI: %@", namespaceURI);
//    NSLog(@"qualifiedName: %@", qName);
//    NSLog(@"Count of attributes %ul", [attributeDict count]);
    
    // Waypoint information
    if ( [elementName isEqualToString:@"trkpt"]) {
     //   NSLog(@"keys %@ and values %@", [attributeDict allKeys], [attributeDict allValues]);
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
        
        CLLocationCoordinate2D loc = [mapPoint coordinate];
        [worldView addAnnotation:mapPoint];
        // Show the region on the Mapview
        // DELETE this when ready for next steps
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 250, 250);
        [worldView setRegion:region animated:YES];
        
        // Prepare buffer and declare toplevel node
        topLevel = nil;
        currentStringValue = nil;
    }
    
    else if ([elementName isEqualToString:@"time"] && [topLevel isEqualToString:@"wpt"]) {
        // Waypoint time is not important at the moment
        NSLog(@"Tell me what time it is! %@", currentStringValue);
        currentStringValue = nil;
    }
    
    else if ([elementName isEqualToString:@"sym"] && [topLevel isEqualToString:@"wpt"]) {
        // Waypoint time is not important at the moment
        NSLog(@"Flag is: %@", currentStringValue);
        currentStringValue = nil;
    }
    else if ([elementName isEqualToString:@"name"] && [topLevel isEqualToString:@"wpt"]) {
        // Waypoint time is not important at the moment
        [mapPoint setTitle:currentStringValue];
        currentStringValue = nil;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
   // NSLog(@"foundcharacters: '%@'", string);
    if (!currentStringValue) {
        // currentStringValue is an NSMutableString instance variable
        currentStringValue = [[NSMutableString alloc] initWithCapacity:50];
    }
    [currentStringValue appendString:string];
}


- (NSData*)readDataFromFileAtURL:(NSURL*)anURL {
    NSFileHandle* aHandle = [NSFileHandle fileHandleForReadingFromURL:anURL error:nil];
    NSData* fileContents = nil;
    
    if (aHandle)
        fileContents = [aHandle readDataToEndOfFile];
    
    return fileContents;
}


- (void)parseXMLFile:(NSURL *)xmlURL {
    BOOL success;
  //  NSURL *xmlURL = [NSURL fileURLWithPath:pathToFile];
    addressParser = [[NSXMLParser alloc] initWithContentsOfURL:xmlURL];
    [addressParser setDelegate:self];
    [addressParser setShouldResolveExternalEntities:YES];
    success = [addressParser parse]; // return value not used
    // if not successful, delegate is informed of error
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"MkWorld width is: %f", MKMapSizeWorld.width);
    
    SHMapPoint *point = [[SHMapPoint alloc] init];
    [worldView addAnnotation:point];
    
    NSURL* url = [[NSBundle mainBundle] URLForResource:@"GpxViewer" withExtension:@"GPX"];
    NSLog(@"File is: %@", url);
    
//    NSData *gpxFile = [self readDataFromFileAtURL:url];
//    NSLog(@"gpxFile => %@", gpxFile);
    [self parseXMLFile:url];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
