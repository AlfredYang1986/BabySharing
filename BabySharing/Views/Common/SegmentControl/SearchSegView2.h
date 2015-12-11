//
//  SearchSegView2.h
//  BabySharing
//
//  Created by Alfred Yang on 8/12/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchSegDelegate.h"

@interface SearchSegView2 : UIView

@property (nonatomic, getter=getSegItems, readonly) NSArray* items;
@property (nonatomic, getter=getSegItemsCount, readonly) NSInteger count;
@property (nonatomic, getter=getSegSelectedIndex, setter=setSegSelectedIndex:) NSInteger selectedIndex;
@property (nonatomic, weak) id<SearchSegViewDelegate> delegate;
@property (nonatomic, setter=setItemLayerHidden:) BOOL isLayerHidden;

// view location property
@property (nonatomic) CGFloat margin_to_edge;
@property (nonatomic) CGFloat margin_between_items;

- (void)addItemWithTitle:(NSString *)title;
- (void)removeItemAtIndex:(NSInteger)index;

- (void)addItemWithImg:(UIImage*)normal_img andSelectImage:(UIImage*)selected_img;

+ (CGFloat)preferredHeight;
@end
