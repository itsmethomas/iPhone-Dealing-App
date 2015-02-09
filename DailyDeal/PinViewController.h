//
//  PinViewController.h
//  DailyDeal
//
//  Created by Thomas Taussi on 7/31/14.
//  Copyright (c) 2014 ss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@protocol PinViewDelegate<NSObject>

- (void) didFinishedWithCoordinate:(CLLocationCoordinate2D) pinnedLoc forView:(UIViewController*) controller;

@end


@interface PinViewController : UIViewController

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, assign) id<PinViewDelegate> delegate;

- (IBAction) onCancel:(id)sender;
- (IBAction) onDone:(id)sender;

@end

