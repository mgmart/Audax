//
//  SHMapPoint.h
//  GpxView
//
//  Created by Mario Martelli on 10.03.13.
//  Copyright (c) 2013 Schnuddel Huddel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface SHMapPoint : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSDate *time;
@property (nonatomic, copy) NSString *flags;
@property (nonatomic) CLLocationDistance toDistance, fromDistance;
@property (nonatomic) NSNumber *order;
@property (nonatomic, copy) NSNumber *nearestPointIndex;

- (id)initWithCoordinate:(CLLocationCoordinate2D)c title:(NSString *)t;
- (NSComparisonResult)compare:(id)obj2;

@end
