//
//  Controls.h
//  Audax
//
//  Created by Mario Martelli on 03.04.13.
//  Copyright (c) 2013 Schnuddel Huddel. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SHMapPoint;
@interface Controls : NSObject
{
    NSMutableArray *allControls;
}

+ (Controls *)sharedControls;

- (NSArray *)allControls;
- (void)createControl:(SHMapPoint *)control;

@end
