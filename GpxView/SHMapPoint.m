//
//  SHMapPoint.m
//  GpxView
//
//  Created by Mario Martelli on 10.03.13.
//  Copyright (c) 2013 Schnuddel Huddel. All rights reserved.
//

#import "SHMapPoint.h"

@implementation SHMapPoint

@synthesize coordinate, title, time, flags, toDistance, fromDistance;

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
    return [[NSString alloc] initWithFormat:@"Title: %@, Created: %@, Symbol: %@", title, time, flags];
}
@end
