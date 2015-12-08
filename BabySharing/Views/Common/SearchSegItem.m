//
//  SearchSegItem.m
//  BabySharing
//
//  Created by Alfred Yang on 8/12/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import "SearchSegItem.h"

#define DEFAULT_MARGIN_HER          30
#define ITEM_WIDTH                  71
#define ITEM_HEIGHT                 44
#define ITME_LAYER_LINE_HEIGHT      4

@implementation SearchSegItem {
//    UILabel* label;
    CALayer* layer;
}

@synthesize title = _title;
@synthesize status = _status;

- (id)init {
    self = [super init];
    if (self) {
        [self setUpValues];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpValues];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUpValues];
    }
    return self;
}

- (void)changeItemTitle:(NSString *)title {
    _title = title;
    
    UILabel* label = [self viewWithTag:-1];
    label.text = _title;
    [label sizeToFit];
    label.center = CGPointMake(ITEM_WIDTH / 2, ITEM_HEIGHT / 2);
    
    [self setNeedsDisplay];
}

- (void)setUpValues {
    UILabel* label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:16.f];
    label.tag = -1;
    [self addSubview:label];
    
    layer = [CALayer layer];
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    UIImage* img = [UIImage imageNamed:[resourceBundle pathForResource:@"found-tab-layer" ofType:@"png"]];
   
    layer.contents = (id)img.CGImage;
    layer.frame = CGRectMake(0, self.frame.size.height - ITME_LAYER_LINE_HEIGHT, ITEM_WIDTH, ITME_LAYER_LINE_HEIGHT);
    [self.layer addSublayer:layer];
    
    layer.hidden = _status == 0;
    label.textColor = _status == 0 ? [UIColor grayColor] : [UIColor colorWithRed:0.f green:0.4118 blue:0.3569 alpha:1.f];
}

- (void)changeStatus:(NSInteger)s {
    _status = s;
    layer.hidden = _status == 0;
    UILabel* label = [self viewWithTag:-1];
    label.textColor = _status == 0 ? [UIColor grayColor] : [UIColor colorWithRed:0.f green:0.4118 blue:0.3569 alpha:1.f];
}

+ (CGSize)preferredSize {
    return CGSizeMake(ITEM_WIDTH, ITEM_HEIGHT);
}
@end
