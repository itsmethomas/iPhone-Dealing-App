//
//  FilterViewController.m
//  DailyDeal
//
//  Created by Thomas Taussi on 7/31/14.
//  Copyright (c) 2014 ss. All rights reserved.
//

#import "FilterViewController.h"

#import "UIPinViewCell.h"
#import "UICheckViewCell.h"
#import "UIImageView+AFNetworking.h"

#import "JSON.h"

#import "Constants.h"

@interface FilterViewController ()

@end

@implementation FilterViewController

@synthesize delegate, userInfo;

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
    
    // initializing variables...
    filterTitleArray = [[NSMutableArray alloc] init];
    [filterTitleArray addObject:@[@"Logout"]];
    [filterTitleArray addObject:@[@"WatchList"]];
    [filterTitleArray addObject:@[@"Sydney", @"Melbourne", @"Brisbane", @"Perth", @"All Others"]];
    [filterTitleArray addObject:@[]];
    [filterTitleArray addObject:@[]];
    
    filterHeaderArray = @[@"Filter Categories", @"Locations", @"Categories", @"Providers", @""];
    
    locSelArray = [[NSMutableArray alloc] initWithObjects:@"0", @"0", @"0", @"0", @"0", nil];
    
    // for Set Loc Id..
    NSDictionary *locDic = @{@"15":[NSNumber numberWithInt:0], @"44":[NSNumber numberWithInt:1], @"39":[NSNumber numberWithInt:2], @"43":[NSNumber numberWithInt:3]};
    if ([locDic objectForKey:userInfo.LOCATION_ID]) {
        int index = [((NSNumber*)[locDic objectForKey:userInfo.LOCATION_ID]) intValue];
        [locSelArray setObject:@"1" atIndexedSubscript:index];
    } else {
        [locSelArray setObject:@"1" atIndexedSubscript:4];
    }
    
    // loading Categories...
    NSURL *categoryURL = [NSURL URLWithString:API_CATEGORY_URL];
    responseData = [[NSMutableData alloc] init];
    [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:categoryURL] delegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark URL Connection Delegate
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
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Cannot connect to server!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    
    NSDictionary *dictionary = [[SBJsonParser new] objectWithString:responseString];
    NSArray *data_array = [dictionary objectForKey:@"categories"];
    
    categoryIdArray = [[NSMutableArray alloc] init];
    categoryTitleArray = [[NSMutableArray alloc] init];
    catSelArray = [[NSMutableArray alloc] init];
    
    if (data_array != nil) {
        for (int i=0; i<[data_array count]; i++) {
            NSDictionary *item = [data_array objectAtIndex:i];
            if (item == nil)
                continue;
            
            [categoryIdArray addObject:[item objectForKey:@"title"]];
            [categoryTitleArray addObject:[item objectForKey:@"description"]];
            [catSelArray addObject:@"1"];
        }
    }
    
    [filterTitleArray setObject:categoryTitleArray atIndexedSubscript:3];
    
    // providers
    providerNameArray = [[NSMutableArray alloc] init];
    providerSelArray = [[NSMutableArray alloc] init];
    data_array = [dictionary objectForKey:@"providers"];
    if (data_array != nil) {
        for (int i=0; i<[data_array count]; i++) {
            NSDictionary *item = [data_array objectAtIndex:i];
            if (item == nil)
                continue;
            
            [providerNameArray addObject:[item objectForKey:@"name"]];
            [providerSelArray addObject:@"1"];
        }
    }
    [filterTitleArray setObject:providerNameArray atIndexedSubscript:4];
    
    [filterItemsTable reloadData];
}


#pragma mark UITableView...
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [filterHeaderArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = [filterTitleArray objectAtIndex:section];
    if (section == 3 || section == 4) {
        if ([arr count] == 0)
            return 1;
    }
    return [arr count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [filterHeaderArray objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *arr = [filterTitleArray objectAtIndex:indexPath.section];
    if (indexPath.section == 1) {
        UIPinViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PinCell"];
        if (cell == nil) {
            cell = [[UIPinViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NormalCell"];
        }
        
        cell.titleLabel.text = [arr objectAtIndex:indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
    } else if (indexPath.section == 2) {
        UICheckViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NormalCell"];
        if (cell == nil) {
            cell = [[UICheckViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NormalCell"];
        }
        
        NSString *checked = [locSelArray objectAtIndex:indexPath.row];
        if ([checked isEqualToString:@"0"]) {
            cell.checkImageView.image = nil;
        } else {
            cell.checkImageView.image = [UIImage imageNamed:@"checked.PNG"];
        }
        cell.titleLabel.text = [arr objectAtIndex:indexPath.row];
        cell.loader.hidden = YES;
        
        return cell;
    } else if (indexPath.section == 3) {
        UICheckViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NormalCell"];
        if (cell == nil) {
            cell = [[UICheckViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NormalCell"];
        }
        
        if ([arr count] == 0) {
            cell.titleLabel.hidden = YES;
            cell.loader.hidden = NO;
        } else {
            cell.titleLabel.hidden = NO;
            cell.loader.hidden = YES;
            cell.titleLabel.text = [arr objectAtIndex:indexPath.row];
            
            NSString *checked = [catSelArray objectAtIndex:indexPath.row];
            if ([checked isEqualToString:@"0"]) {
                cell.checkImageView.image = nil;
            } else {
                cell.checkImageView.image = [UIImage imageNamed:@"checked.PNG"];
            }
        }
        
        return cell;
    } else if (indexPath.section == 4) {
        UICheckViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NormalCell"];
        if (cell == nil) {
            cell = [[UICheckViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NormalCell"];
        }
        
        if ([arr count] == 0) {
            cell.titleLabel.hidden = YES;
            cell.loader.hidden = NO;
        } else {
            cell.titleLabel.hidden = NO;
            cell.loader.hidden = YES;
            cell.titleLabel.text = [arr objectAtIndex:indexPath.row];
            
            NSString *checked = [providerSelArray objectAtIndex:indexPath.row];
            if ([checked isEqualToString:@"0"]) {
                cell.checkImageView.image = nil;
            } else {
                cell.checkImageView.image = [UIImage imageNamed:@"checked.PNG"];
            }
        }
        
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LogoutCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LogoutCell"];
        }
        
        if (userInfo.FACEBOOK_IMG_URL != nil) {
            NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:userInfo.FACEBOOK_IMG_URL]];
            [req addValue:@"image/*" forHTTPHeaderField:@"Accept"];
            
            [cell.imageView setImageWithURLRequest:req placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                                               success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                   

                                            } failure:nil];

            cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
            cell.textLabel.text = [NSString stringWithFormat:@"Logout (%@)", userInfo.NAME];
        } else {
            cell.textLabel.text = @"Logout";
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        [delegate didFinishWithFilteritems:@"WATCHLIST" forViewController:self];
    } else if (indexPath.section == 2) {
        NSString *checked = [locSelArray objectAtIndex:indexPath.row];
        if ([checked isEqualToString:@"0"]) {
            [locSelArray setObject:@"1" atIndexedSubscript:indexPath.row];
        } else {
            [locSelArray setObject:@"0" atIndexedSubscript:indexPath.row];
        }
    } else if (indexPath.section == 3){
        NSString *checked = [catSelArray objectAtIndex:indexPath.row];
        if ([checked isEqualToString:@"0"]) {
            [catSelArray setObject:@"1" atIndexedSubscript:indexPath.row];
        } else {
            [catSelArray setObject:@"0" atIndexedSubscript:indexPath.row];
        }
    } else if (indexPath.section == 4){
        NSString *checked = [providerSelArray objectAtIndex:indexPath.row];
        if ([checked isEqualToString:@"0"]) {
            [providerSelArray setObject:@"1" atIndexedSubscript:indexPath.row];
        } else {
            [providerSelArray setObject:@"0" atIndexedSubscript:indexPath.row];
        }
    } else {
        [delegate didFinishWithLogout:self];
    }
    [tableView reloadData];
}

#pragma mark Button Events
- (IBAction) onCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction) onDone:(id)sender {
    NSString* params = @"";
    for (int i=0; i<[locSelArray count]; i++) {
        params = [params stringByAppendingString:[NSString stringWithFormat:@"&locations[%d]=%@", i, [locSelArray objectAtIndex:i]]];
    }

    int index = 0;
    for (int i=0; i<[catSelArray count]; i++) {
        NSString* chk = [catSelArray objectAtIndex:i];
        if ([chk isEqualToString:@"1"]) {
            params = [params stringByAppendingString:[NSString stringWithFormat:@"&categories[%d]=%@", index, [categoryIdArray objectAtIndex:i]]];
            index++;
        }
    }
    
    index = 0;
    for (int i=0; i<[providerSelArray count]; i++) {
        NSString* chk = [providerSelArray objectAtIndex:i];
        if ([chk isEqualToString:@"1"]) {
            params = [params stringByAppendingString:[NSString stringWithFormat:@"&providers[%d]=%@", index, [providerNameArray objectAtIndex:i]]];
            index++;
        }
    }
    
    params = [API_GETDEAL_URL stringByAppendingString:params];
    
    [delegate didFinishWithFilteritems:[params stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forViewController:self];
}

- (void)didFinishedWithCoordinate:(CLLocationCoordinate2D)pinnedLoc forView:(UIViewController *)controller {
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
