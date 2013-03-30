//
//  GpxViewAppDelegate.h
//  GpxView
//
//  Created by Mario Martelli on 08.03.13.
//  Copyright (c) 2013 Schnuddel Huddel. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GpxViewViewController;
@class SettingsViewController;
@class CycleViewController;
@class AtAGlanceViewController;

@interface GpxViewAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) GpxViewViewController *viewController;
@property (strong, nonatomic) SettingsViewController *settingsController;
@property (strong, nonatomic) CycleViewController *cycleViewController;
@property (strong, nonatomic) UITabBarController *tabBarController;
@property (strong, nonatomic) AtAGlanceViewController *atAGlanceViewController;
@end
