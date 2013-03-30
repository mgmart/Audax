//
//  AtAGlanceViewController.m
//  GpxView
//
//  Created by Mario Martelli on 30.03.13.
//  Copyright (c) 2013 Schnuddel Huddel. All rights reserved.
//

#import "AtAGlanceViewController.h"

@interface AtAGlanceViewController ()

@end

@implementation AtAGlanceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UITabBarItem *tbi = [self tabBarItem];
        [tbi setTitle:@"At A Glance"];
        UIImage *i = [UIImage imageNamed:@"AtAGlance"];
        [tbi setImage:i];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
