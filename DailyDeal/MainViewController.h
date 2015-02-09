//
//  MainViewController.h
//  DailyDeal
//
//  Created by Thomas Taussi on 7/30/14.
//  Copyright (c) 2014 ss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterViewController.h"

#import "BlUserInfo.h"

@interface MainViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, NSURLConnectionDelegate, FilterViewDelegate, UIActionSheetDelegate> {
    IBOutlet UITableView* dealTable;
    NSMutableArray *dealsArray;
    NSMutableArray *deletedIdArray;
    NSMutableData *responseData;
    
    // for Reload by pulling...
    UIView *refreshHeaderView;
    UILabel *refreshLabel;
    UIImageView *refreshArrow;
    UIActivityIndicatorView *refreshSpinner;
    BOOL isDragging;
    BOOL isLoading;
    NSString *textPull;
    NSString *textRelease;
    NSString *textLoading;
    UIActivityIndicatorView *bottomSpinner;
    
    FilterViewController *filterController;
    
    NSString *curFilterUrl;
    int curPageIndex;
    int curConnectionState;
}

@property (nonatomic, retain) BlUserInfo *userInfo;

- (void) searchDealsWithFilterItem:(NSString*) filterURL;

- (IBAction) onFilterClicked:(id) sender;
- (void) onMapViewClicked:(id) sender;

@end
