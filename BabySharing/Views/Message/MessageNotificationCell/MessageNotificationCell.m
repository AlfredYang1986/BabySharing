//
//  MessageNotificationCell.m
//  BabySharing
//
//  Created by Alfred Yang on 10/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "MessageNotificationCell.h"

#define BADGE_HEIGHT    20

@interface MessageNotificationCell ()
    
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end


@implementation MessageNotificationCell {
    UILabel* badgeView;
}

@synthesize imageView = _imageView;

- (void)awakeFromNib {
    // Initialization code
    
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    _imgView.image = [UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"Comments_blue"] ofType:@"png"]];
    
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

- (void)badgeViewTaped:(UITapGestureRecognizer*)gesture {
    [self setBadgeValue:@""];
}
@end
