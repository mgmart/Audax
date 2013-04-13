//
//  CycleViewController.m
//  GpxView
//
//  Created by Mario Martelli on 30.03.13.
//  Copyright (c) 2013 Schnuddel Huddel. All rights reserved.
//

#import "CycleViewController.h"
#import "Controls.h"
#import "SHMapPoint.h"

@interface CycleViewController ()

@end

@implementation CycleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UITabBarItem *tbi = [self tabBarItem];
        [tbi setTitle:@"Cycle"];
        UIImage *i = [UIImage imageNamed:@"Cycle"];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[Controls sharedControls] allControls] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];
        [cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
    }
    SHMapPoint *p = [[[Controls sharedControls] allControls] objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:[p title]];
    [[cell detailTextLabel] setText:[p subtitle]];

    return cell;

}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"IndexPath: %@", indexPath);
}
@end
