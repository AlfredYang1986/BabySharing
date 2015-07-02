//
//  AlreadLogedViewController.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 26/12/2014.
//  Copyright (c) 2014 YY. All rights reserved.
//

#import "AlreadLogedViewController.h"
#import "NicknameInputViewController.h"
#import "loginToken+ContextOpt.h"

@interface AlreadLogedViewController ()

@end

@implementation AlreadLogedViewController

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

- (IBAction)didSelectMeButton {

    NSString* user_id = (NSString*)[_login_attr objectForKey:@"user_id"];
    NSString* phoneNo = (NSString*)[_login_attr objectForKey:@"phoneNo"];
    [LoginToken removeTokenInContext:_lm.doc.managedObjectContext WithPhoneNum:phoneNo];
    LoginToken* token = [LoginToken createTokenInContext:_lm.doc.managedObjectContext withUserID:user_id andAttrs:_login_attr];
    
    [_lm setCurrentUser:token];
    [_lm.doc.managedObjectContext save:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"login success" object:nil];
//    [self.navigationController dismissViewControllerAnimated:YES completion:^(void){
//        NSLog(@"Login success");
//        [_lm reloadDataFromLocalDB];
//    }];
}

- (IBAction)didSelectCreateNewAccount {
    NSDictionary* tmp = [[NSDictionary alloc]init];
    if ([_lm sendCreateNewUserWithPhone:[_login_attr objectForKey:@"phoneNo"] toResult:&tmp]) {
        _login_attr = tmp;
        [self performSegueWithIdentifier:@"bindNewAccountSegue" sender:nil];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"bindNewAccountSegue"]){
        ((NicknameInputViewController*)segue.destinationViewController).login_attr = _login_attr;
        ((NicknameInputViewController*)segue.destinationViewController).lm = _lm;
    }
}

@end
