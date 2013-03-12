//
//  SHMapPoint.m
//  GpxView
//
//  Created by Mario Martelli on 10.03.13.
//  Copyright (c) 2013 Schnuddel Huddel. All rights reserved.
//

#import "SHMapPoint.h"

@implementation SHMapPoint

@synthesize coordinate, title, time, flags;

- (id)initWithCoordinate:(CLLocationCoordinate2D)c title:(NSString *)t
{
    self = [super init];
    if (self) {
        coordinate = c;
        [self setTitle:t];
    }
    return self;
}

- (id)init {
    return [self initWithCoordinate:CLLocationCoordinate2DMake(50.68200, 7.14634) title:@"BJCastle"];
}

@end
