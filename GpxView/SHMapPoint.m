//
//  SHMapPoint.m
//  GpxView
//
//  Created by Mario Martelli on 10.03.13.
//  Copyright (c) 2013 Schnuddel Huddel. All rights reserved.
//

#import "SHMapPoint.h"

@implementation SHMapPoint

@synthesize coordinate, title, time, flags, toDistance, fromDistance, order;

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

- (NSString *)description
{
    return [[NSString alloc] initWithFormat:@"Title: %@, Order: %@, Symbol: %@", title, order, flags];
}

/*
 * compare trading info's based on their trade date so they sort acording to their date
 */
- (NSComparisonResult)compare:(id)obj2 {
    return [[self order] compare:[obj2 order]];
}

@end
