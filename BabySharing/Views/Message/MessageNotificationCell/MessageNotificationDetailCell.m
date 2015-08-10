//
//  MessageNotificationDetailCell.m
//  BabySharing
//
//  Created by Alfred Yang on 10/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "MessageNotificationDetailCell.h"
#import "TmpFileStorageModel.h"

@interface MessageNotificationDetailCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation MessageNotificationDetailCell

+ (CGFloat)preferedHeight {
    return 66;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSString*)getActtionTmplate:(NotificationActionType)type {
    
    NSString* reVal = @"not implemented";
    switch (type) {
        case NotificationActionTypeFollow:
            reVal = @"%@ is now following you";
            break;
        case NotificationActionTypeUnFollow:
        case NotificationActionTypeLike:
        case NotificationActionTypePush:
        case NotificationActionTypeMessage:
            break;
            
        default:
            break;
    }
    return reVal;
}

- (void)setUserImage:(NSString*)photo_name {
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    NSString * filePath = [resourceBundle pathForResource:[NSString stringWithFormat:@"User"] ofType:@"png"];
    
    UIImage* userImg = [TmpFileStorageModel enumImageWithName:photo_name withDownLoadFinishBolck:^(BOOL success, UIImage *user_img) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self) {
                    self.imgView.image = user_img;
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
    [self.imgView setImage:userImg];
}
@end
