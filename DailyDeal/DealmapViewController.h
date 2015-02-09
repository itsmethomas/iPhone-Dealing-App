//
//  DealmapViewController.h
//  DailyDeal
//
//  Created by Thomas Taussi on 7/31/14.
//  Copyright (c) 2014 ss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BlCategoryItem.h"

@interface DealmapViewController : UIViewController

@property (nonatomic, retain) BlCategoryItem* dealItem;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;

@end
