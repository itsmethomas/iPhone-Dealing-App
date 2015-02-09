//
//  ViewController.h
//  DailyDeal
//
//  Created by Thomas Taussi on 7/30/14.
//  Copyright (c) 2014 ss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface ViewController : UIViewController<FBLoginViewDelegate, UITextFieldDelegate, NSURLConnectionDataDelegate> {
    IBOutlet UITextField *emailTextField;
    IBOutlet UITextField *passwordTextField;
    
    NSMutableData *responseData;
    NSString *facebookImageUrl;
    NSString *facebookName;
    
    IBOutlet FBLoginView *fbLoginView;
    
    BOOL isRememberme;
    BOOL isLoading;
}

- (IBAction) onLogin:(id)sender;
- (IBAction) onLoginWithGuest:(id)sender;
- (IBAction) onFBLogin:(id)sender;
- (IBAction) onRemeberme:(id)sender;
@end
