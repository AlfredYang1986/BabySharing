//
//  DongDaTabBarItem.h
//  BabySharing
//
//  Created by Alfred Yang on 27/11/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DongDaTabBarItem : UIButton

- (id)initWithMidImage:(UIImage*)image;
- (id)initWithImage:(UIImage*)image andSelectImage:(UIImage*)selectImg;
- (void)setSelected:(BOOL)selected;
@end
