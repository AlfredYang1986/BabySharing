//
//  CVViewController+ImageOpt.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 26/05/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "CVViewController+ImageOpt.h"
#import "GPUImage.h"

@implementation CVViewController (ImageOpt)

+ (UIImage*)CVViewController:(CVViewController*)controller clipImage:(UIImage*)img withRect:(CGRect)rect {
    
    CGImageRef subImageRef = CGImageCreateWithImageInRect(img.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    
    return smallImage;
}

+ (UIImage*)CVViewController:(CVViewController *)controller rotateImage:(UIImage *)img oritation:(UIImageOrientation)ori {
    return [UIImage imageWithCGImage:img.CGImage scale:1.0 orientation:ori];
}
@end
