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

#define USER_PHOTO_WIDTH    40
#define USER_PHOTO_HEIGHT   USER_PHOTO_WIDTH

@interface FoundMoreFriendCell ()
@property (weak, nonatomic) IBOutlet UIImageView *moreFriendIcon;
@property (weak, nonatomic) IBOutlet UIImageView *nextIcon;

@end

@implementation FoundMoreFriendCell

@synthesize moreFriendIcon = _moreFriendIcon;
@synthesize nextIcon = _nextIcon;

+ (CGFloat)preferredHeight {
    return 75;
}

- (void)awakeFromNib {
    // Initialization code
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    
    _moreFriendIcon.image = [UIImage imageNamed:[resourceBundle pathForResource:@"found-more-friend" ofType:@"png"]];
    _nextIcon.image = [UIImage imageNamed:[resourceBundle pathForResource:@"found-more-friend-arror" ofType:@"png"]];
    
    for (int index = -3; index < 0; ++index) {
        UIView* tmp = [self viewWithTag:index];
        if (tmp) {
            tmp.backgroundColor = [UIColor whiteColor];
            tmp.layer.borderColor = [UIColor grayColor].CGColor;
            tmp.layer.borderWidth = 1.f;
            tmp.layer.cornerRadius = USER_PHOTO_WIDTH / 2;
            tmp.clipsToBounds = YES;
            [self bringSubviewToFront:tmp];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
