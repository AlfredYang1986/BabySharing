//
//  QueryHeader.m
//  BabySharing
//
//  Created by Alfred Yang on 30/07/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "QueryHeader.h"
#import "TmpFileStorageModel.h"
#import "OBShapedButton.h"

#define HEADER_HEIGHT                   46
#define MARGIN                          8

#define USER_IMG_MARGIN                 10.5f
#define USER_IMG_WIDTH                  32
#define USER_IMG_HEIGHT                 USER_IMG_WIDTH

#define ROLE_TAG_WIDTH                  40
#define ROLE_TAG_HEIGHT                 15
#define ROLE_TAG_MARGIN                 2

#define HEADER_MARGIN_TO_SCREEN         8

#define ICE_HOT_ICON_WIDTH              18
#define ICE_HOT_ICON_HEIGHT             18
#define HOT_RIGHT_MARGIN                10.5f

#define TAG_2_NAME_MARGIN               10
#define USER_NAME_TOP_MARGIN            8

#define TIME_ICON_WIDTH                 16

#define FONT_SIZE                       12.f

@implementation QueryHeader {
//    UILabel* pushLabel;
}

@synthesize userImg = _userImg;
@synthesize userRoleTagBtn = _userRoleTagBtn;
@synthesize userNameLabel = _userNameLabel;
//@synthesize pushTimesLabel = _pushTimesLabel;
//@synthesize pushBtn = _pushBtn;
@synthesize timeLabel = _timeLabel;
@synthesize hotCountView = _hotCountView;

@synthesize content = _content;
@synthesize delegate = _delegate;

+ (CGFloat)preferredHeight {
    return HEADER_HEIGHT;
}

- (void)setUpSubviews {
    UIFont* font = [UIFont systemFontOfSize:FONT_SIZE];
    
    if (!_userImg) {
        _userImg = [[UIImageView alloc]init];
        [self addSubview:_userImg];
        
        _userImg.bounds = CGRectMake(0, 0, USER_IMG_WIDTH, USER_IMG_HEIGHT);
        _userImg.center = CGPointMake(USER_IMG_MARGIN + USER_IMG_WIDTH / 2, HEADER_HEIGHT / 2);
        _userImg.layer.cornerRadius = USER_IMG_WIDTH / 2;
        _userImg.clipsToBounds = YES;
        _userImg.userInteractionEnabled = YES;
        _userImg.layer.borderColor = [UIColor colorWithWhite:1.f alpha:0.25].CGColor;
        _userImg.layer.borderWidth = 1.5f;
        
        UITapGestureRecognizer* img_tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didScreenImgSelected)];
        [_userImg addGestureRecognizer:img_tap];
    }
   
    if (!_userRoleTagBtn) {
        _userRoleTagBtn = [[OBShapedButton alloc]init];
//        NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
        NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
        NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
        NSString * filePath = [resourceBundle pathForResource:[NSString stringWithFormat:@"home_role_tag"] ofType:@"png"];
        [_userRoleTagBtn setBackgroundImage:[UIImage imageNamed:filePath] forState:UIControlStateNormal];
        [self addSubview:_userRoleTagBtn];
        
        _userRoleTagBtn.clipsToBounds = YES;
    }
   
    if (!_userNameLabel) {
        _userNameLabel = [[UILabel alloc]init];
        [self addSubview:_userNameLabel];
        
        _userNameLabel.font = [UIFont systemFontOfSize:13.f];
//        _userNameLabel.textColor = [UIColor colorWithRed:0.6078 green:0.6078 blue:0.6078 alpha:1.f];
        _userNameLabel.textColor = [UIColor colorWithRed:0.3059 green:0.3059 blue:0.3059 alpha:1.f];
    }
    
    if (!_timeLabel) {
        _timeLabel = [[UIView alloc]init];
        [self addSubview:_timeLabel];
    }

    if (!_hotCountView) {
        _hotCountView = [[UIView alloc]init];
        [self addSubview:_hotCountView];
    }
}

- (void)layoutSubviews {
    UIFont* font = [UIFont systemFontOfSize:FONT_SIZE];
    
    CGSize sz = [@"1234" sizeWithFont:font constrainedToSize:CGSizeMake(FLT_MAX, FLT_MAX)];
    CGFloat width = self.frame.size.width;
    CGFloat view_width = ICE_HOT_ICON_WIDTH + sz.width + ICE_HOT_ICON_WIDTH;
    _hotCountView.frame = CGRectMake(0, 0, view_width, sz.height);
    _hotCountView.center = CGPointMake(width - view_width / 2 - HOT_RIGHT_MARGIN, HEADER_HEIGHT / 2 - 2);
}

- (void)setUserPhoto:(NSString*)photo_name {

    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    NSString * filePath = [resourceBundle pathForResource:[NSString stringWithFormat:@"User"] ofType:@"png"];
    
    UIImage* userImg = [TmpFileStorageModel enumImageWithName:photo_name withDownLoadFinishBolck:^(BOOL success, UIImage *user_img) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self) {
                    self.userImg.image = user_img;
                    NSLog(@"owner img download success");
                }
            });
        } else {
            NSLog(@"down load owner image %@ failed", photo_name);
        }
    }];

    if (userImg == nil) {
        userImg = [UIImage imageNamed:filePath];
    }
    [self.userImg setImage:userImg];
}

- (void)setUserName:(NSString*)name {
    _userNameLabel.text = name;
    [_userNameLabel sizeToFit];
   
//    _userNameLabel.center = CGPointMake(_userRoleTagBtn.center.x + _userRoleTagBtn.frame.size.width / 2 + TAG_2_NAME_MARGIN + _userNameLabel.frame.size.width / 2, USER_NAME_TOP_MARGIN + _userNameLabel.frame.size.height / 2);
    _userNameLabel.center = CGPointMake(USER_IMG_MARGIN + USER_IMG_WIDTH + USER_IMG_MARGIN + _userNameLabel.frame.size.width / 2, USER_NAME_TOP_MARGIN + _userNameLabel.frame.size.height / 2);
}

- (void)setTimeText:(NSString*)time {
//    UIImageView* img = [_timeLabel viewWithTag:-1];
//    if (img == nil) {
//        img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, TIME_ICON_WIDTH, TIME_ICON_WIDTH)];
//        NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
//        NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
//        NSString * filePath = [resourceBundle pathForResource:[NSString stringWithFormat:@"home-time-icon"] ofType:@"png"];
//        img.image = [UIImage imageNamed:filePath];
//        img.tag = -1;
//        [_timeLabel addSubview:img];
//    }
    
    UIFont* font = [UIFont systemFontOfSize:10.f];
    UILabel* label = [_timeLabel viewWithTag:-2];
    if (label == nil) {
        label = [[UILabel alloc]init];
        label.textColor = [UIColor colorWithRed:0.6078 green:0.6078 blue:0.6078 alpha:1.f];
        label.font = font;
        label.tag = -2;
        [_timeLabel addSubview:label];
    }
    
    label.text = time;
    CGSize sz = [label.text sizeWithFont:font constrainedToSize:CGSizeMake(FLT_MAX, FLT_MAX)];
//    label.frame = CGRectMake(TIME_ICON_WIDTH, 0, sz.width, MAX(TIME_ICON_WIDTH, sz.height));
    label.frame = CGRectMake(0, 0, sz.width, MAX(TIME_ICON_WIDTH, sz.height));
    
    _timeLabel.frame = CGRectMake(68, 25, TIME_ICON_WIDTH + label.frame.size.width, label.frame.size.height);
}

- (void)setTime:(NSDate*)date {
    
//    UIImageView* img = [_timeLabel viewWithTag:-1];
//    if (img == nil) {
//        img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, TIME_ICON_WIDTH, TIME_ICON_WIDTH)];
//        NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
//        NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
//        NSString * filePath = [resourceBundle pathForResource:[NSString stringWithFormat:@"home-time-icon"] ofType:@"png"];
//        img.image = [UIImage imageNamed:filePath];
//        img.tag = -1;
//        [_timeLabel addSubview:img];
//    }
    
    UIFont* font = [UIFont systemFontOfSize:10.f];
    UILabel* label = [_timeLabel viewWithTag:-2];
    if (label == nil) {
        label = [[UILabel alloc]init];
        label.textColor = [UIColor colorWithRed:0.6078 green:0.6078 blue:0.6078 alpha:1.f];
        label.font = font;
        label.tag = -2;
        [_timeLabel addSubview:label];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.formatterBehavior = NSDateFormatterBehavior10_4;
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;

    label.text = [formatter stringForObjectValue:date];
    CGSize sz = [label.text sizeWithFont:font constrainedToSize:CGSizeMake(FLT_MAX, FLT_MAX)];
//    label.frame = CGRectMake(TIME_ICON_WIDTH, 0, sz.width, MAX(TIME_ICON_WIDTH, sz.height));
    label.frame = CGRectMake(0, 0, sz.width, MAX(TIME_ICON_WIDTH, sz.height));
    
    _timeLabel.frame = CGRectMake(USER_IMG_MARGIN + USER_IMG_WIDTH + USER_IMG_MARGIN, 25, TIME_ICON_WIDTH + label.frame.size.width, label.frame.size.height);
}

- (void)setRoleTag:(NSString *)role_tag {
    UILabel* label = [_userRoleTagBtn viewWithTag:-1];
    if (label == nil) {
        label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:FONT_SIZE];
        label.textColor = [UIColor whiteColor];
        label.tag = -1;
        [_userRoleTagBtn addSubview:label];
    }
    
    label.text = role_tag;
    [label sizeToFit];
    label.center = CGPointMake(5 + label.frame.size.width / 2, ROLE_TAG_MARGIN + label.frame.size.height / 2);
    
    _userRoleTagBtn.frame = CGRectMake(_userNameLabel.center.x + _userNameLabel.frame.size.width / 2 + TAG_2_NAME_MARGIN, 6, label.frame.size.width + 10 + ROLE_TAG_MARGIN, label.frame.size.height + 2 * ROLE_TAG_MARGIN);
}

- (void)setPushTimes:(NSString*)times {

    UIImageView* img = [_hotCountView viewWithTag:-1];
    if (img == nil) {
        img = [[UIImageView alloc]initWithFrame:CGRectMake(8, 0, ICE_HOT_ICON_WIDTH, ICE_HOT_ICON_HEIGHT)];
        NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
        NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
        NSString * filePath = [resourceBundle pathForResource:[NSString stringWithFormat:@"home_fire"] ofType:@"png"];
        img.image = [UIImage imageNamed:filePath];
        img.tag = -1;
        [_hotCountView addSubview:img];
    }
   
    UIFont* font = [UIFont systemFontOfSize:FONT_SIZE];
    UILabel* label = [_hotCountView viewWithTag:-2];
    if (label == nil) {
        label = [[UILabel alloc]init];
//        label.textColor = [UIColor colorWithRed:0.6078 green:0.6078 blue:0.6078 alpha:1.f];
        label.textColor = [UIColor colorWithRed:0.3059 green:0.3059 blue:0.3059 alpha:1.f];
        label.font = font;
        label.tag = -2;
        label.textAlignment = NSTextAlignmentCenter;
        [_hotCountView addSubview:label];
    }
 
#define HOT_ICON_LABEL_MARGIN   10.5f
    label.text = times;
    CGSize sz = [label.text sizeWithFont:font constrainedToSize:CGSizeMake(FLT_MAX, FLT_MAX)];
    label.frame = CGRectMake(ICE_HOT_ICON_WIDTH + HOT_ICON_LABEL_MARGIN, 0, sz.width, MAX(ICE_HOT_ICON_HEIGHT, sz.height));
  
    CGFloat width = self.frame.size.width;
    CGFloat view_width = ICE_HOT_ICON_WIDTH + label.frame.size.width + HOT_ICON_LABEL_MARGIN;
    _hotCountView.frame = CGRectMake(0, 0, view_width, label.frame.size.height);
    _hotCountView.center = CGPointMake(width - view_width / 2 - HOT_RIGHT_MARGIN, HEADER_HEIGHT / 2 - 2);
}

- (void)didScreenImgSelected {
    [_delegate didSelectScreenImg:_content];
}
@end
