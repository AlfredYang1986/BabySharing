//
//  loginInputView.m
//  BabySharing
//
//  Created by Alfred Yang on 9/07/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "LoginInputView.h"
#import "OBShapedButton.h"

#define BASICMARGIN         8

#define SNS_BUTTON_WIDTH    40
#define SNS_BUTTON_HEIGHT   SNS_BUTTON_WIDTH

#define SNS_QQ              0
#define SNS_WEIBO           1
#define SNS_WECHAT          2

#define SNS_COUNT           3

#define SNS_TOP_MARGIN          130

@implementation LoginInputView {
    UIButton * area_code_btn;
    UITextField * phone_area;
    UITextField * confirm_area;
    UIButton * next_btn;
    UIButton * confirm_btn;
    
    UIImageView* split_img;
    UIButton * user_private_btn;
    NSArray* sns_btns;
    
    NSTimer* timer;
    NSInteger seconds;
}

@synthesize delegate = _delegate;

#define AREA_CODE_WIDTH             66
#define INPUT_TEXT_FIELD_HEIGHT     45.5
#define INPUT_MARGIN                32.5

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
#define TEXT_FIELD_LEFT_PADDING     10
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
    
    [self addSubview:phone_area];
}

#define LINE_MARGIN     5
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

#define CODE_BTN_WIDTH      80
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

#define LOGIN_BTN_TOP_MARGIN    60
#define LOGIN_BTN_HEIGHT        37

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

#define LOGIN_BTN_BOTTOM_MARGIN     40

- (void)setUpWithFrame:(CGRect)rect {
    CGFloat width = rect.size.width;
    
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];

    [self createAreaCodeBtnInRect:rect];
    [self createPhoneAreaIn:rect];
    [self createCodeLabelInRect:rect];
    [self createConfirmCodeAreaInRect:rect];
    [self createCodeBtnInRect:rect];
    [self createLoginBtnInRect:rect];
 
    UIFont* font = [UIFont systemFontOfSize:14.f];
    CGSize sz = [@"用户协议&隐私政策" sizeWithFont:font constrainedToSize:CGSizeMake(FLT_MAX, FLT_MAX)];
    
    CGFloat third_line_ver_margin = BASICMARGIN + INPUT_TEXT_FIELD_HEIGHT + LINE_MARGIN + INPUT_TEXT_FIELD_HEIGHT + LOGIN_BTN_TOP_MARGIN + LOGIN_BTN_HEIGHT + LOGIN_BTN_BOTTOM_MARGIN;
    CGFloat screen_width = [UIScreen mainScreen].bounds.size.width;
    split_img = [[UIImageView alloc]initWithFrame:CGRectMake(0, third_line_ver_margin, screen_width, sz.height)];
    NSString * split_file = [resourceBundle pathForResource:[NSString stringWithFormat:@"split-file"] ofType:@"png"];
    split_img.image = [UIImage imageNamed:split_file];
    
    [self addSubview:split_img];
    
    UIButton* qq_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SNS_BUTTON_WIDTH, SNS_BUTTON_HEIGHT)];
    NSString * qq_file = [resourceBundle pathForResource:[NSString stringWithFormat:@"qq"] ofType:@"png"];
    UIImage * qq_image = [UIImage imageNamed:qq_file];
    [qq_btn setBackgroundImage:qq_image forState:UIControlStateNormal];
    [qq_btn addTarget:self action:@selector(qqBtnSelected:) forControlEvents:UIControlEventTouchDown];
    qq_btn.backgroundColor = [UIColor clearColor];
    qq_btn.layer.cornerRadius = SNS_BUTTON_WIDTH / 2;
    qq_btn.clipsToBounds = YES;
    qq_btn.contentMode = UIViewContentModeCenter;
    [self addSubview:qq_btn];
    
    UIButton* weibo_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SNS_BUTTON_WIDTH, SNS_BUTTON_HEIGHT)];
    NSString * weibo_file = [resourceBundle pathForResource:[NSString stringWithFormat:@"weibo"] ofType:@"png"];
    UIImage * weibo_image = [UIImage imageNamed:weibo_file];
    [weibo_btn setBackgroundImage:weibo_image forState:UIControlStateNormal];
    [weibo_btn addTarget:self action:@selector(weiboBtnSelected:) forControlEvents:UIControlEventTouchDown];
    weibo_btn.backgroundColor = [UIColor clearColor];
    weibo_btn.layer.cornerRadius = SNS_BUTTON_WIDTH / 2;
    weibo_btn.clipsToBounds = YES;
    weibo_btn.contentMode = UIViewContentModeCenter;
    [self addSubview:weibo_btn];
    
    UIButton* wechat_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SNS_BUTTON_WIDTH, SNS_BUTTON_HEIGHT)];
    NSString * wechat_file = [resourceBundle pathForResource:[NSString stringWithFormat:@"wechat"] ofType:@"png"];
    UIImage * wechat_image = [UIImage imageNamed:wechat_file];
    [wechat_btn setBackgroundImage:wechat_image forState:UIControlStateNormal];
    [wechat_btn addTarget:self action:@selector(wechatBtnSelected:) forControlEvents:UIControlEventTouchDown];
    wechat_btn.backgroundColor = [UIColor clearColor];
    wechat_btn.clipsToBounds = YES;
    wechat_btn.layer.cornerRadius = SNS_BUTTON_WIDTH / 2;
    wechat_btn.contentMode = UIViewContentModeCenter;
    [self addSubview:wechat_btn];

    CGFloat forth_line_ver_line = third_line_ver_margin + sz.height + 2 * BASICMARGIN + SNS_BUTTON_HEIGHT / 2;
    weibo_btn.center = CGPointMake(width / 2, forth_line_ver_line);
    qq_btn.center = CGPointMake(width / 2 - 2 * SNS_BUTTON_WIDTH, forth_line_ver_line);
    wechat_btn.center = CGPointMake(width / 2 + 2 * SNS_BUTTON_WIDTH, forth_line_ver_line);
   
    CGFloat fifth_line_ver_line = forth_line_ver_line + SNS_BUTTON_HEIGHT / 2 + 2 * BASICMARGIN;
    user_private_btn = [[UIButton alloc]initWithFrame:CGRectMake((width - sz.width) / 2, fifth_line_ver_line, sz.width, sz.height)];
    user_private_btn.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [user_private_btn setTitleColor:[UIColor colorWithWhite:1.f alpha:0.6] forState:UIControlStateNormal];
    [user_private_btn setTitle:@"用户协议&隐私政策" forState:UIControlStateNormal];
    [user_private_btn addTarget:self action:@selector(userPrivacyBtnSelected) forControlEvents:UIControlEventTouchDown];
    [self addSubview:user_private_btn];
    
    CGFloat height = fifth_line_ver_line + sz.height + BASICMARGIN;
    self.bounds = CGRectMake(0, 0, width, height);
}

- (void)qqBtnSelected:(UIButton*)sender {
    [_delegate didSelectQQBtn];
}

- (void)weiboBtnSelected:(UIButton*)sender {
    [_delegate didSelectWeiboBtn];
}

- (void)wechatBtnSelected:(UIButton*)sender {
    [_delegate didSelectWechatBtn];
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

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [_delegate didStartEditing];
}

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

- (void)userPrivacyBtnSelected {
    [_delegate didSelectUserPrivacyBtn];
}

- (void)sendConfirmCodeRequestSuccess {
    seconds = 60;
    confirm_btn.enabled = NO;
    [timer setFireDate:[NSDate distantPast]];
}

- (void)handleTimer:(NSTimer*)sender {
    if (-- seconds > 0) {
        [confirm_btn setTitle:[NSString stringWithFormat:@"(%ld)秒重试", (long)seconds] forState:UIControlStateDisabled];
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
@end
