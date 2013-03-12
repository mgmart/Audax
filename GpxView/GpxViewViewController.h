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

@interface GpxViewViewController : UIViewController <NSXMLParserDelegate, MKMapViewDelegate>
{
    NSXMLParser *addressParser;
    IBOutlet MKMapView *worldView;
    SHMapPoint *mapPoint;
    NSMutableString *currentStringValue;
    NSString *topLevel;
}

@end
