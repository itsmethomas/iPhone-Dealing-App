//
//  FontViewController.m
//  DailyDeal
//
//  Created by Thomas Taussi on 8/6/14.
//  Copyright (c) 2014 ss. All rights reserved.
//

#import "FontViewController.h"

@interface FontViewController ()

@end

@implementation FontViewController

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
    
    fontArray = [[NSMutableArray alloc] init];
    
    for (NSString* family in [UIFont familyNames])
    {
        [fontArray addObject:family];
        for (NSString* name in [UIFont fontNamesForFamilyName: family])
        {
            [fontArray addObject:name];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [fontArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.font = [UIFont fontWithName:[fontArray objectAtIndex:indexPath.row] size:16.0f];
    cell.textLabel.text = [NSString stringWithFormat:@"Stay at Toftress ($189) : %@", [fontArray objectAtIndex:indexPath.row]];
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
