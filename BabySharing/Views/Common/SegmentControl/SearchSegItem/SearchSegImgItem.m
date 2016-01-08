//
//  SearchSegImgItem.m
//  BabySharing
//
//  Created by Alfred Yang on 11/12/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import "SearchSegImgItem.h"

#define DEFAULT_MARGIN_HER          30
#define ITEM_WIDTH                  71
#define ITEM_HEIGHT                 44
#define ITME_LAYER_LINE_HEIGHT      4

@implementation SearchSegImgItem

@synthesize status = _status;
@synthesize selected_img = _selected_img;
@synthesize normal_img = _normal_img;

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
//    UILabel* label = [[UILabel alloc]init];
//    label.font = [UIFont systemFontOfSize:16.f];
//    label.tag = -1;
//    [self addSubview:label];
   
    UIImageView* v = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    v.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    v.tag = -1;
    [self addSubview:v];
    self.status = 0;
}

- (void)changeStatus:(NSInteger)s {
    _status = s;
    UIImageView* v = [self viewWithTag:-1];
//    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
//    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
//    UIImage* img = [UIImage imageNamed:[resourceBundle pathForResource:@"found-tab-layer" ofType:@"png"]];
    
    if (_status == 0) {
        v.image = _normal_img;
    } else {
        v.image = _selected_img;
    }
}

+ (CGSize)preferredSize {
    return CGSizeMake(ITEM_WIDTH, ITEM_HEIGHT);
}
@end
