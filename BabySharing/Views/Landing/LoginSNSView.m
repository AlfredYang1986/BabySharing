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

#define SNS_BUTTON_MARGIN                   80

#define SNS_WECHAT                          0
#define SNS_QQ                              1
#define SNS_WEIBO                           2

#define SNS_COUNT                           3

@implementation LoginSNSView {
    UIImageView* split_img;
    UIButton * user_private_btn;
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
    
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    
    NSString * bundlePath_dongda = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle_dongda = [NSBundle bundleWithPath:bundlePath_dongda];

    UIFont* font = [UIFont systemFontOfSize:14.f];
    CGSize sz = [@"用户协议&隐私政策" sizeWithFont:font constrainedToSize:CGSizeMake(FLT_MAX, FLT_MAX)];

    CGFloat third_line_ver_margin = BASICMARGIN;
    CGFloat screen_width = [UIScreen mainScreen].bounds.size.width;
    split_img = [[UIImageView alloc]initWithFrame:CGRectMake(0, third_line_ver_margin, screen_width, sz.height)];
    NSString * split_file = [resourceBundle pathForResource:[NSString stringWithFormat:@"split-file"] ofType:@"png"];
    split_img.image = [UIImage imageNamed:split_file];

    [self addSubview:split_img];

    UIButton* qq_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SNS_BUTTON_WIDTH, SNS_BUTTON_HEIGHT)];
    NSString * qq_file = [resourceBundle_dongda pathForResource:[NSString stringWithFormat:@"login_qq"] ofType:@"png"];
    UIImage * qq_image = [UIImage imageNamed:qq_file];
    [qq_btn setBackgroundImage:qq_image forState:UIControlStateNormal];
    [qq_btn addTarget:self action:@selector(qqBtnSelected:) forControlEvents:UIControlEventTouchDown];
    qq_btn.backgroundColor = [UIColor clearColor];
//    qq_btn.layer.cornerRadius = SNS_BUTTON_WIDTH / 2;
//    qq_btn.clipsToBounds = YES;
    qq_btn.contentMode = UIViewContentModeCenter;
    [self addSubview:qq_btn];

    UIButton* weibo_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SNS_BUTTON_WIDTH, SNS_BUTTON_HEIGHT)];
    NSString * weibo_file = [resourceBundle_dongda pathForResource:[NSString stringWithFormat:@"login_weibo"] ofType:@"png"];
    UIImage * weibo_image = [UIImage imageNamed:weibo_file];
    [weibo_btn setBackgroundImage:weibo_image forState:UIControlStateNormal];
    [weibo_btn addTarget:self action:@selector(weiboBtnSelected:) forControlEvents:UIControlEventTouchDown];
    weibo_btn.backgroundColor = [UIColor clearColor];
//    weibo_btn.layer.cornerRadius = SNS_BUTTON_WIDTH / 2;
//    weibo_btn.clipsToBounds = YES;
    weibo_btn.contentMode = UIViewContentModeCenter;
    [self addSubview:weibo_btn];

    UIButton* wechat_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SNS_BUTTON_WIDTH, SNS_BUTTON_HEIGHT)];
    NSString * wechat_file = [resourceBundle_dongda pathForResource:[NSString stringWithFormat:@"login_wechat"] ofType:@"png"];
    UIImage * wechat_image = [UIImage imageNamed:wechat_file];
    [wechat_btn setBackgroundImage:wechat_image forState:UIControlStateNormal];
    [wechat_btn addTarget:self action:@selector(wechatBtnSelected:) forControlEvents:UIControlEventTouchDown];
    wechat_btn.backgroundColor = [UIColor clearColor];
    wechat_btn.clipsToBounds = YES;
//    wechat_btn.layer.cornerRadius = SNS_BUTTON_WIDTH / 2;
//    wechat_btn.contentMode = UIViewContentModeCenter;
    [self addSubview:wechat_btn];

    CGFloat forth_line_ver_line = third_line_ver_margin + sz.height + 2 * BASICMARGIN + SNS_BUTTON_HEIGHT / 2;
    wechat_btn.center = CGPointMake(width / 2 - SNS_BUTTON_MARGIN, forth_line_ver_line);
    qq_btn.center = CGPointMake(width / 2, forth_line_ver_line);
    weibo_btn.center = CGPointMake(width / 2 + SNS_BUTTON_MARGIN, forth_line_ver_line);

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

- (void)userPrivacyBtnSelected {
    [_delegate didSelectUserPrivacyBtn];
}
@end
