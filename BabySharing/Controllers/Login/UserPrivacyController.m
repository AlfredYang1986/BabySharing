//
//  UserPrivacyController.m
//  BabySharing
//
//  Created by Alfred Yang on 19/07/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "UserPrivacyController.h"
#import "ModelDefines.h"
#import "RemoteInstance.h"

@interface UserPrivacyController () <UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;
@property (weak, nonatomic) IBOutlet UITextView *privacyView;

@end

@implementation UserPrivacyController

@synthesize bottomLabel = _bottomLabel;
@synthesize privacyView = _privacyView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _bottomLabel.layer.borderColor = [UIColor blackColor].CGColor;
    _bottomLabel.layer.borderWidth = 1.f;
    _bottomLabel.layer.cornerRadius = 8.f;
    _bottomLabel.clipsToBounds = YES;
  
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"发送邮件" style:UIBarButtonItemStylePlain target:self action:@selector(sendEmailBtnSelected)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    [_privacyView setContentOffset:CGPointZero];
}

- (void)sendEmailBtnSelected {
    UIAlertView* view = [[UIAlertView alloc]initWithTitle:@"输入你的邮件" message:@"" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"do it", nil];
    view.alertViewStyle = UIAlertViewStylePlainTextInput;
    [view show];
}

-(BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailPredicate evaluateWithObject:email];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    UITextField* tf = [alertView textFieldAtIndex:0];
    NSString* email = tf.text;
    
    if ([self isValidateEmail:email]) {
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        [dic setObject:email forKey:@"email"];
        
        NSError * error = nil;
        NSData* jsonData =[NSJSONSerialization dataWithJSONObject:[dic copy] options:NSJSONWritingPrettyPrinted error:&error];

        NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:EMAIL_SENDPRIVACY]];
     
        if ([[result objectForKey:@"status"] isEqualToString:@"ok"]) {
            NSLog(@"send email success");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"success" message:@"send email success" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
            [alert show];

        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"send email failed" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
            [alert show];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"not validate email address" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
