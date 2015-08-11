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

#define BADGE_HEIGHT    20

@interface MessageViewCell ()
//@property (strong, nonatomic) UIButton *deleteBtn;
//@property (strong, nonatomic) UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation MessageViewCell {
    BOOL isEditing;
    
    CGPoint point;
    UILabel* badgeView;
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
    badgeView = [[UILabel alloc]init];
    [self addSubview:badgeView];
    [self bringSubviewToFront:badgeView];
    badgeView.hidden = YES;
    badgeView.layer.cornerRadius = BADGE_HEIGHT / 2;
    badgeView.clipsToBounds = YES;
    badgeView.backgroundColor = [UIColor redColor];
    badgeView.textAlignment = NSTextAlignmentCenter;
    
    badgeView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(badgeViewTaped:)];
    [badgeView addGestureRecognizer:tap];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setBadgeValue:(NSString*)value {
    if (!value || [value isEqualToString:@""]) {
        badgeView.hidden = YES;
    } else {
        badgeView.hidden = NO;
        
        UIFont* font = [UIFont systemFontOfSize:12];
        CGSize size = [value sizeWithFont:font constrainedToSize:CGSizeMake(FLT_MAX, FLT_MAX)];
        
        badgeView.bounds = CGRectMake(0, 0, size.width + BADGE_HEIGHT, BADGE_HEIGHT);
        badgeView.text = value;
        
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat height = self.bounds.size.height;
        badgeView.center = CGPointMake(width - BADGE_HEIGHT * 1.5, height / 2);
    }
}

- (void)badgetViewTaped:(UITapGestureRecognizer*)gesture {
    
}
@end
