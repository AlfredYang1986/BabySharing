//
//  DongDaTabBarItem.m
//  BabySharing
//
//  Created by Alfred Yang on 27/11/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import "DongDaTabBarItem.h"

#define LAYER_ICON_NORMAL_WIDTH  25
#define LAYER_ICON_NORMAL_HEIGHT LAYER_ICON_NORMAL_WIDTH

#define LAYER_ICON_MID_WIDHT    49
#define LAYER_ICON_MID_HEIGHT   LAYER_ICON_MID_WIDHT

@implementation DongDaTabBarItem {
    UIImage* img;
    UIImage* select_img;
    
    CALayer* img_layer;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithMidImage:(UIImage*)image {
    self = [super init];
    if (self) {
        img = image;
        select_img = nil;
        
        img_layer = [CALayer layer];
        img_layer.contents = (id)image.CGImage;
        img_layer.frame = CGRectMake(0, 0, LAYER_ICON_MID_WIDHT, LAYER_ICON_MID_HEIGHT);
        [self.layer addSublayer:img_layer];
    }
    return self;
}


- (id)initWithImage:(UIImage*)image andSelectImage:(UIImage*)selectImg {
    self = [super init];
    if (self) {
        img = image;
        select_img = selectImg;
        
        img_layer = [CALayer layer];
        img_layer.contents = (id)image.CGImage;
        img_layer.frame = CGRectMake(0, 0, LAYER_ICON_NORMAL_WIDTH, LAYER_ICON_NORMAL_HEIGHT);
        [self.layer addSublayer:img_layer];
    }
    return self;
}

- (void)layoutSublayersOfLayer:(CALayer *)layer {
    if (layer == self.layer) {
        img_layer.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height/ 2);
    }
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if (!select_img) return;

    if (self.isSelected) img_layer.contents = (id)select_img.CGImage;
    else img_layer.contents = (id)img.CGImage;
}
@end
