//
//  DongDaTabBar.m
//  BabySharing
//
//  Created by Alfred Yang on 14/09/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "DongDaTabBar.h"

@implementation DongDaTabBar {
//    NSMutableArray* btns;
    CALayer* selected_layer;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@synthesize items = _items;
@synthesize count = _count;
@synthesize selectIndex = _selectIndex;

- (id)initWithBar:(UITabBarController*)bar {
    self = [super init];
    if (self) {
        self.tag = -99;
        _bar = bar;
        
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat height = 49;
        self.frame = CGRectMake(0, 0, width, height);
        self.backgroundColor = [UIColor whiteColor];
        
        NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
        NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
        
        selected_layer = [CALayer layer];
        selected_layer.contents = (id)[UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"Selected"] ofType:@"png"]].CGImage;
        selected_layer.frame = CGRectMake(0, 0, 15, 10);
        [self.layer addSublayer:selected_layer];
        

        [bar.tabBar addSubview:self];
        [bar.tabBar bringSubviewToFront:self];
    }
    return self;
}

- (void)addItemWithImg:(UIImage*)image andSelectedImg:(UIImage*)selectedImg {
    UIButton* btn = [[UIButton alloc]init];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:selectedImg forState:UIControlStateSelected];
    btn.tag = self.count;
    [btn addTarget:self action:@selector(itemSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    if (btn.tag == 0) {
        [btn setSelected:YES];
    }
    
    [self addSubview:btn];
}

- (void)layoutSubviews {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = 49;
    CGFloat step = width / self.count;
   
    for (int index = 0; index < self.count; ++index) {
        UIButton* tmp = (UIButton*)[self viewWithTag:index];
        tmp.frame = CGRectMake(index * step, 0, step, height);
        if ([tmp isSelected]) {
            selected_layer.position = CGPointMake(tmp.center.x, 5);
        }
    }
}

- (NSArray*)getTabBarItems {
    return self.subviews;
}

- (NSInteger)getTabBarItemCount {
    return self.subviews.count;
}

- (void)itemSelected:(UIButton*)sender {
    NSInteger index = sender.tag;
//    _bar.selectedIndex = index;
//    [_bar.tabBar setSelectedItem:[_bar.tabBar.items objectAtIndex:index]];
   
    NSInteger tmp = _bar.selectedIndex;
    _bar.selectedIndex = index;
    if (![_bar.delegate tabBarController:_bar shouldSelectViewController:nil]) {
        _bar.selectedIndex = tmp;
    } else {
        
        for (UIButton* iter in self.subviews) {
            [iter setSelected:NO];
        }
        UIButton* btn = (UIButton*)[self viewWithTag:index];
        [btn setSelected:YES];
        selected_layer.position = CGPointMake(btn.center.x, 5);
    }
    
    [_bar.tabBar.delegate tabBar:_bar.tabBar didSelectItem:[_bar.tabBar.items objectAtIndex:index]];
}
@end
