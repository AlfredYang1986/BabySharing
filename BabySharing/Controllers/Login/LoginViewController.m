//
//  LoginViewController.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 20/12/2014.
//  Copyright (c) 2014 YY. All rights reserved.
//

#import "LoginViewController.h"
#import "PhoneInputViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize lm = _lm;
@synthesize phoneNoFiled = _phoneNoFiled;
@synthesize areaFiled = _areaFiled;

@synthesize areaCodeSelected = _areaCodeSelected;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    _areaCodeSelected = @"(+86)";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:(UIBarButtonSystemItem)UIBarButtonSystemItemCancel target:self action:@selector(dismissLoginViewController:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    _areaFiled.text = _areaCodeSelected;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dismissLoginViewController: (id)sender {
    NSLog(@"dismiss");
    [self dismissViewControllerAnimated:YES completion:^(void){
        NSLog(@"dismiss complete");
        [_lm reloadDataFromLocalDB];
    }];
}

- (BOOL)isValidPhoneNumber:(NSString*)phoneNo inArea:(NSString*)areaCode {
    return phoneNo.length == 11;
}

#pragma mark - segue

- (IBAction)didSelectNextButton {
//    NSString* phoneNo = self.phoneNoFiled.text;
    NSString* phoneNo = @"13720200856";
   
    if ([self isValidPhoneNumber:phoneNo inArea:_areaCodeSelected]) {
        [self.lm sendLoginRequestToPhone: phoneNo];
        [self performSegueWithIdentifier:@"inputCodeSegue" sender:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"input wrong phone number" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)didSelectSinaButton {
    [_lm loginWithWeibo];
}

- (IBAction)didSelectFacebookButton {
}

- (IBAction)didSelectWeChatBtn {
}

- (IBAction)didSelectQQBtn {
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"inputCodeSegue"]) {
        //    NSString* phoneNo = self.phoneNoFiled.text;
        NSString* phoneNo = @"13720200856";
        ((PhoneInputViewController*)[segue destinationViewController]).lm = self.lm;
        ((PhoneInputViewController*)[segue destinationViewController]).inputing_phone_number = phoneNo;
    } else if ([segue.identifier isEqualToString:@"chooseAreaSegue"]) {
        
    }
}
- (IBAction)didSelectTextArea3 {
    [self performSegueWithIdentifier:@"chooseAreaSegue" sender:nil];
}

#pragma mark -- text filed delegate

//- (void)textViewDidChange:(UITextView *)textView {
//    [_areaFiled resignFirstResponder];
//}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}
@end
