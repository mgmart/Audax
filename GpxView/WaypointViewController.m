//
//  WaypointViewController.m
//  GpxView
//
//  Created by Mario Martelli on 18.03.13.
//  Copyright (c) 2013 Schnuddel Huddel. All rights reserved.
//

#import "WaypointViewController.h"

@interface WaypointViewController ()

@end

@implementation WaypointViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle
{
    self = [super init];
    if (self) {
        myTitle = title;
        mySubtitle = subtitle;
        myTime = [NSDate date];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[self titleLabel] setText:myTitle];
    [[self subtitleLabel] setText:mySubtitle];
    [[self timeLabel] setText:[myTime description]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
