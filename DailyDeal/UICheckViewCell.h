//
//  UICheckViewCell.h
//  DailyDeal
//
//  Created by Thomas Taussi on 7/31/14.
//  Copyright (c) 2014 ss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICheckViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UIImageView *checkImageView;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *loader;

@end
