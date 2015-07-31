//
//  QueryOwnerCell.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 12/01/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "QueryOwnerCell.h"
#import "TmpFileStorageModel.h"

#define HEADER_HEIGHT       44

#define MARGIN              8

#define USER_IMG_WIDTH      32
#define USER_IMG_HEIGHT     USER_IMG_WIDTH

#define ROLE_TAG_WIDTH      80
#define ROLE_TAG_HEIGHT     25

@implementation QueryOwnerCell

@synthesize userImg = _userImg;
@synthesize userRoleTagBtn = _userRoleTagBtn;
@synthesize userNameLabel = _userNameLabel;
@synthesize pushBtn = _pushBtn;
@synthesize locationLabel = _locationLabel;

@synthesize owner_id = _owner_id;
@synthesize delegate = _delegate;

- (void)setUpSubviews {
    if (!_userImg) {
        _userImg = [[UIImageView alloc]init];
        [self addSubview:_userImg];
    }
    
    if (!_userRoleTagBtn) {
        _userRoleTagBtn = [[UIButton alloc]init];
        [self addSubview:_userRoleTagBtn];
    }
    
    if (!_userNameLabel) {
        _userNameLabel = [[UILabel alloc]init];
        [self addSubview:_userNameLabel];
    }
    
    if (!_locationLabel) {
        _locationLabel = [[UILabel alloc]init];
        [self addSubview:_locationLabel];
    }
    
    if (!_pushBtn) {
        _pushBtn = [[UIButton alloc]init];
        [self addSubview:_pushBtn];
    }
}

- (void)awakeFromNib {
    [self setUpSubviews];
    
    CGFloat offset = MARGIN * 2;
    
    _userImg.bounds = CGRectMake(0, 0, USER_IMG_WIDTH, USER_IMG_HEIGHT);
    _userImg.center = CGPointMake(offset + USER_IMG_WIDTH / 2, HEADER_HEIGHT / 2);
    _userImg.layer.cornerRadius = USER_IMG_WIDTH / 2;
    _userImg.clipsToBounds = YES;
    
    offset += USER_IMG_WIDTH + MARGIN;
    
    UIFont* font = [UIFont systemFontOfSize:14.f];
    _userNameLabel.font = font;
    CGSize user_name_size = [@"渊渊渊渊渊渊" sizeWithFont:font constrainedToSize:CGSizeMake(FLT_MAX, FLT_MAX)];
    _userNameLabel.frame = CGRectMake(offset, _userImg.frame.origin.y - MARGIN / 2, user_name_size.width, user_name_size.height);
    
    font = [UIFont systemFontOfSize:11.f];
    _locationLabel.font = font;
    CGSize location_size = [@"杨杨杨杨杨杨杨杨杨杨杨" sizeWithFont:font constrainedToSize:CGSizeMake(FLT_MAX, FLT_MAX)];
    _locationLabel.frame = CGRectMake(offset, _userNameLabel.frame.origin.y + user_name_size.height + MARGIN / 2, location_size.width, location_size.height);
    
    
    offset += user_name_size.width + MARGIN;
    _userRoleTagBtn.font = font;
    _userRoleTagBtn.frame = CGRectMake(offset, _userNameLabel.frame.origin.y, ROLE_TAG_WIDTH, ROLE_TAG_HEIGHT);
    _userRoleTagBtn.layer.borderColor = [UIColor blueColor].CGColor;
    _userRoleTagBtn.layer.borderWidth = 1.f;
    _userRoleTagBtn.layer.cornerRadius = MARGIN;
    _userRoleTagBtn.clipsToBounds = YES;
    _userRoleTagBtn.backgroundColor = [UIColor whiteColor];
    [_userRoleTagBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    _pushBtn.bounds = CGRectMake(0, 0, 50, 25);
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    _pushBtn.center = CGPointMake(width - MARGIN * 2 - 25, HEADER_HEIGHT / 2);
    [_pushBtn setTitle:@"+关注" forState:UIControlStateNormal];
    [_pushBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    _pushBtn.layer.borderColor = [UIColor blueColor].CGColor;
    _pushBtn.layer.borderWidth = 1.f;
    _pushBtn.layer.cornerRadius = 4.f;
    _pushBtn.clipsToBounds = YES;
}

+ (CGFloat)preferHeight {
    return 44;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)didSelectFollowBtn {
    [_delegate didSelectDetialFollowOwner];
}

- (void)didSelectImageOrName:(UITapGestureRecognizer*)sender {
    [_delegate didSelectDetialOwnerNameOrImage:_owner_id];
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

- (void)setLocation:(NSString*)location {
    _locationLabel.text = location;
    [_locationLabel sizeToFit];
}

- (void)setRoleTag:(NSString *)role_tag {
    [_userRoleTagBtn setTitle:role_tag forState:UIControlStateNormal];
}
@end
