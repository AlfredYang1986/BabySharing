//
//  MessageFriendsCell.m
//  BabySharing
//
//  Created by Alfred Yang on 11/12/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import "MessageFriendsCell.h"
#import "OBShapedButton.h"
#import "TmpFileStorageModel.h"

#define IMG_WIDTH       40
#define IMG_HEIGHT      IMG_WIDTH

#define PREFERRED_HEIGHT    80

#define NAME_LEFT_MARGIN    10.5

@interface MessageFriendsCell ()
@property (weak, nonatomic) IBOutlet UIImageView *user_screen_photo;
@property (weak, nonatomic) IBOutlet UIView *relationContainer;
@property (nonatomic, strong) OBShapedButton* userRoleTagBtn;
@property (nonatomic, strong) UILabel* userNameLabel;
@end

@implementation MessageFriendsCell

@synthesize user_screen_photo = _user_screen_photo;
@synthesize relationContainer = _relationContainer;
@synthesize userRoleTagBtn = _userRoleTagBtn;
@synthesize userNameLabel = _userNameLabel;

+ (CGFloat)preferredHeight {
    return PREFERRED_HEIGHT;
}

- (void)awakeFromNib {
    // Initialization code
    _user_screen_photo.layer.borderColor = [UIColor colorWithWhite:1.f alpha:0.25].CGColor;
    _user_screen_photo.layer.borderWidth = 1.5f;
    _user_screen_photo.layer.cornerRadius = IMG_WIDTH / 2;
    _user_screen_photo.clipsToBounds = YES;
   
    if (_userRoleTagBtn == nil) {
        _userRoleTagBtn = [[OBShapedButton alloc]init];
        NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
        NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
        [_userRoleTagBtn setBackgroundImage:[UIImage imageNamed:[resourceBundle pathForResource:@"home_role_tag" ofType:@"png"]] forState:UIControlStateNormal];
        [self addSubview:_userRoleTagBtn];
    }

    if (_userNameLabel == nil) {
        _userNameLabel = [[UILabel alloc]init];
        _userNameLabel.textColor = [UIColor colorWithWhite:0.4667 alpha:1.f];
        _userNameLabel.font = [UIFont systemFontOfSize:14.f];
        [self addSubview:_userNameLabel];
    }
    
    CALayer* line = [CALayer layer];
    line.borderWidth = 1.f;
    line.borderColor = [UIColor colorWithWhite:0.5922 alpha:0.25].CGColor;
    line.frame = CGRectMake(0, PREFERRED_HEIGHT - 1, [UIScreen mainScreen].bounds.size.width + 10, 1);
    [self.layer addSublayer:line];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUserScreenPhoto:(NSString*)photo_name {
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    NSString * filePath = [resourceBundle pathForResource:[NSString stringWithFormat:@"User"] ofType:@"png"];
    
    UIImage* userImg = [TmpFileStorageModel enumImageWithName:photo_name withDownLoadFinishBolck:^(BOOL success, UIImage *user_img) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                _user_screen_photo.image = user_img;
            });
        } else {
            NSLog(@"down load owner image");
        }
    }];
    
    if (userImg == nil) {
        userImg = [UIImage imageNamed:filePath];
    }
    [_user_screen_photo setImage:userImg];
}

- (void)setRelationship:(UserPostOwnerConnections)connections {
    OBShapedButton* tmp = [self viewWithTag:-1];
    if (tmp == Nil) {
        tmp = [[OBShapedButton alloc]init];
        tmp.frame =  CGRectMake(0, 0, 69, 25);
        tmp.center = CGPointMake(51, 25);
        tmp.tag = -1;
        [_relationContainer addSubview:tmp];
    }
   
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    
    switch (connections) {
        case UserPostOwnerConnectionsSamePerson:
            // my own post, do nothing
            break;
        case UserPostOwnerConnectionsNone:
        case UserPostOwnerConnectionsFollowed:
            [tmp setBackgroundImage:[UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"friend_relation_follow"] ofType:@"png"]] forState:UIControlStateNormal];
            
            break;
//            return @"+关注";
        case UserPostOwnerConnectionsFollowing:
            [tmp setBackgroundImage:[UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"friend_relation_following"] ofType:@"png"]] forState:UIControlStateNormal];
            break;
        case UserPostOwnerConnectionsFriends:
            [tmp setBackgroundImage:[UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"friend_relation_muture_follow"] ofType:@"png"]] forState:UIControlStateNormal];
            //                return @"取消关注";
            break;
//            return @"-取关";
        default:
            break;
    }
}

- (void)setUserScreenName:(NSString*)name {
    _userNameLabel.text = name;
    [_userNameLabel sizeToFit];
    
#define TAG_2_NAME_MARGIN   10
#define USER_NAME_TOP_MARGIN    8
    _userNameLabel.center = CGPointMake(_user_screen_photo.center.x + _user_screen_photo.frame.size.width / 2 + NAME_LEFT_MARGIN + _userNameLabel.frame.size.width / 2, PREFERRED_HEIGHT / 2);
}

- (void)setUserRoleTag:(NSString*)role_tag {
    _userRoleTagBtn.hidden = NO;
    UILabel* label = [_userRoleTagBtn viewWithTag:-19];
    if (label == nil) {
        label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:12.f];
        label.textColor = [UIColor whiteColor];
        label.tag = -19;
        [_userRoleTagBtn addSubview:label];
    }
    
#define ROLE_TAG_MARGIN 2
    
    label.text = role_tag;
    [label sizeToFit];
    label.center = CGPointMake(5 + label.frame.size.width / 2, ROLE_TAG_MARGIN + label.frame.size.height / 2);
    
    _userRoleTagBtn.frame = CGRectMake(0, 0, label.frame.size.width + 10 + ROLE_TAG_MARGIN, label.frame.size.height + 2 * ROLE_TAG_MARGIN);
    _userRoleTagBtn.center = CGPointMake(_user_screen_photo.center.x + _user_screen_photo.frame.size.width / 2 + NAME_LEFT_MARGIN + _userNameLabel.frame.size.width + TAG_2_NAME_MARGIN + _userRoleTagBtn.frame.size.width / 2, PREFERRED_HEIGHT / 2);
    
    if ([@"" isEqualToString:role_tag]) {
        _userRoleTagBtn.hidden = YES;
    }
}
@end
