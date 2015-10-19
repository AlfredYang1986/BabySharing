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
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(doneHomeDownEditing)];
    
    _hometownTF.text = _ori_hometown;
    
    UIButton* barBtn = [[UIButton alloc]initWithFrame:CGRectMake(13, 32, 30, 25)];
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
//    NSString* filepath = [resourceBundle pathForResource:@"Previous_blue" ofType:@"png"];
    NSString* filepath = [resourceBundle pathForResource:@"Previous_simple" ofType:@"png"];
    CALayer * layer = [CALayer layer];
    layer.contents = (id)[UIImage imageNamed:filepath].CGImage;
    layer.frame = CGRectMake(0, 0, 13, 20);
    layer.position = CGPointMake(10, barBtn.frame.size.height / 2);
    [barBtn.layer addSublayer:layer];
//    [barBtn setBackgroundImage:[UIImage imageNamed:filepath] forState:UIControlStateNormal];
//    [barBtn setImage:[UIImage imageNamed:filepath] forState:UIControlStateNormal];
    [barBtn addTarget:self action:@selector(didPopControllerSelected) forControlEvents:UIControlEventTouchDown];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:barBtn];
    
    UILabel* label = [[UILabel alloc]init];
    label.text = @"家乡";
    label.textColor = [UIColor whiteColor];
    [label sizeToFit];
    
    self.navigationItem.titleView = label;
    
    UIButton* barBtn1 = [[UIButton alloc]initWithFrame:CGRectMake(13, 32, 30, 25)];
    [barBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [barBtn1 setTitle:@"完成" forState:UIControlStateNormal];
    [barBtn1 sizeToFit];
    [barBtn1 addTarget:self action:@selector(doneHomeDownEditing) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:barBtn1];
}

- (void)didPopControllerSelected {
    [self.navigationController popViewControllerAnimated:YES];
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
