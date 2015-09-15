//
//  SearchSegController.m
//  BabySharing
//
//  Created by Alfred Yang on 15/09/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "SearchSegView.h"

@implementation SearchSegView {
    UIColor* selected_red;
    UIColor* unselected_green;
    UIColor* selected_line;
    UIColor* unselected_line;
    
    NSMutableArray* unselected_img;
    NSMutableArray* selected_img;
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
@synthesize selectedIndex = _selectedIndex;
@synthesize delegate = _delegate;

- (id)init {
    self = [super init];
    if (self) {
        self.tag = -99;
        [self setUpValues];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.tag = -99;
        [self setUpValues];
    }
    return self;
}

- (void)setUpValues {
    selected_red = [UIColor colorWithRed:0.9294 green:0.1882 blue:0.1412 alpha:1.f];
    unselected_green = [UIColor colorWithRed:0.f green:0.4118 blue:0.3569 alpha:1.f];
    selected_line = [UIColor colorWithRed:0.9294 green:0.1882 blue:0.1412 alpha:1.f];
    unselected_line = [UIColor colorWithRed:0.1373 green:0.1216 blue:0.1255 alpha:0.3];
    
    selected_img = [[NSMutableArray alloc]init];
    unselected_img = [[NSMutableArray alloc]init];
}

- (NSArray*)getSegItems {
    return self.subviews;
}

- (NSInteger)getSegItemsCount {
    return self.subviews.count;
}

- (void)layoutSubviews {
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    
    CGFloat step = width / self.count;
    
    for (int index = 0; index < self.count; ++index) {
        UIView* iter = [self viewWithTag:index];
        iter.frame = CGRectMake(index * step, 0, step, height);
//        iter.layer.borderWidth = 1.f;
//        iter.layer.borderColor = [UIColor blueColor].CGColor;
        
        UILabel* l = (UILabel*)[iter viewWithTag:-1];
        l.frame = CGRectMake(0, 0, step, 30);
        
        UIImageView* iv = (UIImageView*)[iter viewWithTag:-2];
        iv.frame = CGRectMake(0, 30, step, 70);
        
        UIView* line = [iter viewWithTag:-3];
        line.frame = CGRectMake(0, iter.frame.size.height - 1, step, 1);
    }
    
}

- (void)addItemWithTitle:(NSString *)title andImg:(UIImage *)unimg andSelectedImg:(UIImage*)img {
    UIView* tmp = [[UIView alloc]init];
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    label.text = title;
    label.tag = -1;
    label.textColor = unselected_green;
    label.textAlignment = NSTextAlignmentCenter;
    [tmp addSubview:label];

    UIImageView* im = [[UIImageView alloc]init];
    im.image = unimg;
    im.tag = -2;
    im.contentMode = UIViewContentModeCenter;
    [tmp addSubview:im];
    
    [selected_img addObject:img];
    [unselected_img addObject:unimg];
    
    UIView* line = [[UIView alloc]init];
    line.layer.borderColor = unselected_line.CGColor;
    line.layer.borderWidth = 1.f;
    line.tag = -3;
    [tmp addSubview:line];

    if (self.count == 0) {
        label.textColor = selected_red;
        im.image = img;
        line.layer.borderColor = selected_red.CGColor;
    }
    
    tmp.tag = self.count;
    [self addSubview:tmp];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(segSelected:)];
    [tmp addGestureRecognizer:tap];
}

- (void)segSelected:(UITapGestureRecognizer*)gesture {
    UIView* tmp = gesture.view;
    
    for (int index = 0; index < self.count; ++index) {
        UIView* iter = [self viewWithTag:index];
        
        if (iter == tmp) {
            UILabel* l = (UILabel*)[iter viewWithTag:-1];
            l.textColor = selected_red;
            
            UIImageView* im = (UIImageView*)[iter viewWithTag:-2];
            im.image = [selected_img objectAtIndex:index];

            UIView* line = [iter viewWithTag:-3];
            line.layer.borderColor = selected_line.CGColor;
            
            _selectedIndex = index;
            
        } else {
            UILabel* l = (UILabel*)[iter viewWithTag:-1];
            l.textColor = unselected_green;

            UIImageView* im = (UIImageView*)[iter viewWithTag:-2];
            im.image = [unselected_img objectAtIndex:index];
           
            UIView* line = [iter viewWithTag:-3];
            line.layer.borderColor = unselected_line.CGColor;
        }
    }
    
    [_delegate segValueChanged:self];
}

- (void)removeItemAtIndex:(NSInteger)index {
    UIView* tmp = [self viewWithTag:index];
    [tmp removeFromSuperview];
}

+ (CGFloat)preferredHeight {
    return 100;
}
@end
