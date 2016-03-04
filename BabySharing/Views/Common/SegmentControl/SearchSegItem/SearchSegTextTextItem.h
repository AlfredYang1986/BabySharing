//
//  SearchSegTextTextItem.h
//  BabySharing
//
//  Created by Alfred Yang on 3/4/16.
//  Copyright © 2016 BM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchSegTextTextItem : UIView

@property (strong, nonatomic, setter=changeItemTitle:) NSString* title;
@property (strong, nonatomic, setter=changeItemSubTitle:) NSString* subTitle;
@property (nonatomic, setter=changeStatus:) NSInteger status;
@property (nonatomic) BOOL isLayerHidden;
@property (nonatomic, setter=resetFontSize:) CGFloat font_size;
@property (nonatomic, weak, setter=resetFontColor:) UIColor* font_color;
@property (nonatomic, weak, setter=resetSelectFontColor:) UIColor* select_font_color;

+ (CGSize)preferredSize;
@end