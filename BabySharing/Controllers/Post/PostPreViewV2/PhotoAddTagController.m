//
//  PhotoAddTagController.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 13/06/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "PhotoAddTagController.h"

@interface PhotoAddTagController ()
@property (weak, nonatomic) IBOutlet UITextField *inputView;

@end

@implementation PhotoAddTagController {
    UIView * tag_attr;
    UITableView* queryView;
}

@synthesize tagImgView = _tagImgView;
@synthesize inputView = _inputView;
@synthesize type = _type;
@synthesize delegate = _delegate;
@synthesize tagImg = _tagImg;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
    _inputView.delegate = self;
    [_inputView becomeFirstResponder];
    
    _tagImgView.image = _tagImg;
   
    _inputView.backgroundColor = [UIColor colorWithRed:0.8196 green:0.8275 blue:0.8314 alpha:1.f];
    _inputView.layer.cornerRadius = 12.f;
    _inputView.clipsToBounds = YES;
    _inputView.placeholder = @"搜索";
    
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    
    NSString* filepath = [resourceBundle pathForResource:@"Previous" ofType:@"png"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:filepath] style:UIBarButtonItemStylePlain target:self action:@selector(didSelectBackBtn:)];
    
    tag_attr = [[UIView alloc]init];
    [self.view addSubview:tag_attr];

//    tag_attr.backgroundColor = [UIColor redColor];
}

- (void)didSelectBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews {

    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat offset = _inputView.frame.origin.y + _inputView.frame.size.height + 8;
    CGFloat height = [UIScreen mainScreen].bounds.size.height - offset;
    tag_attr.frame = CGRectMake(0, offset, width, height);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark -- text field delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
   
    [self.navigationController popViewControllerAnimated:YES];
    [_delegate didSelectTag:textField.text andType:_type];
    return NO;
}

#pragma mark -- cancel btn
- (IBAction)didSelectCancelBtn {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
