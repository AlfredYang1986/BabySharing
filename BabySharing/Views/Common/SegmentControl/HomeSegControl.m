//
//  HomeSegControl.m
//  BabySharing
//
//  Created by Alfred Yang on 14/09/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "HomeSegControl.h"

@implementation HomeSegControl {
//    NSMutableArray* btns;
    
    CALayer* layer;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@synthesize items = _items;
@synthesize selectIndex = _selectIndex;
@synthesize count = _count;
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.tag = -99;
        layer = [CALayer layer];
        layer.borderColor = [UIColor colorWithRed:0.f green:0.4118 blue:0.3569 alpha:1.f].CGColor;
        layer.borderWidth = 1.f;
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        self.tag = -99;
        layer = [CALayer layer];
        layer.borderColor = [UIColor colorWithRed:0.f green:0.4118 blue:0.3569 alpha:1.f].CGColor;
        layer.borderWidth = 1.f;
    }
    return self;   
}

- (void)addItem:(NSString*)title andImage:(UIImage*)img {
    UIButton* btn = [[UIButton alloc]init];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:img forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(itemSelected:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = self.count;
    
    [btn setTitleColor:[UIColor colorWithRed:0.f green:0.4118 blue:0.3569 alpha:1.f] forState:UIControlStateNormal];
//    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
//    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
//    NSString * filePath = [resourceBundle pathForResource:[NSString stringWithFormat:@"Select-BKG"] ofType:@"png"];
//    [btn setBackgroundImage:[UIImage imageNamed:filePath] forState:UIControlStateSelected];
    if (btn.tag == 0) {
        [btn setSelected:YES];
    }
    
    [self addSubview:btn];
}

- (void)addLayerToButton:(UIButton*)current {
    [layer removeFromSuperlayer];
   
    UIFont* font = [UIFont systemFontOfSize:14.f];
    CGSize s = [@"我靠" sizeWithFont:font constrainedToSize:CGSizeMake(FLT_MAX, FLT_MAX)];
    layer.frame = CGRectMake(0, 0, s.width + 10, 2);
    layer.position = CGPointMake(current.frame.size.width / 2, current.frame.size.height - 1);
    [current.layer addSublayer:layer];
}

- (void)removeItemAtIndex:(NSInteger)index {
    UIView* tmp =  [self viewWithTag:index];
    [tmp removeFromSuperview];
}

- (void)layoutSubviews {
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    CGFloat step = width / self.count;
  
    for (int index = 0; index < self.count; ++index) {
        UIView* tmp = [self.subviews objectAtIndex:index];
        tmp.frame = CGRectMake(index * step, 0, step, height);
        if (index == 0) {
            [self addLayerToButton:(UIButton*)tmp];
        }
    }
}

- (NSArray*)getSegItems {
    return [self.subviews copy];
}

- (NSInteger)getSegCount {
    return self.subviews.count;
}

- (void)itemSelected:(UIButton*)sender {
    _selectIndex = sender.tag;
    
    for (UIButton* iter in self.subviews) {
        [iter setSelected:NO];
    }
    
    UIButton* tmp = (UIButton*)[self viewWithTag:_selectIndex];
    [tmp setSelected:YES];
    [self addLayerToButton:tmp];
    
    [_delegate valueHasChanged:self];
}
@end
