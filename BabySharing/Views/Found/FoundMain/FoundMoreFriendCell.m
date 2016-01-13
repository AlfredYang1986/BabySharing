//
//  FountMoreFriendCell.m
//  BabySharing
//
//  Created by Alfred Yang on 7/12/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import "FoundMoreFriendCell.h"
#import "TmpFileStorageModel.h"
#import "RemoteInstance.h"

#define USER_PHOTO_WIDTH    30
#define USER_PHOTO_HEIGHT   USER_PHOTO_WIDTH

@interface FoundMoreFriendCell ()
@property (weak, nonatomic) IBOutlet UIImageView *moreFriendIcon;
@property (weak, nonatomic) IBOutlet UIImageView *nextIcon;

@end

@implementation FoundMoreFriendCell

@synthesize moreFriendIcon = _moreFriendIcon;
@synthesize nextIcon = _nextIcon;

@synthesize isHiddenIcon = _isHiddenIcon;
@synthesize isHiddenSep = _isHiddenSep;
@synthesize des = _des;

+ (CGFloat)preferredHeight {
    return 46;
}

- (void)awakeFromNib {
    // Initialization code
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    
    _moreFriendIcon.image = [UIImage imageNamed:[resourceBundle pathForResource:@"found_more_friend" ofType:@"png"]];
    _nextIcon.image = [UIImage imageNamed:[resourceBundle pathForResource:@"friend_more_friend_arrow" ofType:@"png"]];
    
    for (int index = -3; index < 0; ++index) {
        UIView* tmp = [self viewWithTag:index];
        if (tmp) {
            tmp.backgroundColor = [UIColor whiteColor];
//            tmp.layer.borderColor = [UIColor whiteColor].CGColor;
//            tmp.layer.borderWidth = 1.f;
            tmp.layer.cornerRadius = USER_PHOTO_WIDTH / 2;
            tmp.clipsToBounds = YES;
            [self bringSubviewToFront:tmp];
        }
    }
    
    UILabel* label = (UILabel*)[self viewWithTag:1];
    label.textColor = [UIColor colorWithWhite:0.5059 alpha:1.f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDes:(NSString *)des {
    _des = des;
    UILabel* label = (UILabel*)[self viewWithTag:1];
    label.text = _des;
    [label sizeToFit];
    [self setNeedsLayout];
}

- (void)setHiddenIcon:(BOOL)isHiddenIcon {
    _isHiddenIcon = isHiddenIcon;
    [self setNeedsLayout];

    UIView* img = [self viewWithTag:2];
    img.hidden = YES;
    
    UILabel* label = (UILabel*)[self viewWithTag:1];
    label.center = CGPointMake(10.5 + label.frame.size.width / 2, label.center.y);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_isHiddenIcon) {
        UIView* img = [self viewWithTag:2];
        img.hidden = YES;
    
        UILabel* label = (UILabel*)[self viewWithTag:1];
        label.center = CGPointMake(10.5 + label.frame.size.width / 2, label.center.y);
    }
}

#define RECOMMEND_USER_COUNT    3
- (void)setUserImages:(NSArray*)recommend_users {
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    for (int index = 0; index < MIN(RECOMMEND_USER_COUNT, recommend_users.count); ++index) {
        NSDictionary* iter = [recommend_users objectAtIndex:index];

        UIImageView* tmp = (UIImageView*)[self viewWithTag:-1 - index];

        NSString * filePath = [resourceBundle pathForResource:[NSString stringWithFormat:@"User"] ofType:@"png"];
        NSString* photo_name = [iter objectForKey:@"screen_photo"];
        UIImage* userImg = [TmpFileStorageModel enumImageWithName:photo_name withDownLoadFinishBolck:^(BOOL success, UIImage *user_img) {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self) {
                        tmp.image = user_img;
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
        [tmp setImage:userImg];
    }
}

@end
