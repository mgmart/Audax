//
//  GpsTrack.h
//  GpxView
//
//  Created by Mario Martelli on 12.03.13.
//  Copyright (c) 2013 Schnuddel Huddel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
// #import <CoreLocation/CoreLocation.h>

#define INITIAL_POINT_SPACE 3000

@class SHMapPoint;

@interface GpsTrack : NSObject  <NSXMLParserDelegate>
{
    // Trackpoints
    // MKMapPoint *point;
    MKMapPoint *trackpoints;
    int pointCount;
    
    NSMutableArray *coordinates;
    
    // Used for WayPoints & Annotation
    SHMapPoint *mapPoint;
    NSMutableArray *mapPoints;
    
    // XML Parser variables
    NSXMLParser *addressParser;
    NSMutableString *currentStringValue;
    NSString *topLevel;
}

@property (nonatomic, copy) NSDate *startTime, *elapsedTime, *remainingTime;
@property (nonatomic, copy) id sender;
@property (nonatomic, copy, readonly) MKPolyline *poly;
@property (nonatomic, copy) NSMutableArray *segments;

- (id)initWithFile:(NSURL *)fileName;
- (double)length;
- (MKCoordinateRegion)region;
- (NSArray *)controls;
@end
