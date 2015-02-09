//
//  DetailViewController.h
//  DailyDeal
//
//  Created by Thomas Taussi on 7/31/14.
//  Copyright (c) 2014 ss. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Social/Social.h>
#import <MessageUI/MessageUI.h>

#import "BlCategoryItem.h"
#import "BlUserInfo.h"

@interface DetailViewController : UIViewController <UINavigationControllerDelegate, MFMailComposeViewControllerDelegate,
                                                    UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate,
                                                    UIWebViewDelegate>
{
    int descHeight;
    
    IBOutlet UITableView *contentsTable;
}

@property (nonatomic, retain) BlCategoryItem *dealItem;
@property (nonatomic, retain) BlUserInfo *userInfo;

@property (nonatomic, retain) IBOutlet UILabel *timeRemainLabel;

- (IBAction) onBuyClicked:(id)sender;

- (void) onFacebookShare;
- (void) onTwitterShare;
- (void) onEmailShare;

@end
