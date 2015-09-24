//
//  CVViewController+ImageOpt.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 26/05/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CVViewController.h"

@interface CVViewController (ImageOpt)

+ (UIImage*)CVViewController:(CVViewController*)controller clipImage:(UIImage*)img withRect:(CGRect)rect;
+ (UIImage*)CVViewController:(CVViewController *)controller rotateImage:(UIImage *)img oritation:(UIImageOrientation)ori;
@end
