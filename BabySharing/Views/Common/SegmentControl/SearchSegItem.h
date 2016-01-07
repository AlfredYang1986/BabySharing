//
//  SearchSegItem.h
//  BabySharing
//
//  Created by Alfred Yang on 8/12/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchSegItem : UIView

@property (strong, nonatomic, setter=changeItemTitle:) NSString* title;
@property (nonatomic, setter=changeStatus:) NSInteger status;
@property (nonatomic) BOOL isLayerHidden;
@property (nonatomic, setter=resetFontSize:) CGFloat font_size;
@property (nonatomic, weak, setter=resetFontColor:) UIColor* font_color;

+ (CGSize)preferredSize;
@end
