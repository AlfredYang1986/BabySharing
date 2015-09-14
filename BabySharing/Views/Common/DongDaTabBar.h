//
//  DongDaTabBar.h
//  BabySharing
//
//  Created by Alfred Yang on 14/09/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DongDaTabBar : UIView

@property (nonatomic, readonly, getter=getTabBarItems) NSArray* items;
@property (nonatomic, readonly, getter=getTabBarItemCount) NSInteger count;
@property (nonatomic, getter=getCurrentSelectedIndex, setter=setCurrentSelectedIndex:) NSInteger selectIndex;
@property (nonatomic, weak) UITabBarController* bar;


- (id)initWithBar:(UITabBarController*)bar;
- (void)addItemWithImg:(UIImage*)image andSelectedImg:(UIImage*)selectedImg;
@end
