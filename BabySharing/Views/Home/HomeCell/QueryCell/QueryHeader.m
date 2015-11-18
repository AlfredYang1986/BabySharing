//
//  QueryHeader.m
//  BabySharing
//
//  Created by Alfred Yang on 30/07/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "QueryHeader.h"
#import "TmpFileStorageModel.h"

#define HEADER_HEIGHT       44

#define MARGIN              8

#define USER_IMG_WIDTH      32
#define USER_IMG_HEIGHT     USER_IMG_WIDTH

#define ROLE_TAG_WIDTH      80
#define ROLE_TAG_HEIGHT     25


@implementation QueryHeader {
    UILabel* pushLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@synthesize userImg = _userImg;
@synthesize userRoleTagBtn = _userRoleTagBtn;
@synthesize userNameLabel = _userNameLabel;
@synthesize pushTimesLabel = _pushTimesLabel;
@synthesize pushBtn = _pushBtn;
@synthesize tagLabel = _tagLabel;

@synthesize content = _content;
@synthesize delegate = _delegate;

- (void)setUpSubviews {
    if (!_userImg) {
        _userImg = [[UIImageView alloc]init];
        [self addSubview:_userImg];
    }
   
    if (!_userRoleTagBtn) {
//        _userRoleTagBtn = [[UIButton alloc]init];
//        [self addSubview:_userRoleTagBtn];
    }
   
    if (!_userNameLabel) {
        _userNameLabel = [[UILabel alloc]init];
        [self addSubview:_userNameLabel];
    }
    
    if (!_tagLabel) {
//        _locationLabel = [[UILabel alloc]init];
//        [self addSubview:_locationLabel];
        _tagLabel = [[UILabel alloc]init];
        [self addSubview:_tagLabel];
    }

    if (!_pushTimesLabel) {
        _pushTimesLabel = [[UILabel alloc]init];
        [self addSubview:_pushTimesLabel];
    }

    if (!_pushBtn) {
        _pushBtn = [[UIButton alloc]init];
        [self addSubview:_pushBtn];
    }
    
    if (!pushLabel) {
//        pushLabel = [[UILabel alloc]init];
//        [self addSubview:pushLabel];
    }
   
//    self.backgroundView.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.3];
    self.backgroundView.backgroundColor = [UIColor colorWithRed:0.9098 green:0.9059 blue:0.9059 alpha:0.3];
}

- (void)layoutSubviews {
    CGFloat offset = MARGIN * 2;

    _userImg.bounds = CGRectMake(0, 0, USER_IMG_WIDTH, USER_IMG_HEIGHT);
    _userImg.center = CGPointMake(offset + USER_IMG_WIDTH / 2, HEADER_HEIGHT / 2);
    _userImg.layer.cornerRadius = USER_IMG_WIDTH / 2;
    _userImg.clipsToBounds = YES;
    _userImg.userInteractionEnabled = YES;
    
    UITapGestureRecognizer* img_tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didScreenImgSelected)];
    [_userImg addGestureRecognizer:img_tap];
  
    offset += USER_IMG_WIDTH + MARGIN;
    
    UIFont* font = [UIFont systemFontOfSize:14.f];
    _userNameLabel.font = font;
    CGSize user_name_size = [@"渊渊渊渊渊渊" sizeWithFont:font constrainedToSize:CGSizeMake(FLT_MAX, FLT_MAX)];
    _userNameLabel.frame = CGRectMake(offset, _userImg.frame.origin.y - MARGIN / 2, user_name_size.width, user_name_size.height);
   
    font = [UIFont systemFontOfSize:11.f];
    _tagLabel.font = font;
    CGSize location_size = [@"杨杨杨杨杨杨杨杨杨杨杨" sizeWithFont:font constrainedToSize:CGSizeMake(FLT_MAX, FLT_MAX)];
    _tagLabel.frame = CGRectMake(offset, _userNameLabel.frame.origin.y + user_name_size.height + MARGIN / 2, location_size.width, location_size.height);
    
   
    offset += user_name_size.width + MARGIN;
    _userRoleTagBtn.font = font;
    _userRoleTagBtn.frame = CGRectMake(offset, _userNameLabel.frame.origin.y, ROLE_TAG_WIDTH, ROLE_TAG_HEIGHT);
    _userRoleTagBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    _userRoleTagBtn.layer.borderWidth = 1.f;
    _userRoleTagBtn.layer.cornerRadius = MARGIN;
    _userRoleTagBtn.clipsToBounds = YES;
    _userRoleTagBtn.backgroundColor = [UIColor whiteColor];
    [_userRoleTagBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    _pushBtn.bounds = CGRectMake(0, 0, 25, 25);
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    _pushBtn.center = CGPointMake(width - MARGIN - 13, HEADER_HEIGHT / 2);
    _pushBtn.backgroundColor = [UIColor clearColor];
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    NSString * filePath = [resourceBundle pathForResource:[NSString stringWithFormat:@"Push"] ofType:@"png"];
    [_pushBtn setBackgroundImage:[UIImage imageNamed:filePath] forState:UIControlStateNormal];
    
    font = [UIFont systemFontOfSize:14.f];
    _pushTimesLabel.font = font;
    CGSize times_size = [@"123456789" sizeWithFont:font constrainedToSize:CGSizeMake(FLT_MAX, FLT_MAX)];
//    _pushTimesLabel.frame = CGRectMake(width - MARGIN - _pushBtn.frame.size.width - times_size.width, _userImg.frame.origin.y, times_size.width, times_size.height);
    _pushTimesLabel.frame = CGRectMake(width - MARGIN - _pushBtn.frame.size.width - times_size.width - MARGIN, HEADER_HEIGHT / 2 - times_size.height / 2, times_size.width, times_size.height);
    _pushTimesLabel.textAlignment = NSTextAlignmentRight;
    
    font = [UIFont systemFontOfSize:11.f];
    pushLabel.font = font;
    CGSize push_size = [@"推荐" sizeWithFont:font constrainedToSize:CGSizeMake(FLT_MAX, FLT_MAX)];
    pushLabel.frame = CGRectMake(width - MARGIN - _pushBtn.frame.size.width - push_size.width, _userNameLabel.frame.origin.y + user_name_size.height + MARGIN / 2, push_size.width, push_size.height);
    pushLabel.text = @"推荐";
    pushLabel.textAlignment = NSTextAlignmentRight;
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
}

- (void)setTagText:(NSString*)location {
    _tagLabel.text = location;
    [_tagLabel sizeToFit];
}

- (void)setRoleTag:(NSString *)role_tag {
    [_userRoleTagBtn setTitle:role_tag forState:UIControlStateNormal];
}

- (void)setTimes:(NSString*)times {
    _pushTimesLabel.text = times;
    [_pushTimesLabel sizeToFit];
}

- (void)didScreenImgSelected {
    [_delegate didSelectScreenImg:_content];
}
@end
