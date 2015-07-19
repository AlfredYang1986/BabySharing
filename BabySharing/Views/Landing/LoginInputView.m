//
//  loginInputView.m
//  BabySharing
//
//  Created by Alfred Yang on 9/07/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "LoginInputView.h"
#define BASICMARGIN         8

#define SNS_BUTTON_WIDTH    36
#define SNS_BUTTON_HEIGHT   SNS_BUTTON_WIDTH

#define SNS_QQ              0
#define SNS_WEIBO           1
#define SNS_WECHAT          2

#define SNS_COUNT           3

@implementation LoginInputView {
    UIButton * area_code_btn;
    UITextField * phone_area;
    UITextField * confirm_area;
    UIButton * next_btn;
    UIButton * confirm_btn;
    
    UILabel * split_label;
    UIButton * user_private_btn;
    NSArray* sns_btns;
    
    NSTimer* timer;
    NSInteger seconds;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@synthesize delegate = _delegate;

- (void)setUpWithFrame:(CGRect)rect {
    CGFloat width = rect.size.width;
//    CGFloat height = rect.size.height;
    
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];

    UIFont* font = [UIFont systemFontOfSize:19.f];
    CGSize phone_area_size = [@"888 888 88888" sizeWithFont:font constrainedToSize:CGSizeMake(FLT_MAX, FLT_MAX)];
    CGSize area_code_size = [@"+8888" sizeWithFont:font constrainedToSize:CGSizeMake(FLT_MAX, FLT_MAX)];
    CGSize confirm_btn_size = [@"发送验证码" sizeWithFont:font constrainedToSize:CGSizeMake(FLT_MAX, FLT_MAX)];
    CGSize user_private_btn_size = [@"用户协议" sizeWithFont:font constrainedToSize:CGSizeMake(FLT_MAX, FLT_MAX)];
   
    CGFloat first_line_width = phone_area_size.width + //4 * BASICMARGIN +
                               BASICMARGIN +
                               area_code_size.width + //4 * BASICMARGIN +
                                BASICMARGIN +
                                confirm_btn_size.width;// + 4 * BASICMARGIN;
    
    CGFloat first_line_start_margin = (width - first_line_width) / 2;
    area_code_btn = [[UIButton alloc]initWithFrame:CGRectMake(first_line_start_margin, BASICMARGIN, area_code_size.width, area_code_size.height)];
    area_code_btn.titleLabel.font = [UIFont systemFontOfSize:17.f];
    [area_code_btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [area_code_btn setTitle:@"+86" forState:UIControlStateNormal];
    [area_code_btn addTarget:self action:@selector(areaCodeBtnSelected:) forControlEvents:UIControlEventTouchDown];
  
    first_line_start_margin += BASICMARGIN + area_code_size.width;
    phone_area = [[UITextField alloc]initWithFrame:CGRectMake(first_line_start_margin, BASICMARGIN, phone_area_size.width + BASICMARGIN + confirm_btn_size.width, phone_area_size.height)];
    phone_area.font = [UIFont systemFontOfSize:17.f];
    CALayer* line_layer = [CALayer layer];
    line_layer.frame = CGRectMake(0, phone_area_size.height - 1, phone_area.frame.size.width, 1);
    line_layer.borderWidth = 1.f;
    line_layer.backgroundColor = [UIColor blackColor].CGColor;
    [phone_area.layer addSublayer:line_layer];
    phone_area.placeholder = @"输入您的手机号";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(phoneTextFieldChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    phone_area.delegate = self;
    phone_area.keyboardType = UIKeyboardTypeNumberPad;

    first_line_start_margin += BASICMARGIN + phone_area_size.width;
    confirm_btn = [[UIButton alloc]initWithFrame:CGRectMake(first_line_start_margin, BASICMARGIN, confirm_btn_size.width, confirm_btn_size.height)];
    confirm_btn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [confirm_btn setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    confirm_btn.backgroundColor = [UIColor redColor];
    confirm_btn.layer.borderWidth = 1.f;
    confirm_btn.layer.borderColor = [UIColor clearColor].CGColor;
    confirm_btn.layer.cornerRadius = 8.f;
    confirm_btn.clipsToBounds = YES;
    [confirm_btn setTitle:@"发送验证码" forState:UIControlStateNormal];
    [confirm_btn addTarget:self action:@selector(confirmBtnSelected:) forControlEvents:UIControlEventTouchDown];
    confirm_btn.hidden = YES;
    
    [self addSubview:area_code_btn];
    [self addSubview:phone_area];
    [self addSubview:confirm_btn];

    CGFloat second_line_start_margin = (width - first_line_width) / 2;
    CGFloat second_line_ver_margin = BASICMARGIN + phone_area_size.height + 2 * BASICMARGIN;
    
    confirm_area = [[UITextField alloc]initWithFrame:CGRectMake(second_line_start_margin, second_line_ver_margin, area_code_size.width + BASICMARGIN +  phone_area_size.width + BASICMARGIN + confirm_btn_size.width, phone_area_size.height)];
    confirm_area.font = [UIFont systemFontOfSize:17.f];
    CALayer* line_layer_2 = [CALayer layer];
    line_layer_2.frame = CGRectMake(0, phone_area_size.height - 1, confirm_area.frame.size.width, 1);
    line_layer_2.borderWidth = 1.f;
    line_layer_2.backgroundColor = [UIColor blackColor].CGColor;
    [confirm_area.layer addSublayer:line_layer_2];
    confirm_area.placeholder = @"请输入短信验证码";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(confirmCodeTextFieldChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    confirm_area.delegate = self;
    confirm_area.keyboardType = UIKeyboardTypeNumberPad;
    
    second_line_start_margin += BASICMARGIN + area_code_size.width + BASICMARGIN +  phone_area_size.width;
    next_btn = [[UIButton alloc]initWithFrame:CGRectMake(second_line_start_margin, second_line_ver_margin, confirm_btn_size.width, confirm_btn_size.height)];
    [next_btn addTarget:self action:@selector(nextBtnSelected:) forControlEvents:UIControlEventTouchDown];
    next_btn.titleLabel.font = [UIFont systemFontOfSize:17.f];
    [next_btn setTitle:@"下一步" forState:UIControlStateNormal];
    [next_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    NSString * filePath = [resourceBundle pathForResource:[NSString stringWithFormat:@"Next2"] ofType:@"png"];
    UIImage *image = [UIImage imageNamed:filePath];
    CALayer* imgLayer = [CALayer layer];
    imgLayer.contents = (id)image.CGImage;
    imgLayer.frame = CGRectMake(confirm_btn_size.width - 20, 3,  20, 15);
    [next_btn.layer addSublayer:imgLayer];
    next_btn.hidden = YES;

    [self addSubview:confirm_area];
    [self addSubview:next_btn];
    
    CGFloat third_line_start_margin = (width - first_line_width) / 2;
    CGFloat third_line_ver_margin = second_line_ver_margin + phone_area_size.height + 2 * BASICMARGIN;
    
    split_label = [[UILabel alloc]initWithFrame:CGRectMake(third_line_start_margin, third_line_ver_margin, width, phone_area_size.height)];
    split_label.font = [UIFont systemFontOfSize:17.f];
    split_label.text = @"社交账户登录";
    
    [self addSubview:split_label];
    
    UIButton* qq_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SNS_BUTTON_WIDTH, SNS_BUTTON_HEIGHT)];
    NSString * qq_file = [resourceBundle pathForResource:[NSString stringWithFormat:@"qq"] ofType:@"png"];
    UIImage * qq_image = [UIImage imageNamed:qq_file];
    [qq_btn setBackgroundImage:qq_image forState:UIControlStateNormal];
    [qq_btn addTarget:self action:@selector(qqBtnSelected:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:qq_btn];
    
    UIButton* weibo_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SNS_BUTTON_WIDTH, SNS_BUTTON_HEIGHT)];
    NSString * weibo_file = [resourceBundle pathForResource:[NSString stringWithFormat:@"weibo"] ofType:@"png"];
    UIImage * weibo_image = [UIImage imageNamed:weibo_file];
    [weibo_btn setBackgroundImage:weibo_image forState:UIControlStateNormal];
    [weibo_btn addTarget:self action:@selector(weiboBtnSelected:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:weibo_btn];
    
    UIButton* wechat_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SNS_BUTTON_WIDTH, SNS_BUTTON_HEIGHT)];
    NSString * wechat_file = [resourceBundle pathForResource:[NSString stringWithFormat:@"wechat"] ofType:@"png"];
    UIImage * wechat_image = [UIImage imageNamed:wechat_file];
    [wechat_btn setBackgroundImage:wechat_image forState:UIControlStateNormal];
    [wechat_btn addTarget:self action:@selector(wechatBtnSelected:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:wechat_btn];

    CGFloat forth_line_ver_line = third_line_ver_margin + phone_area_size.height + 2 * BASICMARGIN + SNS_BUTTON_HEIGHT / 2;
    weibo_btn.center = CGPointMake(width / 2, forth_line_ver_line);
    qq_btn.center = CGPointMake(width / 2 - 2 * SNS_BUTTON_WIDTH, forth_line_ver_line);
    wechat_btn.center = CGPointMake(width / 2 + 2 * SNS_BUTTON_WIDTH, forth_line_ver_line);
   
    CGFloat fifth_line_ver_line = forth_line_ver_line + SNS_BUTTON_HEIGHT / 2 + 2 * BASICMARGIN;
    user_private_btn = [[UIButton alloc]initWithFrame:CGRectMake(width - user_private_btn_size.width, fifth_line_ver_line, user_private_btn_size.width, user_private_btn_size.height)];
    user_private_btn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [user_private_btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [user_private_btn setTitle:@"用户协议" forState:UIControlStateNormal];
    [user_private_btn addTarget:self action:@selector(userPrivacyBtnSelected) forControlEvents:UIControlEventTouchDown];
    [self addSubview:user_private_btn];
    
    CGFloat height = fifth_line_ver_line + user_private_btn_size.height + BASICMARGIN;
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
        confirm_btn.hidden = YES;
    } else {
        confirm_btn.hidden = NO;
    }
}

- (void)confirmCodeTextFieldChanged:(UITextField*)tf {
    if ([confirm_area.text isEqualToString:@""]) {
        next_btn.hidden = YES;
    } else {
        next_btn.hidden = NO;
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
        [confirm_btn setTitle:[NSString stringWithFormat:@"(%d)秒重试", seconds] forState:UIControlStateDisabled];
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
    [area_code_btn setTitle:[@"+" stringByAppendingString:code] forState:UIControlStateNormal];
}
@end
