//
//  GpxViewViewController.m
//  GpxView
//
//  Created by Mario Martelli on 08.03.13.
//  Copyright (c) 2013 Schnuddel Huddel. All rights reserved.
//

#import "GpxViewViewController.h"

@interface GpxViewViewController ()

@end

@implementation GpxViewViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    SHMapPoint *point = [[SHMapPoint alloc] init];
    [worldView addAnnotation:point];
    
    NSURL* url = [[NSBundle mainBundle] URLForResource:@"GpxViewer" withExtension:@"GPX"];
    GpsTrack *track = [[GpsTrack alloc] initWithFile:url sender:self];
    NSLog(@"Distance is: %f", [track length]);
    MKPolyline *poly = [track poly];
//    NSLog(@"Poly: %@, %@", poly.)
    
    [worldView addOverlay:poly];

}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolygon class]]) {
        MKPolygonView *view = [[MKPolygonView alloc] initWithOverlay:overlay];
        
        // Display settings
        [view setLineWidth:1];
        [view setStrokeColor:[UIColor blueColor]];
        [view setFillColor:[[UIColor blueColor] colorWithAlphaComponent:0.5]];
        return view;
    }
    else if ([overlay isKindOfClass:[MKPolyline class]]){
        MKPolylineView *view = [[MKPolylineView alloc] initWithOverlay:overlay];
        [view setLineWidth:3];
        [view setStrokeColor:[UIColor blueColor]];
        return view;
    }
    return nil;
}



// DELETE this when ready for next steps
- (void)showMap:(MKCoordinateRegion)region
{
    [worldView setRegion:region animated:YES];
}

- (void)addAnnotations:(NSArray *)annotations
{
    SHMapPoint *mapPoint;
    for (mapPoint in annotations){
        [worldView addAnnotation:mapPoint];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
