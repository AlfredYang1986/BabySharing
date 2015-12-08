//
//  SearchSegView2.m
//  BabySharing
//
//  Created by Alfred Yang on 8/12/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import "SearchSegView2.h"

#import "SearchSegItem.h"

@implementation SearchSegView2

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

@synthesize margin_to_edge = _margin_to_edge;
@synthesize margin_between_items = _margin_between_items;

- (id)init {
    self = [super init];
    if (self) {
        self.tag = -99;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.tag = -99;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.tag = -99;
    }
    return self;
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
    CGSize sz = [SearchSegItem preferredSize];
    CGFloat step = sz.width;
    
    CGFloat content_width = [self getSegItemsCount] * step + ([self getSegItemsCount] - 1) * _margin_between_items;
    _margin_to_edge = (width - content_width) / 2;
    
    for (SearchSegItem* iter in [self getSegItems]) {
        NSInteger index = iter.tag - 1;
        iter.frame = CGRectMake(_margin_to_edge + step * index + _margin_between_items * index, 0, step, height);
    }
}

- (NSInteger)getSegSelectedIndex {
    for (SearchSegItem* iter in [self getSegItems]) {
        if (iter.status == 1)
            return iter.tag - 1;
    }
    return -1;
}

- (void)setSegSelectedIndex:(NSInteger)i {
    SearchSegItem* tmp = [self viewWithTag:i + 1];
    
    for (SearchSegItem* iter in [self getSegItems]) {
        iter.status = iter == tmp ? 1 : 0;
    }
}

- (void)addItemWithTitle:(NSString *)title {
    CGSize sz = [SearchSegItem preferredSize];
    SearchSegItem* item = [[SearchSegItem alloc]initWithFrame:CGRectMake(0, 0, sz.width, sz.height)];
    item.title = title;
    item.status = 0;
    item.tag = [self getSegItemsCount] + 1;
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(segSelected:)];
    [item addGestureRecognizer:tap];
    
    [self addSubview:item];
}

- (void)segSelected:(UITapGestureRecognizer*)gesture {
    UIView* tmp = gesture.view;
    
    for (SearchSegItem* iter in [self getSegItems]) {
        iter.status = iter == tmp ? 1 : 0;
    }
    
    [_delegate segValueChanged2:self];
}

- (void)removeItemAtIndex:(NSInteger)index {
    
}

+ (CGFloat)preferredHeight {
    return 44;
}
@end
