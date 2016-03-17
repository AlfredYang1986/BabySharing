//
//  MessageChatGroupHeader3.m
//  BabySharing
//
//  Created by Alfred Yang on 3/11/16.
//  Copyright © 2016 BM. All rights reserved.
//

#import "MessageChatGroupHeader3.h"

#define LABEL_MARGIN_TOP    40 //64
#define LABEL_HEIGHT        32

#define PADDING_HER         10.5
#define PADDING_VER         9

#define MARGIN_HER          2 * PADDING_HER


@implementation MessageChatGroupHeader3 {
    NSArray* tag_views;
    UILabel* theme_label;
}

@synthesize theme_label_text = _theme_label_text;
@synthesize theme_tags = _theme_tags;

- (void)resizeLabel:(UILabel*)label {
    [label sizeToFit];
    CGSize sz = label.bounds.size;
    
//    label.bounds = CGRectMake(0, 0, sz.width + 2 * PADDING_HER, sz.height + 2 * PADDING_VER);
    label.bounds = CGRectMake(0, 0, sz.width + 2 * PADDING_HER, LABEL_HEIGHT);
    label.textAlignment = NSTextAlignmentCenter;
}

- (void)setThemeTags:(NSArray *)theme_tags {
    _theme_tags = theme_tags;
    
    for (UILabel* iter in tag_views) {
        [iter removeFromSuperview];
    }
    
    NSMutableArray* arr = [[NSMutableArray alloc]initWithCapacity:theme_tags.count];
    for (NSString* str in theme_tags) {
        UILabel* tmp = [[UILabel alloc]init];
        tmp.backgroundColor = [UIColor whiteColor];
        tmp.layer.cornerRadius = 4.f;
        tmp.clipsToBounds = YES;
        tmp.text = [@"#" stringByAppendingString:str];
//        [tmp sizeToFit];
        [self resizeLabel:tmp];
        [self addSubview:tmp];
        [arr addObject:tmp];
    }
    
    tag_views = [arr copy];
}

- (void)setThemeLabelText:(NSString *)theme_label_text {
    _theme_label_text = theme_label_text;
   
    if (theme_label == nil) {
        theme_label = [[UILabel alloc]init];
        theme_label.backgroundColor = [UIColor whiteColor];
        theme_label.layer.cornerRadius = 4.f;
        theme_label.clipsToBounds = YES;
        [self addSubview:theme_label];
    }
    
    theme_label.text = _theme_label_text;
//    [theme_label sizeToFit];
    [self resizeLabel:theme_label];
}

- (void)layoutSubviews {
    CGFloat offset_x = MARGIN_HER;
    CGFloat offset_y = LABEL_MARGIN_TOP;
    theme_label.frame = CGRectMake(offset_x, offset_y, theme_label.bounds.size.width, LABEL_HEIGHT);
    
    offset_y += LABEL_HEIGHT;
    
    for (UILabel* iter in tag_views) {
        if (offset_x + iter.bounds.size.width > [UIScreen mainScreen].bounds.size.width - 42) {
            offset_x = MARGIN_HER;
            offset_y += LABEL_HEIGHT;
        }

        iter.frame = CGRectMake(offset_x, offset_y, iter.bounds.size.width, LABEL_HEIGHT);
        offset_x += iter.bounds.size.width;
    }
}

- (CGFloat)preferredHeight {
    CGFloat w = 0;
    for (UILabel* iter in tag_views) {
        w += iter.bounds.size.width;
    }
    return LABEL_MARGIN_TOP + LABEL_HEIGHT + LABEL_HEIGHT * (w == 0 ? 0 : w / ([UIScreen mainScreen].bounds.size.width - 42) + 1);
}
@end
