//
//  Tools.m
//  BabySharing
//
//  Created by monkeyheng on 16/2/23.
//  Copyright © 2016年 BM. All rights reserved.
//

#import "Tools.h"

@implementation Tools

+ (NSString *)subStringWithByte:(NSInteger)byte str:(NSString *)str{
    NSString *subStr;
    int count = 0;
    for (int i = 0 ; i < [str length]; i++) {
        NSString *test = [str substringWithRange:NSMakeRange(i, 1)];
        NSUInteger testCount = [test lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
        count += testCount;
        if (count >= byte) {
            break;
        }
        subStr = [str substringToIndex:i + 1];
    }
    return subStr;
}

+ (NSInteger)bityWithStr:(NSString *)str {
    return [str lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
}

+ (UIImage *)imageWithView:(UIView *)view {
    // 绘制UIview成图片
    CGRect rect = [view bounds];
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+ (UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
}

@end
