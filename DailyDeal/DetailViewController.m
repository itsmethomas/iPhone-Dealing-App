//
//  DetailViewController.m
//  DailyDeal
//
//  Created by Thomas Taussi on 7/31/14.
//  Copyright (c) 2014 ss. All rights reserved.
//

#import "DetailViewController.h"
#import "DetailMainCell.h"
#import "DetailDTitleCell.h"
#import "DetailDescCell.h"
#import "WatchListManager.h"

#import "SharedSoundPlayer.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

@synthesize dealItem, userInfo;

@synthesize timeRemainLabel;

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
    
    // initializing titles....
    self.title = dealItem.title;
    UIBarButtonItem *btnShare = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(onActionClicked)];
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(onBacked)];
    [self.navigationItem setLeftBarButtonItem:btnBack];
    [self.navigationItem setRightBarButtonItem:btnShare];
    
    timeRemainLabel.text = [NSString stringWithFormat:@"%@ days, %@:%@", dealItem.timeDD, dealItem.timeHH, dealItem.timeMM];
    descHeight = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01f;
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return 80.0f;
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 359;
    } else {
        if (indexPath.row == 0) {
            return 40;
        } else {
            return descHeight == 0 ? 300 : descHeight;
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        DetailMainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainCell"];
        if (cell == nil) {
            cell = [[DetailMainCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MainCell"];
        }
        
        cell.logoImage.image = dealItem.thumbImage;
        cell.providerImage.image = dealItem.providerImage;
        cell.titleLabel.text = dealItem.title;
        cell.locationLabel.text = dealItem.location;
        cell.fullPriceLabel.text = [NSString stringWithFormat:@"$%.0f", dealItem.price];
        cell.actualPriceLabel.text = dealItem.actualPrice;
        cell.discountLabel.text = dealItem.discount;
        cell.boughtLabel.text = [NSString stringWithFormat:@"%d", dealItem.bought];
        
        return cell;
    } else {
        if (indexPath.row == 0) {
            DetailDTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DescTitleCell"];
            if (cell == nil) {
                cell = [[DetailDTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DescTitleCell"];
            }
            
            cell.titleLabel.text = @"Description";
            
            return cell;
        } else {
            DetailDescCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DescCell"];
            if (cell == nil) {
                cell = [[DetailDescCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DescCell"];
            }
            
            cell.descriptionView.delegate = self;
            [cell.descriptionView loadHTMLString:[NSString stringWithFormat:@"<html><body style=\"font-family:Avenir; color:#777777\">%@</body>", dealItem.description] baseURL:nil];
            
            return cell;
        }
    }
}

#pragma mark Web View Delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (descHeight == 0) {
        descHeight = webView.scrollView.contentSize.height + 20;
        webView.scrollView.scrollEnabled = NO;
        [contentsTable reloadData];
    }
}

#pragma mark UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) { // Facebook
        [self onFacebookShare];
    } else if (buttonIndex == 1) { // Twitter
        [self onTwitterShare];
    } else if (buttonIndex == 2) { // Email
        [self onEmailShare];
    } else if (buttonIndex == 3) { // WatchList
        [self onAddToWatchlist];
    }
}

#pragma mark Button Delegate
- (IBAction) onBuyClicked:(id)sender {
    NSURL *buyURL = [NSURL URLWithString:dealItem.trackintUrl];
    
    [[UIApplication sharedApplication] openURL:buyURL];
}

- (void) onActionClicked {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Share" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Facebook", @"Twitter", @"Email", @"Save to Watch List", nil];
    [sheet showInView:self.view];
}

- (void) onBacked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) onFacebookShare {
    SLComposeViewController *facebookSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    [facebookSheet setInitialText:dealItem.title];
    [facebookSheet addImage:dealItem.thumbImage];
    [facebookSheet addURL:[NSURL URLWithString:dealItem.trackintUrl]];
    
    [self presentViewController:facebookSheet animated:YES completion:nil];
}
- (void) onTwitterShare {
    SLComposeViewController *twitterSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [twitterSheet setInitialText:dealItem.title];
    [twitterSheet addImage:dealItem.thumbImage];
    [twitterSheet addURL:[NSURL URLWithString:dealItem.trackintUrl]];
    
    [self presentViewController:twitterSheet animated:YES completion:nil];
    
}
- (void) onEmailShare {
    // sending a bill to MyUtilityGenuis
    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    
    // setting mail contents...
    [controller setSubject:dealItem.title];

    NSString *body = [NSString stringWithFormat:@"<a href=\"%@\">%@</a><br/>%@", dealItem.trackintUrl, dealItem.title, dealItem.description];
    [controller setMessageBody:body isHTML:YES];
    
    // [self presentModalViewController:controller animated:YES];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void) onAddToWatchlist {
    [[WatchListManager sharedInstance] addToWatchList:userInfo.UID forNid:[NSString stringWithFormat:@"%ld", dealItem.dealId]];

//    [[SharedSoundPlayer sharedInstance] playSound:@"pop"];
}

#pragma mark Mail Compose Delegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
