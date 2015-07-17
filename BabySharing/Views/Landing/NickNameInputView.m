//
//  NickNameInputView.m
//  BabySharing
//
//  Created by Alfred Yang on 17/07/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "NickNameInputView.h"

@implementation NickNameInputView

#define IMG_WIDTH       30
#define IMG_HEIGHT      30

#define MARGIN          8

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)init {
    self = [super init];
    if (self) {
//        self.backgroundColor = [UIColor greenColor];
        [self setUpViews];
    }
    return self;
}

- (CGSize)getPreferredBounds {
    CGFloat width = [UIScreen mainScreen].bounds.size.width * 0.6;
    CGFloat height = (MARGIN + IMG_HEIGHT) * 4 + MARGIN;
    
    return CGSizeMake(width, height);
}

- (void)setUpViews {
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    UIImage* img_0 = [UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"User"] ofType:@"png"]];
    UIImage* img_1 = [UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"Tag"] ofType:@"png"]];
    UIImage* img_2 = [UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"Female"] ofType:@"png"]];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width * 0.6;
    [self addSubview:[self inputLineWithImage:img_0 andPlaceHolder:@"为你的咚哒起个名字" andInjectView:[[UITextField alloc]init] inRect:CGRectMake(0, 0, width, MARGIN + IMG_HEIGHT)]];
    [self addSubview:[self inputLineWithImage:img_1 andPlaceHolder:@"添加你的角色" andInjectView:[[UITextField alloc]init] inRect:CGRectMake(0, MARGIN + IMG_HEIGHT, width, MARGIN + IMG_HEIGHT)]];
    [self addSubview:[self inputLineWithImage:img_2 andPlaceHolder:@"只为妈咪" andInjectView:[[UILabel alloc]init] inRect:CGRectMake(0, 2 * (MARGIN + IMG_HEIGHT), width, MARGIN + IMG_HEIGHT)]];
    [self addSubview:[self inputLineWithImage:nil andPlaceHolder:@"爸比暂时靠边站" andInjectView:[[UILabel alloc]init] inRect:CGRectMake(0, 3 * (MARGIN + IMG_HEIGHT), width, MARGIN + IMG_HEIGHT)]];
}

- (UIView*)inputLineWithImage:(UIImage*)img andPlaceHolder:(NSString*)place_holder andInjectView:(UIView*)inject_view inRect:(CGRect)rc {
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width * 0.6;
    CGFloat height = MARGIN + IMG_HEIGHT;
    UIView* container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
   
    if (img) {
        UIImageView* img_view = [[UIImageView alloc]initWithImage:img];
        img_view.frame = CGRectMake(MARGIN, MARGIN, IMG_WIDTH - 2, IMG_HEIGHT - 2);
        [container addSubview:img_view];
    }
   
    inject_view.frame = CGRectMake(MARGIN + IMG_WIDTH + MARGIN, MARGIN, width - MARGIN - IMG_WIDTH - MARGIN, IMG_HEIGHT);
    if ([inject_view isKindOfClass:[UITextField class]]) {
        UITextField* tf = (UITextField*)inject_view;
        tf.font = [UIFont systemFontOfSize:15.f];
        tf.borderStyle = UITextBorderStyleNone;
        tf.placeholder = place_holder;
        
        CALayer* border_layer = [CALayer layer];
        border_layer.frame = CGRectMake(MARGIN + IMG_WIDTH + MARGIN, height - 1, width - MARGIN - IMG_WIDTH - MARGIN, 1);
        border_layer.borderWidth = 1.f;
        border_layer.backgroundColor = [UIColor blackColor].CGColor;
        [tf.layer addSublayer:border_layer];
    } else if ([inject_view isKindOfClass:[UILabel class]]) {
        UILabel* label = (UILabel*)inject_view;
        label.text = place_holder;
        [label sizeToFit];
    }
    
    [container addSubview:inject_view];
    container.frame = rc;
    
    return container;
}
@end
