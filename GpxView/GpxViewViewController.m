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

    //  NSURL* url = [[NSBundle mainBundle] URLForResource:@"GpxViewer" withExtension:@"GPX"];
    NSURL* url = [[NSBundle mainBundle] URLForResource:@"Ardennen 300" withExtension:@"GPX"];

    GpsTrack *track = [[GpsTrack alloc] initWithFile:url];
    [worldView addAnnotations:[track controls]];
    
    // Draw track
    MKPolyline *poly = [track poly];
    [worldView addOverlay:poly];
    [worldView setRegion:[track region] animated:YES];
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

#pragma mark Annotations

// Provides view for Pin Annotations
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[SHMapPoint class]]) {
        static NSString *annotationIdentifier = @"annotationIdentifier";
        // Try to get an unused annotation
        MKAnnotationView *annotationView = [worldView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
        annotationView.annotation = annotation;
        
        // If one isn't available create a new one
        if (!annotationView) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
        }
        
        // Optional properties to change
        [annotationView setCanShowCallout:YES];
        [annotationView setRightCalloutAccessoryView:[UIButton buttonWithType:UIButtonTypeDetailDisclosure]];
        
        return annotationView;
    }
    return nil;
}

// Show Detail View when annotation button was pressed
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    SHMapPoint *ann = [view annotation];
    WaypointViewController *wvc = [[WaypointViewController alloc] initWithTitle:[ann title] subtitle:[ann subtitle]];
    [wvc setModalTransitionStyle:UIModalTransitionStylePartialCurl];
    [self presentViewController:wvc animated:YES completion:^{}];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
