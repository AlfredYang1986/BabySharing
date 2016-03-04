//
//  SearchSegView2.h
//  BabySharing
//
//  Created by Alfred Yang on 8/12/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchSegDelegate.h"

typedef enum : NSUInteger {
    SearchSegLineTypeImg,
    SearchSegLineTypeText,
} SearchSegLineType;

@interface SearchSegView2 : UIView

@property (nonatomic, getter=getSegItems, readonly) NSArray* items;
@property (nonatomic, getter=getSegItemsCount, readonly) NSInteger count;
@property (nonatomic, getter=getSegSelectedIndex, setter=setSegSelectedIndex:) NSInteger selectedIndex;
@property (nonatomic, weak) id<SearchSegViewDelegate> delegate;
@property (nonatomic, setter=setItemLayerHidden:) BOOL isLayerHidden;
@property (nonatomic, setter=resetFontSize:) CGFloat font_size;
@property (nonatomic, strong, setter=resetFontColor:) UIColor* font_color;
@property (nonatomic, strong, setter=resetSelectFontColor:) UIColor* select_font_color;

// view location property
@property (nonatomic) CGFloat margin_to_edge;
@property (nonatomic) CGFloat margin_between_items;

- (NSString*)queryItemTitleAtIndex:(NSInteger)index;

- (void)refreshItemTitle:(NSString*)title atIndex:(NSInteger)index;

// title
- (void)addItemWithTitle:(NSString *)title andSubTitle:(NSString*)subTitle;
- (void)addItemWithTitle:(NSString *)title;
- (void)removeItemAtIndex:(NSInteger)index;

// img
- (void)addItemWithImg:(UIImage*)normal_img andSelectImage:(UIImage*)selected_img;

// title and img
- (void)addItemWithImg:(UIImage *)normal_img andSelectImage:(UIImage *)selected_img andTitle:(NSString*)title;

+ (CGFloat)preferredHeight;
+ (CGFloat)preferredHeightWithImgAndText;
@end
