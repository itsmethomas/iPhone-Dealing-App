//
//  ViewController.m
//  DailyDeal
//
//  Created by Thomas Taussi on 7/30/14.
//  Copyright (c) 2014 ss. All rights reserved.
//

#import "ViewController.h"

#import "SharedSoundPlayer.h"
#import "ActivityIndicator.h"
#import "JSON.h"
#import "Constants.h"
#import "BlUserInfo.h"
#import "ConfigManager.h"
#import "MainViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"My Deals";
    isRememberme = NO;

    BlUserInfo *userinfo = [ConfigManager getRememberedUserinfo];
    if (userinfo != nil) {
        MainViewController *mainView = [self.storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
        mainView.userInfo = userinfo;
        [self.navigationController pushViewController:mainView animated:userinfo];
    }
    
    fbLoginView.delegate = self;
    fbLoginView.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    isLoading = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    facebookImageUrl = nil;
    facebookName = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    fbLoginView.delegate = self;
}

#pragma mark - FBLogin Delegate
- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    
}
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user {
    if (isLoading)
        return;
    
    __block NSDictionary *temp = (NSDictionary *)user;
    
    NSLog(@"fetched userid %@ with info %@", [user objectID], user);
    
    NSString *email = [temp objectForKey:@"email"];
    NSString *fbu = [user objectID];
    
    facebookImageUrl = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [user objectID]];
    facebookName = [user name];
    
    // Start Connection...
    [[ActivityIndicator currentIndicator] show];
    
    responseData = [[NSMutableData alloc] init];
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:API_FBLOGIN_URL]];
    [req setHTTPMethod:@"POST"];
    [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    
    NSString *body = [NSString stringWithFormat:@"email=%@&fbu=%@", email, fbu];
    [req setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    [NSURLConnection connectionWithRequest:req delegate:self];
    isLoading = YES;
}


#pragma mark - Button Events

- (IBAction) onLogin:(id)sender {
    if (isLoading)
        return;
    
    NSString *email = emailTextField.text;
    NSString *password = passwordTextField.text;
    
    if ([email isEqualToString:@""]) {
        [[[UIAlertView alloc] initWithTitle:@"Warnning" message:@"Please enter your email." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    } else if ([password isEqualToString:@""]) {
        [[[UIAlertView alloc] initWithTitle:@"Warnning" message:@"Please enter your password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    
    // Start Connection...
    [[ActivityIndicator currentIndicator] show];
    
    responseData = [[NSMutableData alloc] init];
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:API_LOGIN_URL]];
    [req setHTTPMethod:@"POST"];
    [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    
    NSString *body = [NSString stringWithFormat:@"username=%@&password=%@", email, password];
    [req setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    [NSURLConnection  connectionWithRequest:req delegate:self];
    isLoading = YES;
}

- (IBAction) onLoginWithGuest:(id)sender {
    BlUserInfo *userinfo = [[BlUserInfo alloc] init];
    userinfo.SESSION_ID = @"";
    userinfo.SESSION_NAME = @"";
    userinfo.TOKEN = @"";
    userinfo.LOCATION_ID = @"";
    
    MainViewController *mainView = [self.storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
    mainView.userInfo = userinfo;
    [self.navigationController pushViewController:mainView animated:userinfo];
}

- (IBAction) onFBLogin:(id)sender {
    for(id object in fbLoginView.subviews){
        if([[object class] isSubclassOfClass:[UIButton class]]){
            UIButton* button = (UIButton*)object;
            [button sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
    }
}
- (IBAction) onRemeberme:(id)sender {
    UIButton *chkbox = (UIButton*) sender;
    isRememberme = !isRememberme;
    [chkbox setSelected:isRememberme];
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
    
    NSLog(@"%@", error);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [[ActivityIndicator currentIndicator] hide];
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    
    NSLog(@"%@", responseString);
    NSObject *responseObj = [[SBJsonParser new] objectWithString:responseString];
    if ([responseObj isKindOfClass:[NSArray class]]) {
        NSString *errorMsg = [((NSArray*)responseObj) objectAtIndex:0];
        
        [[[UIAlertView alloc] initWithTitle:@"Warnning" message:errorMsg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    } else {
        NSDictionary *dictionary = (NSDictionary*)responseObj;
        
        BlUserInfo *userinfo = [[BlUserInfo alloc] init];
        userinfo.SESSION_ID = [dictionary objectForKey:@"sessid"];
        userinfo.SESSION_NAME = [dictionary objectForKey:@"session_name"];
        userinfo.TOKEN = [dictionary objectForKey:@"token"];
        if (facebookImageUrl != nil) {
            userinfo.FACEBOOK_IMG_URL = facebookImageUrl;
            userinfo.NAME = facebookName;
        }
        
        NSDictionary *sub = [dictionary objectForKey:@"user"];
        userinfo.UID = [sub objectForKey:@"uid"];
        
        // getting location id...
        if ([[sub objectForKey:@"field_post_code"] isKindOfClass:[NSArray class]]) {
            userinfo.LOCATION_ID = @"";
        } else {
            sub = [sub objectForKey:@"field_post_code"];
            NSArray *subarr = [sub objectForKey:@"und"];
            if ([subarr count] == 0) {
                userinfo.LOCATION_ID = @"";
            } else {
                
            }
            if ([subarr count] == 0)
                userinfo.LOCATION_ID = @"";
            else {
                sub = [subarr objectAtIndex:0];
                userinfo.LOCATION_ID = [sub objectForKey:@"tid"];
            }
        }
        
        if (isRememberme) {
            [ConfigManager rememberUserInfo:userinfo];
        }
        
        MainViewController *mainView = [self.storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
        mainView.userInfo = userinfo;
        [self.navigationController pushViewController:mainView animated:userinfo];
    }
    isLoading = NO;
}

#pragma mark Text Field Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.tag == 0) {
        [emailTextField resignFirstResponder];
        [passwordTextField becomeFirstResponder];
        return NO;
    }
    
    return [textField resignFirstResponder];
}

@end
