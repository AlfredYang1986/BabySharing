//
//  NicknameInputViewController.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 26/12/2014.
//  Copyright (c) 2014 YY. All rights reserved.
//

#import "NicknameInputViewController.h"
#import "LoginToken+ContextOpt.h"

@interface NicknameInputViewController ()

@end

@implementation NicknameInputViewController

@synthesize img = _img;
@synthesize nicknameTextbox = _nicknameTextbox;
@synthesize lm = _lm;

@synthesize login_attr = _login_attr;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)didConfirm {

    NSString* auth_token = [_login_attr objectForKey:@"auth_token"];
    NSString* user_id = [_login_attr objectForKey:@"user_id"];
    if ([_lm sendScreenName:@"alfred" forToken:auth_token andUserID:user_id]) {
//  if ([_lm sendScreenName:self.nicknameTextbox.text forToken:auth_token andUserID:user_id]) {
        NSString* phoneNo = (NSString*)[_login_attr objectForKey:@"phoneNo"];
//        [LoginToken removeTokenInContext:_lm.doc.managedObjectContext WithPhoneNum:phoneNo];
        [LoginToken unbindTokenInContext:_lm.doc.managedObjectContext WithPhoneNum:phoneNo];
        LoginToken* token = [LoginToken createTokenInContext:_lm.doc.managedObjectContext withUserID:user_id andAttrs:_login_attr];
        [_lm setCurrentUser:token];
        [_lm.doc.managedObjectContext save:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"login success" object:nil];
//      [self.navigationController dismissViewControllerAnimated:YES completion:^(void){
//          NSLog(@"Login success");
//          [_lm reloadDataFromLocalDB];
//          _lm.current_user_token = token.auth_token;
//      }];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"set nick name error" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
    }
}
@end
