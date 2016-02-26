//
//  SearchSegImgTextItem.h
//  BabySharing
//
//  Created by Alfred Yang on 1/8/16.
//  Copyright © 2016 BM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchSegImgTextItem : UIView
@property (nonatomic, setter=changeStatus:) NSInteger status;

@property (nonatomic, strong) UIImage* normal_img;
@property (nonatomic, strong) UIImage* selected_img;

@property (strong, nonatomic, setter=changeItemTitle:) NSString* title;
@property (nonatomic) BOOL isLayerHidden;
@property (nonatomic, setter=resetFontSize:) CGFloat font_size;
@property (nonatomic, weak, setter=resetFontColor:) UIColor* font_color;
@property (nonatomic, weak, setter=resetSelectFontColor:) UIColor* select_font_color;

+ (CGSize)preferredSize;
@end
