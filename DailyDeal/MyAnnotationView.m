//
//  MyAnnotationView.m
//  DailyDeal
//
//  Created by Thomas Taussi on 7/31/14.
//  Copyright (c) 2014 ss. All rights reserved.
//

#import "MyAnnotationView.h"

@implementation MyAnnotationView

@synthesize title, subtitle, coordinate;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coord addressDictionary:(NSDictionary *)addressDictionary
{
    if ((self = [super initWithCoordinate:coord addressDictionary:addressDictionary]))
    {
        self.coordinate = coord;
    }
    return self;
}

@end