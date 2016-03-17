//
//  DongDaTabBarItem.h
//  BabySharing
//
//  Created by Alfred Yang on 27/11/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DongDaTabBarItem : UIButton

@property (strong, nonatomic, setter=setNormalImg:) UIImage* img;
@property (strong, nonatomic) UIImage* select_img;

- (id)initWithMidImage:(UIImage*)image;
- (id)initWithImage:(UIImage*)image andSelectImage:(UIImage*)selectImg;
- (id)initWithImage:(UIImage*)image andSelectImage:(UIImage*)selectImg andTitle:(NSString*)title;
- (void)setSelected:(BOOL)selected;
@end
