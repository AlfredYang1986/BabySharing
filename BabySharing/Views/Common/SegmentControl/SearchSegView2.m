//
//  SearchSegView2.m
//  BabySharing
//
//  Created by Alfred Yang on 8/12/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import "SearchSegView2.h"
#import "SearchSegImgItem.h"
#import "SearchSegItem.h"
#import "SearchSegImgTextItem.h"
#import "SearchSegTextTextItem.h"
#import "Define.h"

@interface SearchSegView2()

@property (nonatomic, assign) Theme theme;

@end

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
@synthesize isLayerHidden = _isLayerHidden;

@synthesize font_size = _font_size;
@synthesize font_color = _font_color;
@synthesize select_font_color = _select_font_color;

- (id)init {
    self = [super init];
    if (self) {
        self.tag = -99;
        self.theme = Light;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.tag = -99;
        self.theme = Light;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame theme:(Theme)theme {
    self = [super initWithFrame:frame];
    if (self) {
        self.tag = -99;
        self.theme = theme;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.tag = -99;
        self.font_color = [UIColor grayColor];
        self.select_font_color = [UIColor colorWithRed:0.2745f green:0.8588 blue:0.7922 alpha:1.f];
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
    
    for (UIView* iter in [self getSegItems]) {
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

- (void)setItemLayerHidden:(BOOL)h {
    _isLayerHidden = h;
    for (SearchSegItem* iter in [self getSegItems]) {
        iter.isLayerHidden = h;
    }
}

- (void)resetFontSize:(CGFloat)font_size {
    _font_size = font_size;;
    for (SearchSegItem* iter in [self getSegItems]) {
        iter.font_size = _font_size;
    }
}

- (void)resetFontColor:(UIColor *)font_color {
    _font_color = font_color;
    for (SearchSegItem* iter in [self getSegItems]) {
        iter.font_color = _font_color;
    }
}

- (void)resetSelectFontColor:(UIColor *)select_font_color {
    _select_font_color = select_font_color;
    for (SearchSegItem* iter in [self getSegItems]) {
        iter.select_font_color = _select_font_color;
    }
}

- (NSString*)queryItemTitleAtIndex:(NSInteger)i {
    SearchSegItem* tmp = [self viewWithTag:i + 1];
    return tmp.title;
}

- (void)refreshItemTitle:(NSString*)title atIndex:(NSInteger)index {
    id item = [self viewWithTag:index + 1];
    if ([item isKindOfClass:[SearchSegTextTextItem class]]) {
        ((SearchSegTextTextItem*)item).title = title;
        
    } else if ([item isKindOfClass:[SearchSegImgTextItem class]] || [item isKindOfClass:[SearchSegItem class]]) {
    
    }
}

- (void)addItemWithTitle:(NSString *)title andSubTitle:(NSString*)subTitle {
    CGSize sz = [SearchSegTextTextItem preferredSize];
    SearchSegTextTextItem* item = [[SearchSegTextTextItem alloc]initWithFrame:CGRectMake(0, 0, sz.width, sz.height)];
    item.title = title;
    item.subTitle = subTitle;
    item.status = 0;
    item.tag = [self getSegItemsCount] + 1;
    item.isLayerHidden = _isLayerHidden;
    item.select_font_color = _select_font_color;
    item.font_color = _font_color;
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(segTextTextSelected:)];
    [item addGestureRecognizer:tap];
   
    [self addSubview:item];
}

- (void)addItemWithTitle:(NSString *)title {
    CGSize sz = [SearchSegItem preferredSize];
    SearchSegItem* item = [[SearchSegItem alloc] initWithFrame:CGRectMake(0, 0, sz.width, sz.height)];
    item.title = title;
    item.status = 0;
    item.tag = [self getSegItemsCount] + 1;
    item.isLayerHidden = _isLayerHidden;
    item.select_font_color = _select_font_color;
    item.font_color = _font_color;
//    item.font_color = TextColor;
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(segSelected:)];
    [item addGestureRecognizer:tap];
    
    [self addSubview:item];
}

- (void)addItemWithImg:(UIImage*)normal_img andSelectImage:(UIImage*)selected_img {
    CGSize sz = [SearchSegImgItem preferredSize];
    SearchSegImgItem* item = [[SearchSegImgItem alloc]initWithFrame:CGRectMake(0, 0, sz.width, sz.height)];

//    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
//    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
//    UIImage* img = [UIImage imageNamed:[resourceBundle pathForResource:@"found-tab-layer" ofType:@"png"]];
    
    item.tag = [self getSegItemsCount] + 1;
    item.normal_img = normal_img;
    item.selected_img = selected_img;
    item.status = 0;
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(segImgSelected:)];
    [item addGestureRecognizer:tap];
    
    [self addSubview:item];
}

- (void)addItemWithImg:(UIImage *)normal_img andSelectImage:(UIImage *)selected_img andTitle:(NSString *)title {
  
    CGSize sz = [SearchSegImgTextItem preferredSize];
    SearchSegImgTextItem* item = [[SearchSegImgTextItem alloc]initWithFrame:CGRectMake(0, 0, sz.width, sz.height)];
    
    item.tag = [self getSegItemsCount] + 1;
    item.normal_img = normal_img;
    item.selected_img = selected_img;
    item.title = title;
    item.isLayerHidden = _isLayerHidden;
    item.status = 0;
    item.select_font_color = _select_font_color;
    item.font_color = _font_color;
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(segImgTextSelected:)];
    [item addGestureRecognizer:tap];
    
    [self addSubview:item];
}

- (void)segSelected:(UITapGestureRecognizer*)gesture {
    SearchSegItem* tmp = (SearchSegItem*)gesture.view;
//    if (tmp.status != 1) {
        for (SearchSegItem* iter in [self getSegItems]) {
            iter.status = iter == tmp ? 1 : 0;
        }
        
        [_delegate segValueChanged2:self];
//    }
}

- (void)segImgSelected:(UITapGestureRecognizer*)gesture {
    UIView* tmp = gesture.view;
    
    for (SearchSegImgItem* iter in [self getSegItems]) {
        iter.status = iter == tmp ? 1 : 0;
    }
    
    [_delegate segValueChanged2:self];
}

- (void)segImgTextSelected:(UITapGestureRecognizer*)gesture {
    UIView* tmp = gesture.view;
    
    for (SearchSegImgTextItem* iter in [self getSegItems]) {
        iter.status = iter == tmp ? 1 : 0;
    }
    
    [_delegate segValueChanged2:self];
}

- (void)segTextTextSelected:(UITapGestureRecognizer*)gesture {
    UIView* tmp = gesture.view;
    
    for (SearchSegTextTextItem* iter in [self getSegItems]) {
        iter.status = iter == tmp ? 1 : 0;
    }
    
    [_delegate segValueChanged2:self];
}

- (void)removeItemAtIndex:(NSInteger)index {
    
}

+ (CGFloat)preferredHeight {
    return 44;
}

+ (CGFloat)preferredHeightWithImgAndText {
    return 70;
}

- (void)setTheme:(Theme)theme {
    _theme = theme;
    switch (_theme) {
        case Dark:
            self.font_color = Background;
            self.select_font_color = [UIColor colorWithRed:0.2745f green:0.8588 blue:0.7922 alpha:1.f];
            break;
        case Light:
            self.font_color = TextColor;
            self.select_font_color = [UIColor colorWithRed:0.2745f green:0.8588 blue:0.7922 alpha:1.f];
            break;
        default:
            break;
    }
}

@end
