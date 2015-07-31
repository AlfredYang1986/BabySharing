//
//  CommentsHeader.m
//  BabySharing
//
//  Created by Alfred Yang on 31/07/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "CommentsHeader.h"

#define MARGIN  8

#define BTN_WIDTH   100
#define BTN_HEIGHT  32

@implementation CommentsHeader

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (CGFloat)preferdHeight {
    return 44;
}

- (void)setUpSubviews {
    
    UIView* btn = [[UIView alloc]initWithFrame:CGRectMake(0, 0, BTN_WIDTH, BTN_HEIGHT)];
    
    UILabel* tmp_label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, BTN_HEIGHT)];
    tmp_label.text = @"评论";
    tmp_label.textAlignment = NSTextAlignmentCenter;
    [btn addSubview:tmp_label];
    
    CALayer* al = [CALayer layer];
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    UIImage* image = [UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"Dropdown"] ofType:@"png"]];
   
    al.frame = CGRectMake(70, 0, 30, BTN_HEIGHT);
    al.contents = (id)image.CGImage;
    [btn.layer addSublayer:al];
  
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    btn.center = CGPointMake(width / 2, [CommentsHeader preferdHeight] / 2);
    [self addSubview:btn];
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpSubviews];
    }
    return self;
}

@end
