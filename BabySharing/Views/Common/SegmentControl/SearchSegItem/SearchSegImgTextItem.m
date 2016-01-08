//
//  SearchSegImgTextItem.m
//  BabySharing
//
//  Created by Alfred Yang on 1/8/16.
//  Copyright © 2016 BM. All rights reserved.
//

#import "SearchSegImgTextItem.h"
#define DEFAULT_MARGIN_HER          30
#define ITEM_WIDTH                  71
#define ITEM_HEIGHT                 70
#define ITME_LAYER_LINE_HEIGHT      4

@implementation SearchSegImgTextItem {
    CALayer* layer;
}

@synthesize status = _status;

@synthesize normal_img = _normal_img;
@synthesize selected_img = _selected_img;

@synthesize title = _title;
@synthesize isLayerHidden = _isLayerHidden;
@synthesize font_size = _font_size;
@synthesize font_color = _font_color;



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

- (void)setUpValues {
    UIImageView* v = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    v.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2 - 10);
    v.tag = -2;
    [self addSubview:v];
    self.status = 0;
    
    if (_font_size == 0) {
        _font_size = 16.f;
    }
    
    _font_color = [UIColor grayColor];
    
    UILabel* label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:_font_size];
    label.tag = -1;
    [self addSubview:label];
    
    layer = [CALayer layer];
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    UIImage* img = [UIImage imageNamed:[resourceBundle pathForResource:@"dongda_seg_selected" ofType:@"png"]];
    
    layer.contents = (id)img.CGImage;
    layer.frame = CGRectMake(0, self.frame.size.height - ITME_LAYER_LINE_HEIGHT, ITEM_WIDTH, ITME_LAYER_LINE_HEIGHT);
    [self.layer addSublayer:layer];
    
    layer.hidden = _status == 0;
    label.textColor = _status == 0 ? _font_color : [UIColor colorWithRed:0.2745f green:0.8588 blue:0.7922 alpha:1.f];
    
    if (_isLayerHidden) {
        layer.hidden = YES;
    }
}

- (void)changeStatus:(NSInteger)status {
    _status = status;
    layer.hidden = _status == 0;
    UILabel* label = [self viewWithTag:-1];
    label.textColor = _status == 0 ? _font_color : [UIColor colorWithRed:0.2745f green:0.8588 blue:0.7922 alpha:1.f];
    
    if (_isLayerHidden) {
        layer.hidden = YES;
    }
    
    UIImageView* v = [self viewWithTag:-2];
    if (_status == 0) {
        v.image = _normal_img;
    } else {
        v.image = _selected_img;
    }
}

- (void)changeItemTitle:(NSString *)title {
    _title = title;
    
    UILabel* label = [self viewWithTag:-1];
    label.text = _title;
    [label sizeToFit];
    label.center = CGPointMake(ITEM_WIDTH / 2,  18 + ITEM_HEIGHT / 2);
    
    [self setNeedsDisplay];
}

- (void)resetFontSize:(CGFloat)font_size {
    _font_size = font_size;
    UILabel* label = [self viewWithTag:-1];
    label.font = [UIFont systemFontOfSize:_font_size];
}

- (void)resetFontColor:(UIColor *)font_color {
    _font_color = font_color;
    if (_status == 0) {
        UILabel* label = [self viewWithTag:-1];
        label.textColor = _font_color;
    }
}

+ (CGSize)preferredSize {
    return CGSizeMake(ITEM_WIDTH, ITEM_HEIGHT);
}
@end
