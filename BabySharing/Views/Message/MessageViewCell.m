//
//  MessageViewCell.m
//  BabySharing
//
//  Created by Alfred Yang on 3/07/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "MessageViewCell.h"
#import "INTUAnimationEngine.h"
#import "UIBadgeView.h"
#import "TmpFileStorageModel.h"

@interface MessageViewCell ()
//@property (strong, nonatomic) UIButton *deleteBtn;
//@property (strong, nonatomic) UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation MessageViewCell {
    BOOL isEditing;
    
    CGPoint point;
}

@synthesize imageView = _imageView;

@synthesize currentIndex = _currentIndex;
@synthesize number = _number;
@synthesize nickNameLabel = _nickNameLabel;
@synthesize messageLabel = _messageLabel;

+ (CGFloat)getPreferredHeight {
    return 66;
}

- (void)setUserImage:(NSString *)photo_name {
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

- (void)awakeFromNib {
    // Initialization code

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
@end
