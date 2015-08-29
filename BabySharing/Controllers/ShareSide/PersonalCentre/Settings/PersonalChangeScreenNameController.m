//
//  PersonalChangeScreenNameController.m
//  BabySharing
//
//  Created by Alfred Yang on 29/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "PersonalChangeScreenNameController.h"
#import "AppDelegate.h"
#import "LoginModel.h"

@interface PersonalChangeScreenNameController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *screen_name_tf;
@end

@implementation PersonalChangeScreenNameController

@synthesize screen_name_tf = _screen_name_tf;
@synthesize delegate = _delegate;
@synthesize ori_screen_name = _ori_screen_name;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _screen_name_tf.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(doneChangeScreenName)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doneChangeScreenName {
    
    if (![_ori_screen_name isEqualToString:_screen_name_tf.text]) {
        
        
        AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
        
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        
        [dic setObject:_screen_name_tf.text forKey:@"screen_name"];

        [dic setValue:app.lm.current_auth_token forKey:@"auth_token"];
        [dic setValue:app.lm.current_user_id forKey:@"user_id"];
        
        [app.lm updateUserProfile:[dic copy]];
        [_delegate didChangeScreenName:_screen_name_tf.text];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
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
