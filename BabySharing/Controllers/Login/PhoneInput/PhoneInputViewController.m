//
//  PhoneInputViewController.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 26/12/2014.
//  Copyright (c) 2014 YY. All rights reserved.
//

#import "PhoneInputViewController.h"
#import "RegTmpToken+ContextOpt.h"
#import "NicknameInputViewController.h"
#import "AlreadLogedViewController.h"

@interface PhoneInputViewController () {
    NSDictionary* result;
}

@end

@implementation PhoneInputViewController

@synthesize lm = _lm;
@synthesize phoneCodeFiled = _phoneCodeFiled;
@synthesize inputing_phone_number = _inputing_phone_number;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (BOOL)isValidPhoneCode:(NSString*)phoneCode {
    return phoneCode.length == 5;
}

- (IBAction)didSelectNextStep {
    NSString* code = self.phoneCodeFiled.text;

    if (![self isValidPhoneCode:code]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"input wrong phone number" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
        return;
    }
  
    RegTmpToken* token = [RegTmpToken enumRegTokenINContext:self.lm.doc.managedObjectContext WithPhoneNo:_inputing_phone_number];

    if (token == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"input wrong phone number" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
    } else {
        NSDictionary* tmp =[[NSDictionary alloc]init];
        LoginModelConfirmResult reVal = [self.lm sendConfirrmCode:code ToPhone:_inputing_phone_number withToken:token.reg_token toResult:&tmp];
        result = tmp;
        if (reVal == LoginModelResultSuccess) {
            [self performSegueWithIdentifier:@"loginSuccessSegue" sender:nil];
        } else if (reVal ==LoginModelResultOthersLogin) {
            [self performSegueWithIdentifier:@"alreadyLogSegue" sender:nil];
        }
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"loginSuccessSegue"]) {
        ((NicknameInputViewController*)segue.destinationViewController).login_attr = result;
        ((NicknameInputViewController*)segue.destinationViewController).lm = _lm;
    } else {
        ((AlreadLogedViewController*)segue.destinationViewController).login_attr = result;
        ((AlreadLogedViewController*)segue.destinationViewController).lm = _lm;
    }
}

@end
