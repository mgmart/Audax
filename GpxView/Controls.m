//
//  Controls.m
//  Audax
//
//  Created by Mario Martelli on 03.04.13.
//  Copyright (c) 2013 Schnuddel Huddel. All rights reserved.
//

#import "Controls.h"
#import "SHMapPoint.h"

@implementation Controls

+ (Controls *)sharedControls
{
    static Controls *sharedControls = nil;
    if (!sharedControls) {
        sharedControls = [[super allocWithZone:nil] init];
    }
    return sharedControls;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedControls];
}

- (id)init
{
    self = [super init];
    if (self) {
        allControls = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSArray *)allControls
{
    return allControls;
}

- (void)createControl:(SHMapPoint *)control
{
    [allControls addObject:control];
    [allControls sortUsingSelector:@selector(compare:)];
}
@end
