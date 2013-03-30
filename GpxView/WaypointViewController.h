//
//  WaypointViewController.h
//  GpxView
//
//  Created by Mario Martelli on 18.03.13.
//  Copyright (c) 2013 Schnuddel Huddel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaypointViewController : UIViewController
{
    NSString *myTitle;
    NSString *mySubtitle;
    NSDate *myTime;
}
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

- (id)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle time:(NSDate *)time;
@end
