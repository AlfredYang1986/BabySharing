//
//  SearchSegController.h
//  BabySharing
//
//  Created by Alfred Yang on 15/09/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchSegDelegate.h"

@interface SearchSegView : UIView

@property (nonatomic, getter=getSegItems, readonly) NSArray* items;
@property (nonatomic, getter=getSegItemsCount, readonly) NSInteger count;
@property (nonatomic, readonly) NSInteger selectedIndex;
@property (nonatomic, weak) id<SearchSegViewDelegate> delegate;

//- (void)addItemWithTitle:(NSString*)title andImg:(UIImage*)img;
- (void)addItemWithTitle:(NSString *)title andImg:(UIImage *)img andSelectedImg:(UIImage*)unimg;
- (void)removeItemAtIndex:(NSInteger)index;

+ (CGFloat)preferredHeight;
@end
