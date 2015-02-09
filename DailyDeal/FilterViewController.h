//
//  FilterViewController.h
//  DailyDeal
//
//  Created by Thomas Taussi on 7/31/14.
//  Copyright (c) 2014 ss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PinViewController.h"
#import "BlUserInfo.h"

@protocol FilterViewDelegate <NSObject>

- (void) didFinishWithFilteritems:(NSString*) filterURL forViewController:(UIViewController*) controller;
- (void) didFinishWithLogout:(UIViewController*) controller;

@end

@interface FilterViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, PinViewDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate>{
    NSMutableArray *filterTitleArray;
    NSArray *filterHeaderArray;
    
    NSMutableArray *locSelArray;
    NSMutableArray *catSelArray;
    NSMutableArray *providerSelArray;
    
    NSMutableArray *categoryTitleArray;
    NSMutableArray *categoryIdArray;
    
    NSMutableArray *providerNameArray;
    
    NSMutableData *responseData;
    
    IBOutlet UITableView *filterItemsTable;
}

@property (nonatomic, assign) id<FilterViewDelegate> delegate;
@property (nonatomic, retain) BlUserInfo *userInfo;

- (IBAction) onCancel:(id)sender;
- (IBAction) onDone:(id)sender;
@end
