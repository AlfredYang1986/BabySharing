//
//  PersonalCenterSignaturesController.m
//  BabySharing
//
//  Created by Alfred Yang on 30/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "PersonalCenterSignaturesController.h"
#import "AppDelegate.h"
#import "LoginModel.h"

@interface PersonalCenterSignaturesController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *signatureTextView;

@end

@implementation PersonalCenterSignaturesController {
    UIButton* clearBtn;
    UILabel * wordCountLabel;
    CGSize size;
}

@synthesize signatureTextView = _signatureTextView;
@synthesize delegate = _delegate;
@synthesize ori_signature = _ori_signature;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    _signatureTextView.layer.borderColor = [UIColor blackColor].CGColor;
//    _signatureTextView.layer.borderWidth = 1.f;
    _signatureTextView.layer.cornerRadius = 8.f;
    _signatureTextView.clipsToBounds = YES;
    _signatureTextView.backgroundColor = [UIColor whiteColor];

    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    NSString* filepath = [resourceBundle pathForResource:@"Cross" ofType:@"png"];
    
    clearBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [clearBtn setBackgroundImage:[UIImage imageNamed:filepath] forState:UIControlStateNormal];
    clearBtn.layer.cornerRadius = 15.f;
    clearBtn.clipsToBounds = YES;
    [clearBtn addTarget:self action:@selector(clearBtnSelected) forControlEvents:UIControlEventTouchDown];
    
    [_signatureTextView addSubview:clearBtn];
    
    _signatureTextView.scrollEnabled = NO;
    _signatureTextView.text = @"";
    
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
   
    UIFont* font = [UIFont systemFontOfSize:14.f];
    size = [@"88 字" sizeWithFont:font constrainedToSize:CGSizeMake(FLT_MAX, FLT_MAX)];
    wordCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
//    wordCountLabel.backgroundColor = [UIColor redColor];
    wordCountLabel.textColor = [UIColor colorWithRed:0.3126 green:0.7529 blue:0.6941 alpha:1.f];
    wordCountLabel.font = font;
    wordCountLabel.text = @"30 字";
    [_signatureTextView addSubview:wordCountLabel];
    
    _signatureTextView.delegate = self;
    _signatureTextView.textColor = [UIColor grayColor];
   
    UIButton* barBtn2 = [[UIButton alloc]initWithFrame:CGRectMake(13, 32, 30, 25)];
    [barBtn2 addTarget:self action:@selector(doneChangedSignature) forControlEvents:UIControlEventTouchDown];
    [barBtn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [barBtn2 setTitle:@"完成" forState:UIControlStateNormal];
    [barBtn2 sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:barBtn2];
    
    UILabel* label = [[UILabel alloc]init];
    label.text = @"隐私&偏好";
    label.textColor = [UIColor whiteColor];
    [label sizeToFit];
    self.navigationItem.titleView = label;
   
    UIButton* barBtn = [[UIButton alloc]initWithFrame:CGRectMake(13, 32, 30, 25)];
//    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
//    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
//    NSString* filepath = [resourceBundle pathForResource:@"Previous_blue" ofType:@"png"];
    NSString* filepath2 = [resourceBundle pathForResource:@"Previous_simple" ofType:@"png"];
    CALayer * layer = [CALayer layer];
    layer.contents = (id)[UIImage imageNamed:filepath2].CGImage;
    layer.frame = CGRectMake(0, 0, 13, 20);
    layer.position = CGPointMake(10, barBtn.frame.size.height / 2);
    [barBtn.layer addSublayer:layer];
//    [barBtn setBackgroundImage:[UIImage imageNamed:filepath] forState:UIControlStateNormal];
//    [barBtn setImage:[UIImage imageNamed:filepath] forState:UIControlStateNormal];
    [barBtn addTarget:self action:@selector(didPopControllerSelected) forControlEvents:UIControlEventTouchDown];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:barBtn];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    _signatureTextView.text = _ori_signature;
    [self textViewDidChange:_signatureTextView];
}

- (void)didPopControllerSelected {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    clearBtn.center = CGPointMake(_signatureTextView.bounds.size.width - 15, 15);
    wordCountLabel.center = CGPointMake(_signatureTextView.bounds.size.width - size.width, _signatureTextView.bounds.size.height - size.height / 2);
}

- (void)clearBtnSelected {
    _signatureTextView.text = @"";
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return textView.text.length - range.length + text.length <= 30;
}

- (void)textViewDidChange:(UITextView *)textView {
    NSInteger wc = textView.text.length;
    NSString* wc_str = [NSString stringWithFormat:@"%d 字", 30 - wc];
    wordCountLabel.text = wc_str;
}

- (void)doneChangedSignature {
    
    if (![_ori_signature isEqualToString:_signatureTextView.text]) {
        
        AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
        
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        
        [dic setObject:_signatureTextView.text forKey:@"signature"];

        [dic setValue:app.lm.current_auth_token forKey:@"auth_token"];
        [dic setValue:app.lm.current_user_id forKey:@"user_id"];
        
        [app.lm updateUserProfile:[dic copy]];
        [_delegate signatureDidChanged:_signatureTextView.text];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
