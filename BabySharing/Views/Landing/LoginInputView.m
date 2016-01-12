//
//  loginInputView.m
//  BabySharing
//
//  Created by Alfred Yang on 9/07/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "LoginInputView.h"
#import "OBShapedButton.h"

#define BASICMARGIN                         8

#define SNS_TOP_MARGIN                      130

#define AREA_CODE_WIDTH                     66
#define INPUT_TEXT_FIELD_HEIGHT             45.5
#define INPUT_MARGIN                        32.5

#define TEXT_FIELD_LEFT_PADDING             10
#define LINE_MARGIN                         5
#define CODE_BTN_WIDTH                      80

#define LOGIN_BTN_TOP_MARGIN                60
#define LOGIN_BTN_HEIGHT                    37
#define LOGIN_BTN_BOTTOM_MARGIN             40

@interface LoginInputView () <UITextFieldDelegate>

@end

@implementation LoginInputView {
    UIButton * area_code_btn;
    UITextField * phone_area;
    UITextField * confirm_area;
    UIButton * next_btn;
    UIButton * confirm_btn;
    
    NSTimer* timer;
    NSInteger seconds;
}

@synthesize delegate = _delegate;

- (void)createAreaCodeBtnInRect:(CGRect)rect {

    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];

    NSString * bundlePath_dongda = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle_dongda = [NSBundle bundleWithPath:bundlePath_dongda];

    UIFont* font = [UIFont systemFontOfSize:14.f];
    area_code_btn = [[UIButton alloc]initWithFrame:CGRectMake(INPUT_MARGIN, BASICMARGIN, AREA_CODE_WIDTH, INPUT_TEXT_FIELD_HEIGHT)];
    [area_code_btn setBackgroundImage:[UIImage imageNamed:[resourceBundle_dongda pathForResource:@"login_dark_input_bg" ofType:@"png"]] forState:UIControlStateNormal];
    
    UILabel* area_code_label = [[UILabel alloc]init];
    area_code_label.text = @"+86";
    area_code_label.font = font;
    area_code_label.textColor = [UIColor whiteColor];
    [area_code_label sizeToFit];
    area_code_label.frame = CGRectMake(13.5, INPUT_TEXT_FIELD_HEIGHT / 2 - area_code_label.bounds.size.height / 2, area_code_label.bounds.size.width, area_code_label.bounds.size.height);
    area_code_label.tag = -1;
    [area_code_btn addSubview:area_code_label];
    
    CALayer* t_layer = [CALayer layer];
    NSString * t_file = [resourceBundle pathForResource:[NSString stringWithFormat:@"triangle"] ofType:@"png"];
    t_layer.contents = (id)[UIImage imageNamed:t_file].CGImage;
    t_layer.frame = CGRectMake(0, 0, 9, 8);
    t_layer.position = CGPointMake(area_code_btn.frame.size.width - 12, area_code_btn.frame.size.height / 2);
    [area_code_btn.layer addSublayer:t_layer];
    [area_code_btn addTarget:self action:@selector(areaCodeBtnSelected:) forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:area_code_btn];
}

- (void)createPhoneAreaIn:(CGRect)rect {
    CGFloat width = rect.size.width;
    CGFloat first_line_start_margin = INPUT_MARGIN;
    first_line_start_margin = INPUT_MARGIN + AREA_CODE_WIDTH;
    
    UIFont* font = [UIFont systemFontOfSize:14.f];
    NSString * bundlePath_dongda = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle_dongda = [NSBundle bundleWithPath:bundlePath_dongda];
    
    phone_area = [[UITextField alloc]initWithFrame:CGRectMake(first_line_start_margin, BASICMARGIN, width - AREA_CODE_WIDTH - 2 * INPUT_MARGIN, INPUT_TEXT_FIELD_HEIGHT)];
    [phone_area setBackground:[UIImage imageNamed:[resourceBundle_dongda pathForResource:@"login_light_input_bg" ofType:@"png"]]];
    phone_area.font = font;
    CGRect frame = phone_area.frame;
    
    frame.size.width = TEXT_FIELD_LEFT_PADDING;
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
    phone_area.leftViewMode = UITextFieldViewModeAlways;
    phone_area.leftView = leftview;
    
    phone_area.placeholder = @"输入您的手机号";
    [phone_area setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    phone_area.textColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(phoneTextFieldChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    phone_area.delegate = self;
    phone_area.keyboardType = UIKeyboardTypeNumberPad;
    phone_area.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [self addSubview:phone_area];
}

- (void)createCodeLabelInRect:(CGRect)rect {
    NSString * bundlePath_dongda = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle_dongda = [NSBundle bundleWithPath:bundlePath_dongda];
    
    UIFont* font = [UIFont systemFontOfSize:14.f];
    
    UIButton* tmp = [[UIButton alloc]initWithFrame:CGRectMake(INPUT_MARGIN, BASICMARGIN + INPUT_TEXT_FIELD_HEIGHT + LINE_MARGIN, AREA_CODE_WIDTH, INPUT_TEXT_FIELD_HEIGHT)];
    [tmp setBackgroundImage:[UIImage imageNamed:[resourceBundle_dongda pathForResource:@"login_dark_input_bg" ofType:@"png"]] forState:UIControlStateNormal];
    
    UILabel* label = [[UILabel alloc]init];
    label.text = @"验证码";
    label.font = font;
    label.textColor = [UIColor whiteColor];
    [label sizeToFit];
    label.center = CGPointMake(AREA_CODE_WIDTH / 2, INPUT_TEXT_FIELD_HEIGHT / 2);
    label.tag = -1;
    [tmp addSubview:label];
    
    [self addSubview:tmp];
}

- (void)createConfirmCodeAreaInRect:(CGRect)rect {
    CGFloat width = rect.size.width;
    NSString * bundlePath_dongda = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle_dongda = [NSBundle bundleWithPath:bundlePath_dongda];

    UIFont* font = [UIFont systemFontOfSize:14.f];
    confirm_area = [[UITextField alloc]initWithFrame:CGRectMake(INPUT_MARGIN + AREA_CODE_WIDTH, BASICMARGIN + INPUT_TEXT_FIELD_HEIGHT + LINE_MARGIN, width - 2 * INPUT_MARGIN - AREA_CODE_WIDTH - CODE_BTN_WIDTH, INPUT_TEXT_FIELD_HEIGHT)];
    confirm_area.font = font;
    [confirm_area setBackground:[UIImage imageNamed:[resourceBundle_dongda pathForResource:@"login_light_input_bg" ofType:@"png"]]];
    
    confirm_area.placeholder = @"请输入验证码";
    confirm_area.textAlignment = NSTextAlignmentCenter;
    [confirm_area setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    confirm_area.textColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(confirmCodeTextFieldChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    confirm_area.delegate = self;
    confirm_area.keyboardType = UIKeyboardTypeNumberPad;
    
    [self addSubview:confirm_area];
}

- (void)createCodeBtnInRect:(CGRect)rect {
    CGFloat width = rect.size.width;
    NSString * bundlePath_dongda = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle_dongda = [NSBundle bundleWithPath:bundlePath_dongda];

    confirm_btn = [[OBShapedButton alloc]initWithFrame:CGRectMake(width - INPUT_MARGIN - CODE_BTN_WIDTH, BASICMARGIN + INPUT_TEXT_FIELD_HEIGHT + LINE_MARGIN, CODE_BTN_WIDTH, INPUT_TEXT_FIELD_HEIGHT)];
    confirm_btn.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [confirm_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirm_btn.clipsToBounds = YES;
    [confirm_btn setBackgroundImage:[UIImage imageNamed:[resourceBundle_dongda pathForResource:@"login_dark_input_bg" ofType:@"png"]] forState:UIControlStateNormal];
    
    [confirm_btn setTitle:@"发送验证码" forState:UIControlStateNormal];
    [confirm_btn addTarget:self action:@selector(confirmBtnSelected:) forControlEvents:UIControlEventTouchDown];
    
    [self addSubview:confirm_btn];
}


- (void)createLoginBtnInRect:(CGRect)rect {
    CGFloat width = rect.size.width;
    NSString * bundlePath_dongda = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle_dongda = [NSBundle bundleWithPath:bundlePath_dongda];
    
    next_btn = [[OBShapedButton alloc]initWithFrame:CGRectMake(INPUT_MARGIN, BASICMARGIN + INPUT_TEXT_FIELD_HEIGHT + LINE_MARGIN + INPUT_TEXT_FIELD_HEIGHT + LOGIN_BTN_TOP_MARGIN, width - 2 * INPUT_MARGIN, LOGIN_BTN_HEIGHT)];
    [next_btn addTarget:self action:@selector(nextBtnSelected:) forControlEvents:UIControlEventTouchDown];
    next_btn.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [next_btn setTitle:@"登陆" forState:UIControlStateNormal];
    [next_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    next_btn.clipsToBounds = YES;
    [next_btn setBackgroundImage:[UIImage imageNamed:[resourceBundle_dongda pathForResource:@"login_btn_bg" ofType:@"png"]] forState:UIControlStateNormal];
    
    [self addSubview:next_btn];
}


- (void)setUpWithFrame:(CGRect)rect {
    CGFloat width = rect.size.width;

    [self createAreaCodeBtnInRect:rect];
    [self createPhoneAreaIn:rect];
    [self createCodeLabelInRect:rect];
    [self createConfirmCodeAreaInRect:rect];
    [self createCodeBtnInRect:rect];
    [self createLoginBtnInRect:rect];
    
    CGFloat height = BASICMARGIN + INPUT_TEXT_FIELD_HEIGHT + LINE_MARGIN + INPUT_TEXT_FIELD_HEIGHT + LOGIN_BTN_TOP_MARGIN + LOGIN_BTN_HEIGHT + BASICMARGIN;
    self.bounds = CGRectMake(0, 0, width, height);
}



- (void)phoneTextFieldChanged:(UITextField*)tf {
    if ([phone_area.text isEqualToString:@""]) {
        
    } else {
    
    }
}

- (void)confirmCodeTextFieldChanged:(UITextField*)tf {
    if ([confirm_area.text isEqualToString:@""]) {
    
    } else {
    
    }
}

- (void)endEditing {
    [phone_area resignFirstResponder];
    [confirm_area resignFirstResponder];
}

//- (void)textFieldDidBeginEditing:(UITextField *)textField {
//    [_delegate didStartEditing];
//}

- (void)areaCodeBtnSelected:(UIButton*)sender {
    [_delegate didSelectAreaCodeBtn];
}

- (void)confirmBtnSelected:(UIButton*)sender {
    [_delegate didSelectConfirmBtn];
}

- (void)nextBtnSelected:(UIButton*)sender {
    [_delegate didSelectNextBtn];
}

- (NSString*)getInputPhoneNumber {
    return phone_area.text;
}

- (NSString*)getInputConfirmCode {
    return confirm_area.text;
}


- (void)sendConfirmCodeRequestSuccess {
    seconds = 60;
    confirm_btn.enabled = NO;
    [timer setFireDate:[NSDate distantPast]];
}

- (void)handleTimer:(NSTimer*)sender {
    if (-- seconds > 0) {
//        [confirm_btn setTitle:[NSString stringWithFormat:@"(%ld)秒重试", (long)seconds] forState:UIControlStateDisabled];
        [confirm_btn setTitle:[NSString stringWithFormat:@"%lds", (long)seconds] forState:UIControlStateDisabled];
    } else {
        seconds = 60;
        [timer setFireDate:[NSDate distantFuture]];
        confirm_btn.enabled = YES;
    }
    
}

- (id)initWithFrame:(CGRect)rect {
    self = [super initWithFrame:rect];
    if (self) {
        [self setUpWithFrame:rect];
        timer = [NSTimer scheduledTimerWithTimeInterval: 1.0
                                                 target: self
                                               selector: @selector(handleTimer:)
                                               userInfo: nil
                                                repeats: YES];
        [timer setFireDate:[NSDate distantFuture]];
    }
    
    return self;
}

- (BOOL)isEditing {
    return confirm_area.isEditing || phone_area.isEditing;
}

- (void)setAreaCode:(NSString*)code {
    UILabel* tmp = (UILabel*)[area_code_btn viewWithTag:-1];
    tmp.text = [@"+" stringByAppendingString:code];
    [tmp sizeToFit];
//    [area_code_btn setTitle:[@"+" stringByAppendingString:code] forState:UIControlStateNormal];
}

#pragma mark -- text field delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [_delegate didStartEditing];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [_delegate didEndEditing];
}
@end
