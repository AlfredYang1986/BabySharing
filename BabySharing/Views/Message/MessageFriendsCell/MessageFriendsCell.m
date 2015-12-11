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
    return 80;
}

- (void)awakeFromNib {
    // Initialization code
    _user_screen_photo.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _user_screen_photo.layer.borderWidth = 1.f;
    _user_screen_photo.layer.cornerRadius = 25.f;
    _user_screen_photo.clipsToBounds = YES;
   
    if (_userRoleTagBtn == nil) {
        _userRoleTagBtn = [[OBShapedButton alloc]init];
        NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
        NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
        [_userRoleTagBtn setBackgroundImage:[UIImage imageNamed:[resourceBundle pathForResource:@"home-tag" ofType:@"png"]] forState:UIControlStateNormal];
        [self addSubview:_userRoleTagBtn];
    }

    if (_userNameLabel == nil) {
        _userNameLabel = [[UILabel alloc]init];
        _userNameLabel.textColor = [UIColor lightGrayColor];
        _userNameLabel.font = [UIFont systemFontOfSize:14.f];
        [self addSubview:_userNameLabel];
    }
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
        tmp.frame =  CGRectMake(0, 0, 90, 25);
        tmp.center = CGPointMake(45, 25);
        [_relationContainer addSubview:tmp];
    }
   
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    
    switch (connections) {
        case UserPostOwnerConnectionsSamePerson:
            // my own post, do nothing
            break;
        case UserPostOwnerConnectionsNone:
        case UserPostOwnerConnectionsFollowed:
            [tmp setBackgroundImage:[UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"relations-unfollowed"] ofType:@"png"]] forState:UIControlStateNormal];
            
            break;
//            return @"+关注";
        case UserPostOwnerConnectionsFollowing:
            [tmp setBackgroundImage:[UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"relations-followed"] ofType:@"png"]] forState:UIControlStateNormal];
            break;
        case UserPostOwnerConnectionsFriends:
            [tmp setBackgroundImage:[UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"relations-friends"] ofType:@"png"]] forState:UIControlStateNormal];
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
    _userNameLabel.center = CGPointMake(_userRoleTagBtn.center.x + _userRoleTagBtn.frame.size.width / 2 + TAG_2_NAME_MARGIN + _userNameLabel.frame.size.width / 2, USER_NAME_TOP_MARGIN + _userNameLabel.frame.size.height / 2);
}

- (void)setUserRoleTag:(NSString*)role_tag {
    _userRoleTagBtn.hidden = NO;
    UILabel* label = [_userRoleTagBtn viewWithTag:-1];
    if (label == nil) {
        label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:14.f];
        label.textColor = [UIColor whiteColor];
        label.tag = -1;
        [_userRoleTagBtn addSubview:label];
    }
    
#define ROLE_TAG_MARGIN 2
    
    label.text = role_tag;
    [label sizeToFit];
    label.center = CGPointMake(10 + label.frame.size.width / 2, ROLE_TAG_MARGIN + label.frame.size.height / 2);
    
    _userRoleTagBtn.frame = CGRectMake(44, 8, label.frame.size.width + 10 + ROLE_TAG_MARGIN, label.frame.size.height + 2 * ROLE_TAG_MARGIN);
    
    if ([@"" isEqualToString:role_tag]) {
        _userRoleTagBtn.hidden = YES;
    }
}
@end
