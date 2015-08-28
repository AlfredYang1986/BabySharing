//
//  CycleAddHometownController.m
//  BabySharing
//
//  Created by Alfred Yang on 28/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "CycleAddHometownController.h"

@interface CycleAddHometownController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *hometownTF;

@end

@implementation CycleAddHometownController

@synthesize hometownTF = _hometownTF;
@synthesize delegate = _delegate;
@synthesize ori_hometown = _ori_hometown;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(doneHomeDownEditing)];
    
    _hometownTF.text = _ori_hometown;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doneHomeDownEditing {
    [_delegate addHometown:_hometownTF.text];
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

#pragma mark -- text field delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
