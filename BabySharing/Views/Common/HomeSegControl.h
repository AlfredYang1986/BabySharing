//
//  HomeSegControl.h
//  BabySharing
//
//  Created by Alfred Yang on 14/09/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeSegControl;

@protocol HomeSegControlDelegate
- (void)valueHasChanged:(HomeSegControl*)seg;
@end

@interface HomeSegControl : UIView

@property (nonatomic, readonly, getter=getSegItems) NSArray* items;
@property (nonatomic, readonly) NSInteger selectIndex;
@property (nonatomic, readonly, getter=getSegCount) NSInteger count;
@property (nonatomic, weak) id<HomeSegControlDelegate> delegate;

- (void)addItem:(NSString*)title andImage:(UIImage*)img;
- (void)removeItemAtIndex:(NSInteger)index;
@end
