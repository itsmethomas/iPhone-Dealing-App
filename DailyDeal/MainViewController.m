//
//  MainViewController.m
//  DailyDeal
//
//  Created by Thomas Taussi on 7/30/14.
//  Copyright (c) 2014 ss. All rights reserved.
//

#import "MainViewController.h"
#import "DealmapViewController.h"
#import "DetailViewController.h"

#import "Constants.h"

#import "JSON/JSON.h"
#import "BlCategoryItem.h"
#import "UIDealViewCell.h"
#import "ActivityIndicator.h"

#import "WatchListManager.h"
#import "SharedSoundPlayer.h"
#import "ConfigManager.h"

#import <FacebookSDK/FacebookSDK.h>

#define REFRESH_HEADER_HEIGHT 100.0f

#define CONNECTION_STATE_WATCHLIST  1000
#define CONNECTION_STATE_START      1001
#define CONNECTION_STATE_UPDATE     1002
#define CONNECTION_STATE_NEXTLOAD   1003


@interface MainViewController ()

@end

@implementation MainViewController

@synthesize userInfo;

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
    // Do any additional setup after loading the view.
    
    self.title = @"My Deals";
    dealsArray = [[NSMutableArray alloc] init];
    deletedIdArray = [[NSMutableArray alloc] init];
    
    [self searchDealsWithFilterItem:nil];
    
    // initializing Pull Table Settings.
    [self setupStrings];
    [self addPullToRefreshHeader];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) searchDealsWithFilterItem:(NSString*) filterURL {
    isLoading = YES;
    curFilterUrl = filterURL;
    curPageIndex = 0;
    
    [[ActivityIndicator currentIndicator] show];
    
    NSString* url = nil;

    if ([filterURL isEqualToString:@"WATCHLIST"]) {
        url = [NSString stringWithFormat:API_WATCHLIST_URL, userInfo.UID];
    } else {
        if (filterURL == nil) {
            url = [NSString stringWithFormat:@"%@&loctid=%@", API_GETDEAL_URL, self.userInfo.LOCATION_ID];
        } else {
            url = filterURL;
        }
    }
    
    // downloading data from Web Service API...
    curConnectionState = CONNECTION_STATE_START;
    responseData = [[NSMutableData alloc] init];
    
    NSLog(@"%@", url);
    NSURL *apiurl = [NSURL URLWithString:url];
    [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:apiurl] delegate:self];
}

- (void) updateNewDeals {
    NSString* url = nil;
    
    if (curFilterUrl == nil) {
        url = API_GETDEAL_URL;
    } else {
        url = curFilterUrl;
    }
    
    // downloading data from Web Service API...
    curConnectionState = CONNECTION_STATE_UPDATE;
    responseData = [[NSMutableData alloc] init];
    NSURL *apiurl = [NSURL URLWithString:url];
    [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:apiurl] delegate:self];
}


- (void) searchNextDeals{
    curPageIndex++;
    NSString* url = nil;
    
    if (curFilterUrl == nil) {
        url = [NSString stringWithFormat:@"%@&page=%d", API_GETDEAL_URL, curPageIndex];
    } else {
        url = [NSString stringWithFormat:@"%@&page=%d", curFilterUrl, curPageIndex];
    }
    
    // downloading data from Web Service API...
    curConnectionState = CONNECTION_STATE_NEXTLOAD;
    isLoading = YES;
    responseData = [[NSMutableData alloc] init];
    NSURL *apiurl = [NSURL URLWithString:url];
    [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:apiurl] delegate:self];
}

#pragma mark Connection Delegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
}
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return YES;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [[ActivityIndicator currentIndicator] hide];
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Cannot connect to server!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
    isLoading = NO;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [[ActivityIndicator currentIndicator] hide];
	NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
//    NSLog(@"%@", responseString);
    
    if (curConnectionState == CONNECTION_STATE_START)
        [dealsArray removeAllObjects];
    else
        [[SharedSoundPlayer sharedInstance] playSound:@"pop"];

    NSDictionary *dictionary = [[SBJsonParser new] objectWithString:responseString];
    NSArray *data_array = [dictionary objectForKey:@"deals"];
    if (data_array != nil) {
        int index = 0;
        for (int i=0; i<[data_array count]; i++) {
            NSDictionary *item = [data_array objectAtIndex:i];
            if (item == nil)
                continue;
            BlCategoryItem *category_item = [[BlCategoryItem alloc] init];
            
            category_item.dealId = [[item objectForKey:@"id"] integerValue];
            
            if (![self isNeeded:category_item.dealId]) {
                continue;
            }
            
            category_item.wId = [item objectForKey:@"wId"];
            category_item.title = [item objectForKey:@"title"];
            category_item.description = [item objectForKey:@"description"];
            category_item.category = [item objectForKey:@"category"];
            category_item.provider = [item objectForKey:@"provider"];
            category_item.location = [item objectForKey:@"location"];
            category_item.price = [((NSNumber*)[item objectForKey:@"price"]) doubleValue];
            category_item.bought = [((NSNumber*)[item objectForKey:@"bought"]) intValue];
            category_item.startDate = [self dateFromStr:[item objectForKey:@"start_date"]];
            category_item.endDate = [self dateFromStr:[item objectForKey:@"end_date"]];
            category_item.trackintUrl = [item objectForKey:@"trackint_url"];
            category_item.discount = [item objectForKey:@"discount"];
            category_item.imgUrl = [item objectForKey:@"image_url"];
            category_item.merchantAvatar = [item objectForKey:@"merchant_avatar"];
            category_item.latitude = [((NSNumber*)[item objectForKey:@"latitude"]) doubleValue];;
            category_item.longtitude = [((NSNumber*)[item objectForKey:@"longtitude"]) doubleValue];
            
            NSLog(@"%@", category_item.location);
            
            // setting date diff...
            int interval = (int)[category_item.endDate timeIntervalSinceDate:category_item.startDate];
            int dd = interval / 86400;
            int hh = (interval % 86400) / 3600;
            int mm = (interval % 3600) / 60;
            
            category_item.timeDD = [NSString stringWithFormat:@"%d", dd];
            category_item.timeHH = [NSString stringWithFormat:@"%d", hh];
            category_item.timeMM = [NSString stringWithFormat:@"%d", mm];
            
            // calculating Actual Prices...
            category_item.actualPrice = [self priceFromDiscount:category_item.price forDiscount:category_item.discount];
            
            if (curConnectionState == CONNECTION_STATE_UPDATE) {
                category_item.isNew = YES;
                [dealsArray insertObject:category_item atIndex:index];
            } else {
                category_item.isNew = NO;
                [dealsArray addObject:category_item];
            }
            
            index++;
        }
    }
    
    [dealTable reloadData];
    isLoading = NO;
    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:2.0];
    [self refreshBottomSpinnerPosition];
}

- (BOOL) isNeeded:(NSInteger)dId {
    for (int i = 0; i<[deletedIdArray count]; i++) {
        if ([[deletedIdArray objectAtIndex:i] integerValue] == dId)
            return NO;
    }
    
    for (int i = 0; i<[dealsArray count]; i++) {
        BlCategoryItem *item = [dealsArray objectAtIndex:i];
        if (item.dealId == dId)
            return NO;
    }
    
    return YES;
}

- (NSDate*) dateFromStr:(NSString*) dateStr {
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * date = [formatter dateFromString:dateStr];
    return date;
}

- (NSString*) priceFromDiscount:(double) price forDiscount:(NSString*) discount {
    double disPercentage = 0;
    
    NSString *dd = [discount substringToIndex:([discount length] - 1)];
    disPercentage = [dd doubleValue];
    
    double actualPrice = price / 100 * (100 - disPercentage);
    return [NSString stringWithFormat:@"$%.0f", actualPrice];
    
}

#pragma mark UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [dealsArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 240;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01f;
    } else {
        return 10;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UIDealViewCell *cell = (UIDealViewCell*)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UIDealViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    BlCategoryItem *item = [dealsArray objectAtIndex:indexPath.section];
    
    cell.titleLabel.text = item.title;
    cell.fullpriceLabel.text = [NSString stringWithFormat:@"$%.0f", item.price];
    cell.boughtLabel.text = [NSString stringWithFormat:@"%d", item.bought];
    cell.locationLabel.text = item.location;
    cell.discountLabel.text = item.discount;
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:item.imgUrl]];
    [req addValue:@"image/*" forHTTPHeaderField:@"Accept"];

    [cell.logoImageView setImageWithURLRequest:req placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                           item.thumbImage = image;
                                        } failure:nil];

    NSMutableURLRequest *req1 = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:item.provider]];
    [req1 addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    
    [cell.providerImageView setImageWithURLRequest:req1 placeholderImage:nil
                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                           item.providerImage = image;
                                       } failure:nil];
    
    cell.logoImageView.tag = indexPath.section;
    
    cell.priceLabel.text = item.actualPrice;
    cell.isnewLabel.hidden = !item.isNew;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BlCategoryItem *item = [dealsArray objectAtIndex:indexPath.section];
    DetailViewController *detailview = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailView"];
    detailview.dealItem = item;
    detailview.userInfo = userInfo;
    [self.navigationController pushViewController:detailview animated:YES];

}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        BlCategoryItem * item = [dealsArray objectAtIndex:indexPath.section];
        [deletedIdArray addObject:[NSNumber numberWithLong:item.dealId]];
        [dealsArray removeObjectAtIndex:indexPath.section];
        
        if ([curFilterUrl isEqualToString:@"WATCHLIST"]) {
            [[WatchListManager sharedInstance] removeWatchList:item.wId];
        }
        
        [tableView reloadData];
        [self refreshBottomSpinnerPosition];
//        [[SharedSoundPlayer sharedInstance] playSound:@"pop"];
    }
}


#pragma mark Button Events
- (IBAction) onFilterClicked:(id) sender {
    if (filterController == nil) {
        filterController = [self.storyboard instantiateViewControllerWithIdentifier:@"FilterView"];
        filterController.delegate = self;
        filterController.userInfo = self.userInfo;
    }
    [self presentViewController:filterController animated:YES completion:nil];
}

- (IBAction) onSortClicked:(id)sender {
    if ([curFilterUrl isEqualToString:@"WATCHLIST"])
        return;
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Sort By" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Popularity", @"Date Added", @"Price Low", @"Price High", nil];
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex < 4) {
        if (curFilterUrl == nil) {
            curFilterUrl = [NSString stringWithFormat:@"%@&sort=%ld", API_GETDEAL_URL, (long)buttonIndex];
        } else {
            curFilterUrl = [NSString stringWithFormat:@"%@&sort=%ld", curFilterUrl, (long) buttonIndex];
        }
        
        [self searchDealsWithFilterItem:curFilterUrl];
    }
}

- (void) didFinishWithFilteritems:(NSString*) filterURL forViewController:(UIViewController*) controller {
    [controller dismissViewControllerAnimated:YES completion:nil];
    
    [self searchDealsWithFilterItem:filterURL];
}

- (void)didFinishWithLogout:(UIViewController *)controller {
    [ConfigManager clearUserInfo];
    
    if (FBSession.activeSession.isOpen)
    {
        [FBSession.activeSession closeAndClearTokenInformation];
    }
    
    [controller dismissViewControllerAnimated:YES completion:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void) onMapViewClicked:(id) sender {
    UIButton *clickedBtn = (UIButton*) sender;
    BlCategoryItem *item = [dealsArray objectAtIndex:clickedBtn.tag];
    
    
    DealmapViewController *controller = (DealmapViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"DealmapView"];
    controller.dealItem = item;
    
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark Pulling Table...
- (void)setupStrings{
    textPull = @"Pull down to update new deals...";
    textRelease = @"Release to update new deals...";
    textLoading = @"Loading...";
}

- (void)addPullToRefreshHeader {
    refreshHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - REFRESH_HEADER_HEIGHT, 320, REFRESH_HEADER_HEIGHT)];
    refreshHeaderView.backgroundColor = [UIColor clearColor];
    
    refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, REFRESH_HEADER_HEIGHT)];
    refreshLabel.backgroundColor = [UIColor clearColor];
    refreshLabel.font = [UIFont boldSystemFontOfSize:12.0];
    refreshLabel.textAlignment = NSTextAlignmentCenter;
    
    refreshArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
    refreshArrow.frame = CGRectMake(floorf((REFRESH_HEADER_HEIGHT - 20) / 2),
                                    (floorf(REFRESH_HEADER_HEIGHT - 26) / 2),
                                    20, 26);
    
    bottomSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    bottomSpinner.frame = CGRectMake(-1000, -1000, 20, 20);
    bottomSpinner.hidesWhenStopped = NO;
    
    refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    refreshSpinner.frame = CGRectMake(floorf(floorf(REFRESH_HEADER_HEIGHT - 20) / 2), floorf((REFRESH_HEADER_HEIGHT - 20) / 2), 20, 20);
    refreshSpinner.hidesWhenStopped = YES;
    
    [refreshHeaderView addSubview:refreshLabel];
    [refreshHeaderView addSubview:refreshArrow];
    [refreshHeaderView addSubview:refreshSpinner];
    [dealTable addSubview:refreshHeaderView];
    [dealTable addSubview:bottomSpinner];
}

- (void) refreshBottomSpinnerPosition {
    refreshHeaderView.frame = CGRectMake(0, 0 - REFRESH_HEADER_HEIGHT, 320, REFRESH_HEADER_HEIGHT);
    
    if ([dealsArray count] == 0) {
        bottomSpinner.frame = CGRectMake(-1000, -1000, 20, 20);
    } else {
        bottomSpinner.frame = CGRectMake([dealTable contentSize].width / 2 - 10, [dealTable contentSize].height, 20, 20);
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (isLoading) return;
    isDragging = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (isLoading) {
        // Update the content inset, good for section headers
        if (scrollView.contentOffset.y > 0)
            dealTable.contentInset = UIEdgeInsetsZero;
        else if (scrollView.contentOffset.y >= -REFRESH_HEADER_HEIGHT)
            dealTable.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (isDragging && scrollView.contentOffset.y < 0) {
        // Update the arrow direction and label
        [UIView animateWithDuration:0.25 animations:^{
            if (scrollView.contentOffset.y < -REFRESH_HEADER_HEIGHT) {
                // User is scrolling above the header
                refreshLabel.text = textRelease;
                [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
            } else {
                // User is scrolling somewhere within the header
                refreshLabel.text = textPull;
                [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
            }
        }];
    } else if (isDragging && scrollView.contentOffset.y + scrollView.frame.size.height> scrollView.contentSize.height) {
        if (scrollView.contentOffset.y + scrollView.frame.size.height> scrollView.contentSize.height + REFRESH_HEADER_HEIGHT) {
            [bottomSpinner startAnimating];
        } else {
            [bottomSpinner stopAnimating];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (isLoading) return;
    isDragging = NO;
    if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT) {
        [self startLoading];
    } else if (scrollView.contentOffset.y + scrollView.frame.size.height > dealTable.contentSize.height + REFRESH_HEADER_HEIGHT / 2){
        [self startNextLoading];
    }
}

- (void)startNextLoading {
    isLoading = YES;
    
    if ([curFilterUrl isEqualToString:@"WATCHLIST"]) {
        [self performSelector:@selector(stopLoading) withObject:nil afterDelay:2.0];
    } else {
        [self searchNextDeals];
    }
}

- (void)startLoading {
    isLoading = YES;
    
    // Show the header
    [UIView animateWithDuration:0.3 animations:^{
        dealTable.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
        refreshLabel.text = textLoading;
        refreshArrow.hidden = YES;
        [refreshSpinner startAnimating];
    }];
    
    // Refresh action!
    [self refresh];
}

- (void)stopLoading {
    isLoading = NO;
    
    // Hide the header
    [UIView animateWithDuration:0.3 animations:^{
        dealTable.contentInset = UIEdgeInsetsZero;
        [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
    }
                     completion:^(BOOL finished) {
                         [self performSelector:@selector(stopLoadingComplete)];
                     }];
}

- (void)stopLoadingComplete {
    // Reset the header
    refreshLabel.text = textPull;
    refreshArrow.hidden = NO;
    [refreshSpinner stopAnimating];
}

- (void)refresh {
    curConnectionState = CONNECTION_STATE_UPDATE;
    if ([curFilterUrl isEqualToString:@"WATCHLIST"]) {
        [self performSelector:@selector(stopLoading) withObject:nil afterDelay:2.0];
    } else {
        [self updateNewDeals];
    }
}


@end
