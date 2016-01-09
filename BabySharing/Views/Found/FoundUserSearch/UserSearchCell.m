//
//  UserSearchCell.m
//  BabySharing
//
//  Created by Alfred Yang on 9/12/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import "UserSearchCell.h"
#import "TmpFileStorageModel.h"

#define MARGIN_HER  8
#define MARGIN_BOTTOM   15
#define MARGIN_TOP      4

#define CELL_HEADER_HEIGHT  72

#define PREVIEW_IMG_COUNT   3

@interface UserSearchCell ()
@property (weak, nonatomic) IBOutlet UIImageView *userImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *roleTagLabel;
@property (weak, nonatomic) IBOutlet UIView *maginView;

@end

@implementation UserSearchCell

@synthesize userImg = _userImg;
@synthesize nameLabel = _nameLabel;
@synthesize roleTagLabel = _roleTagLabel;
@synthesize maginView = _maginView;

- (void)awakeFromNib {
    // Initialization code
    _userImg.layer.cornerRadius = 25.f;
    _userImg.clipsToBounds = YES;
    
    for (int index = 0; index < PREVIEW_IMG_COUNT; ++index) {
        UIImageView* tmp = [[UIImageView alloc]init];
        tmp.tag = -1 - index;
        [self addSubview:tmp];
    }
    
    _maginView.backgroundColor = [UIColor colorWithWhite:0.9490 alpha:1.f];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat offset_y = _userImg.frame.origin.y + _userImg.frame.size.height + 8;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat step = (width - 2 * MARGIN_HER) / PREVIEW_IMG_COUNT;
    
    for (int index = 0; index < PREVIEW_IMG_COUNT; ++index) {
        UIView* iter = [self viewWithTag:-1 - index];
        iter.frame = CGRectMake(MARGIN_HER + index * step, offset_y, step, step);
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
                if (self) {
                    _userImg.image = user_img;
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
    [_userImg setImage:userImg];
}

- (void)setUserContentImages:(NSArray*)arr {
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    for (int index = 0; index < MIN(PREVIEW_IMG_COUNT, arr.count); ++index) {
        NSDictionary* iter = [arr objectAtIndex:index];
        NSArray* items = [iter objectForKey:@"items"];
        NSDictionary* item = items.firstObject;
        
        UIImageView* tmp = (UIImageView*)[self viewWithTag:-1 - index];
        
        NSString * filePath = [resourceBundle pathForResource:[NSString stringWithFormat:@"User"] ofType:@"png"];
        NSString* photo_name = [item objectForKey:@"name"];
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

- (void)setUserScreenName:(NSString*)name {
    _nameLabel.text = name;
    [_nameLabel sizeToFit];
}

- (void)setUserRoleTag:(NSString*)rolg_tag {
    _roleTagLabel.text = rolg_tag;
    [_roleTagLabel sizeToFit];
}

+ (CGFloat)preferredHeight {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat img_height = (width - 2 * MARGIN_HER) / PREVIEW_IMG_COUNT;
    return CELL_HEADER_HEIGHT + img_height + MARGIN_BOTTOM;
}
@end
