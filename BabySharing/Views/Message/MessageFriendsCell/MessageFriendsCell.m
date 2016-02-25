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

@implementation MessageFriendsCell {
    CALayer* line;
}

@synthesize user_screen_photo = _user_screen_photo;
@synthesize relationContainer = _relationContainer;
@synthesize userRoleTagBtn = _userRoleTagBtn;
@synthesize userNameLabel = _userNameLabel;

@synthesize isHiddenLine = _isHiddenLine;
@synthesize lineMargin = _lineMargin;
@synthesize cellHeight = _cellHeight;

@synthesize delegate = _delegate;
@synthesize user_id = _user_id;
@synthesize connections = _connections;

+ (CGFloat)preferredHeight {
    return PREFERRED_HEIGHT;
}

- (void)setHiddenLine:(BOOL)isHiddenLine {
    _isHiddenLine = isHiddenLine;
    line.hidden = _isHiddenLine;
}

- (void)awakeFromNib {
    // Initialization code
    _user_screen_photo.layer.borderColor = [UIColor colorWithWhite:1.f alpha:0.25].CGColor;
    _user_screen_photo.layer.borderWidth = 1.5f;
    _user_screen_photo.layer.cornerRadius = IMG_WIDTH / 2;
    _user_screen_photo.clipsToBounds = YES;
   
    _user_screen_photo.userInteractionEnabled = YES;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didSelectedScreenPhoto)];
    [_user_screen_photo addGestureRecognizer:tap];
   
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
    
    line = [CALayer layer];
    line.borderWidth = 1.f;
    line.borderColor = [UIColor colorWithWhite:0.5922 alpha:0.25].CGColor;
    line.frame = CGRectMake(_lineMargin, PREFERRED_HEIGHT - 1, self.bounds.size.width - 2 * _lineMargin, 1);
    [self.layer addSublayer:line];
    
    _cellHeight = [MessageFriendsCell preferredHeight];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSublayersOfLayer:(CALayer *)layer {
    if (layer == line) {
        line.frame = CGRectMake(_lineMargin, _cellHeight - 1, self.bounds.size.width - 2 * _lineMargin, 1);
    }
}

- (void)setUserScreenPhoto:(NSString*)photo_name {
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    NSString * filePath = [resourceBundle pathForResource:[NSString stringWithFormat:@"default_user"] ofType:@"png"];
    
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
    _connections = connections;
    
    OBShapedButton* tmp = [self viewWithTag:-1];
    if (tmp == Nil) {
        tmp = [[OBShapedButton alloc]init];
        tmp.frame =  CGRectMake(0, 0, 69, 25);
        tmp.center = CGPointMake(51, 25);
        tmp.tag = -1;
        [tmp addTarget:self action:@selector(didSelectedRelationBtn) forControlEvents:UIControlEventTouchUpInside];
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
//    _userNameLabel.center = CGPointMake(_user_screen_photo.center.x + _user_screen_photo.frame.size.width / 2 + NAME_LEFT_MARGIN + _userNameLabel.frame.size.width / 2, PREFERRED_HEIGHT / 2);
    _userNameLabel.center = CGPointMake(_user_screen_photo.center.x + _user_screen_photo.frame.size.width / 2 + NAME_LEFT_MARGIN + _userNameLabel.frame.size.width / 2, _cellHeight / 2);
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
//    _userRoleTagBtn.center = CGPointMake(_user_screen_photo.center.x + _user_screen_photo.frame.size.width / 2 + NAME_LEFT_MARGIN + _userNameLabel.frame.size.width + TAG_2_NAME_MARGIN + _userRoleTagBtn.frame.size.width / 2, PREFERRED_HEIGHT / 2);
    _userRoleTagBtn.center = CGPointMake(_user_screen_photo.center.x + _user_screen_photo.frame.size.width / 2 + NAME_LEFT_MARGIN + _userNameLabel.frame.size.width + TAG_2_NAME_MARGIN + _userRoleTagBtn.frame.size.width / 2, _cellHeight / 2);
    
    if ([@"" isEqualToString:role_tag]) {
        _userRoleTagBtn.hidden = YES;
    }
}

- (void)setCellHeight:(CGFloat)cellHeight {
    _cellHeight = cellHeight;
    
    line.frame = CGRectMake(_lineMargin, _cellHeight - 1, self.bounds.size.width - 2 * _lineMargin, 1);
}

- (void)setLineMargin:(CGFloat)lineMargin {
    _lineMargin = lineMargin;
    
    line.frame = CGRectMake(_lineMargin, _cellHeight - 1, self.bounds.size.width -  2 * _lineMargin, 1);
}

#pragma mark -- action
- (void)didSelectedScreenPhoto {
    [_delegate didSelectedScreenPhoto:_user_id];
}

- (void)didSelectedRelationBtn {
    [_delegate didSelectedRelationBtn:_user_id andCurrentRelation:_connections];
}
@end
