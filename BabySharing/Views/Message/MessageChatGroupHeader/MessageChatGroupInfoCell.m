//
//  MessageChatGroupInfoCell.m
//  BabySharing
//
//  Created by Alfred Yang on 1/28/16.
//  Copyright © 2016 BM. All rights reserved.
//

#import "MessageChatGroupInfoCell.h"
#import "TmpFileStorageModel.h"

@interface MessageChatGroupInfoCell ()
@property (weak, nonatomic) IBOutlet UIView *user_list_view;
@property (weak, nonatomic) IBOutlet UILabel* online_count_label;

@end

@implementation MessageChatGroupInfoCell

@synthesize user_list_view = _user_list_view;
@synthesize online_count_label = _online_count_label;

- (void)awakeFromNib {
    // Initialization code
    _user_list_view.backgroundColor = [UIColor clearColor];
    
    _online_count_label.font = [UIFont systemFontOfSize:14.f];
    _online_count_label.textColor = [UIColor colorWithWhite:151.f / 255.f alpha:1.f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#define PREFERRED_HEIGHT            98.5

+ (CGFloat)preferredHeight {
    return PREFERRED_HEIGHT;
}

- (void)setChatGroupJoinerNumber:(NSNumber*)number {
    _online_count_label.text = [NSString stringWithFormat:@"%ld个人正在圈聊", (long)number.integerValue];
}

- (void)setChatGroupUserList:(NSArray*)user_lst {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        for (UIView* view in _user_list_view.subviews) {
            [view removeFromSuperview];
        }
       
#define PHOTO_WIDTH             40
#define PHOTO_HEIGHT            40
#define PHOTO_MARGIN            8
        
        CGFloat offset = 8;
        CGFloat offset_y = 38;
        for (int index = 0; index < MIN(user_lst.count, 6); ++index) {
            NSDictionary* user_dic = [user_lst objectAtIndex:index];
            UIButton* tmp = [[UIButton alloc]initWithFrame:CGRectMake(offset, offset_y / 2, PHOTO_WIDTH, PHOTO_HEIGHT)];
            tmp.layer.cornerRadius = PHOTO_HEIGHT / 2;
            tmp.layer.borderColor = [UIColor colorWithWhite:1.f alpha:0.25f].CGColor;
            tmp.layer.borderWidth = 1.5f;
            tmp.clipsToBounds = YES;
            
            NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
            NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
            NSString * filePath = [resourceBundle pathForResource:[NSString stringWithFormat:@"default_user"] ofType:@"png"];
            
            NSString* photo_name = [user_dic objectForKey:@"screen_photo"];
            UIImage* userImg = [TmpFileStorageModel enumImageWithName:photo_name withDownLoadFinishBolck:^(BOOL success, UIImage *user_img) {
                if (success) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (self) {
                            [tmp setBackgroundImage:user_img forState:UIControlStateNormal];
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
            [tmp setBackgroundImage:userImg forState:UIControlStateNormal];
            [_user_list_view addSubview:tmp];
            
            offset += PHOTO_WIDTH + PHOTO_MARGIN;
        }
    });
}

@end
