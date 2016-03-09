//
//  LoginSNSView.m
//  BabySharing
//
//  Created by Alfred Yang on 1/12/16.
//  Copyright © 2016 BM. All rights reserved.
//

#import "LoginSNSView.h"

#define BASICMARGIN     8

#define SNS_BUTTON_WIDTH                    25
#define SNS_BUTTON_HEIGHT                   SNS_BUTTON_WIDTH

#define SNS_BUTTON_MARGIN                   width / 3.8

#define SNS_WECHAT                          0
#define SNS_QQ                              1
#define SNS_WEIBO                           2

#define SNS_COUNT                           3

#define INPUT_MARGIN                        32.5

#define MARGIN_MODIFY                       5

@implementation LoginSNSView {
    UIView* split_img;
    NSArray* sns_btns;
}

@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)rect {
    self = [super initWithFrame:rect];
    if (self) {
        [self setUpSNSViewWihtRect:rect];
    }
    return self;
}

- (void)setUpSNSViewWihtRect:(CGRect)rect {
    CGFloat width = rect.size.width;
    
//    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
//    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    
    NSString * bundlePath_dongda = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle_dongda = [NSBundle bundleWithPath:bundlePath_dongda];

    
    NSDictionary* attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:12]};
    CGSize sz = [@"用户协议&隐私政策"  sizeWithAttributes:attributes];
//    UIFont* font = [UIFont systemFontOfSize:14.f];
//    CGSize sz = [@"用户协议&隐私政策" sizeWithFont:font constrainedToSize:CGSizeMake(FLT_MAX, FLT_MAX)];

#define SPLIT_VIEW_HEIGHT                   18
#define SPLIT_VIEW_TEXT_WIDTH               128
#define SPLIT_VIEW_TEXT_LINE_MARGIN         13.5
    
    CGFloat third_line_ver_margin = BASICMARGIN;
    CGFloat screen_width = [UIScreen mainScreen].bounds.size.width;
    split_img = [[UIView alloc]initWithFrame:CGRectMake(0, third_line_ver_margin, screen_width, SPLIT_VIEW_HEIGHT)];
    
    CATextLayer* text_layer = [CATextLayer layer];
    text_layer.foregroundColor = [UIColor colorWithWhite:0.2902 alpha:1.f].CGColor;
    text_layer.string = @"或使用社交账户登录";
    text_layer.fontSize = 14.f;
    text_layer.contentsScale = 2.f;
    text_layer.alignmentMode = @"center";
    text_layer.frame = CGRectMake(0, 0, SPLIT_VIEW_TEXT_WIDTH, SPLIT_VIEW_HEIGHT);
    text_layer.position = CGPointMake(screen_width / 2, SPLIT_VIEW_HEIGHT / 2);
    [split_img.layer addSublayer:text_layer];
    
    [self addSubview:split_img];

    UIButton* qq_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SNS_BUTTON_WIDTH, SNS_BUTTON_HEIGHT)];
    NSString * qq_file = [resourceBundle_dongda pathForResource:[NSString stringWithFormat:@"login_qq_gray"] ofType:@"png"];
    UIImage * qq_image = [UIImage imageNamed:qq_file];
    [qq_btn setBackgroundImage:qq_image forState:UIControlStateNormal];
    [qq_btn addTarget:self action:@selector(qqBtnSelected:) forControlEvents:UIControlEventTouchDown];
    qq_btn.backgroundColor = [UIColor clearColor];
    qq_btn.contentMode = UIViewContentModeCenter;
    [self addSubview:qq_btn];

    UIButton* weibo_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SNS_BUTTON_WIDTH, SNS_BUTTON_HEIGHT)];
    NSString * weibo_file = [resourceBundle_dongda pathForResource:[NSString stringWithFormat:@"login_weibo_gray"] ofType:@"png"];
    UIImage * weibo_image = [UIImage imageNamed:weibo_file];
    [weibo_btn setBackgroundImage:weibo_image forState:UIControlStateNormal];
    [weibo_btn addTarget:self action:@selector(weiboBtnSelected:) forControlEvents:UIControlEventTouchDown];
    weibo_btn.backgroundColor = [UIColor clearColor];
    weibo_btn.contentMode = UIViewContentModeCenter;
    [self addSubview:weibo_btn];

    UIButton* wechat_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SNS_BUTTON_WIDTH, SNS_BUTTON_HEIGHT)];
    NSString * wechat_file = [resourceBundle_dongda pathForResource:[NSString stringWithFormat:@"login_wechat_gray"] ofType:@"png"];
    UIImage * wechat_image = [UIImage imageNamed:wechat_file];
    [wechat_btn setBackgroundImage:wechat_image forState:UIControlStateNormal];
    [wechat_btn addTarget:self action:@selector(wechatBtnSelected:) forControlEvents:UIControlEventTouchDown];
    wechat_btn.backgroundColor = [UIColor clearColor];
    wechat_btn.clipsToBounds = YES;
    [self addSubview:wechat_btn];

    CGFloat forth_line_ver_line = third_line_ver_margin + sz.height + MARGIN_MODIFY / 2 + 2 * BASICMARGIN + SNS_BUTTON_HEIGHT / 2;
    CGFloat fifth_line_ver_line = forth_line_ver_line + SNS_BUTTON_HEIGHT / 2 + 2 * BASICMARGIN;
    
    CGFloat height = fifth_line_ver_line + sz.height + BASICMARGIN + MARGIN_MODIFY;
    self.bounds = CGRectMake(0, 0, width, height);
    
    wechat_btn.center = CGPointMake(width / 2, height / 2 + SPLIT_VIEW_HEIGHT / 2);
    qq_btn.center = CGPointMake(width / 2 - SNS_BUTTON_MARGIN, height / 2 + SPLIT_VIEW_HEIGHT / 2);
    weibo_btn.center = CGPointMake(width / 2 + SNS_BUTTON_MARGIN, height / 2 + SPLIT_VIEW_HEIGHT / 2);
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

- (void)userPrivacyBtnSelected {
    [_delegate didSelectUserPrivacyBtn];
}
@end
