//
//  GpxViewViewController.h
//  GpxView
//
//  Created by Mario Martelli on 08.03.13.
//  Copyright (c) 2013 Schnuddel Huddel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SHMapPoint.h"
#import "GpsTrack.h"
#import "WaypointViewController.h"

@interface GpxViewViewController : UIViewController <MKMapViewDelegate>
{
    IBOutlet MKMapView *worldView;
}

@end
