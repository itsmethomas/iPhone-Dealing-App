//
//  DealmapViewController.m
//  DailyDeal
//
//  Created by Thomas Taussi on 7/31/14.
//  Copyright (c) 2014 ss. All rights reserved.
//

#import "DealmapViewController.h"
#import "MyAnnotationView.h"

@interface DealmapViewController ()

@end

@implementation DealmapViewController

@synthesize dealItem, mapView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // drop a pin;
    self.title = @"Deal on Map";
    
    CLLocationCoordinate2D coord;
    coord.latitude = dealItem.latitude;
    coord.longitude = dealItem.longtitude;
    
    MyAnnotationView *annotation = [[MyAnnotationView alloc] initWithCoordinate:coord addressDictionary:nil];
    annotation.title = dealItem.title;
    annotation.subtitle = dealItem.description;
    
    [mapView addAnnotation:annotation];
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 50000, 50000);
    [mapView setRegion:region];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
