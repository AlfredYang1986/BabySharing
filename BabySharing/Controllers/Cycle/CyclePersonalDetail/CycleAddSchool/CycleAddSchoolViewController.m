//
//  CycleAddSchoolViewController.m
//  BabySharing
//
//  Created by Alfred Yang on 13/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "CycleAddSchoolViewController.h"

@interface CycleAddSchoolViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *schoolNameTF;

@end

@implementation CycleAddSchoolViewController

@synthesize schoolNameTF = _schoolNameTF;
@synthesize delegate = _delegate;
@synthesize ori_school_name = _ori_school_name;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _schoolNameTF.text = _ori_school_name;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(doneAddSchoolName)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doneAddSchoolName {
    [_delegate addSchool:_schoolNameTF.text];
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_schoolNameTF resignFirstResponder];
    return YES;
}
@end
