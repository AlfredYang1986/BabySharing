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

//得到字节数函数
+ (int)stringConvertToInt:(NSString*)strtemp
{
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++)
    {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return (strlength+1)/2;
}

+ (NSInteger)bityWithStr:(NSString *)str {
    NSInteger count = 0;
    for (NSInteger i = 0; i < str.length; i++) {
        if ([str characterAtIndex:i] >= 32 && [str characterAtIndex:i] <= 126) {
            count += 1;
        } else {
            count += 2;
        }
    }
    return count;
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

+ (NSArray *)sortWithArr:(NSArray *)arr headStr:(NSString *)headStr {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSMutableArray *letterArr = [NSMutableArray array];
    for (NSString *value in arr) {
        // 建立关系
        [letterArr addObject:[self ToPinYinWith:value dic:dic]];
    }
    // 对字母表进行排序
    NSArray *resultArray1 = [letterArr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSForcedOrderingSearch];
    }];
    // 判断字符串中是否含有首字母
    NSMutableArray *resultArray2 = [NSMutableArray array];
    for (NSString *str in resultArray1) {
        if (str.length >= headStr.length) {
            NSString *cut = [str substringToIndex:headStr.length];
            if ([cut isEqualToString:headStr]) {
                [resultArray2 addObject:str];
            }
        }
    }
    NSMutableArray *resultArray3 = [NSMutableArray array];
    for (NSString *key in resultArray2) {
        [resultArray3 addObject:[dic objectForKey:key]];
    }
    return resultArray3;
}

+ (NSString *)ToPinYinWith:(NSString *)hanziText dic:(NSMutableDictionary *)dic{
    if ([hanziText length]) {
        NSMutableString *ms = [[NSMutableString alloc] initWithString:hanziText];
        if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO)) {
            if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO)) {
                // 方便以后新排序
                [dic setObject:hanziText forKey:ms];
                return ms;
            } else {
                return nil;
            }
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}

+ (UIColor *)colorWithRED:(CGFloat)RED GREEN:(CGFloat)GREEN BLUE:(CGFloat)BLUE ALPHA:(CGFloat)ALPHA {
    return [UIColor colorWithRed:RED / 255.0 green:GREEN / 255.0 blue:BLUE / 255.0 alpha:ALPHA];
}

+ (UIImage *)addPortraitToImage:(UIImage *)image userHead:(UIImage *)userhead userName:(NSString *)userName{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 1.0);
    CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
    // Add a clip before drawing anything, in the shape of an rounded rect
    [[UIBezierPath bezierPathWithRoundedRect:frame
                                cornerRadius:5] addClip];
    // Draw your image
    [image drawInRect:frame];
    // Retrieve and return the new image
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //    374 482
    CGFloat width = 375;
    CGFloat height = 482;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), NO, 0.0);
    CGRect rect = CGRectInset(CGRectMake(0, 0, width, width), 10, 10);
    
    [newImage drawInRect:rect];
    
    // 画边框大圆
    [[UIColor whiteColor] set];
    CGFloat bigRadius = 50; //大圆半径
    CGFloat centerX = width / 2;
    CGFloat centerY = width - 20;
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddArc(ctx, centerX, centerY, bigRadius, 0, M_PI * 2, 0);
    CGContextFillPath(ctx);
    
    // 昵称
    CGContextSetLineWidth(ctx, 1.0);
    CGContextSetRGBFillColor(ctx, 74.0 / 255.0, 74.0 / 255.0, 74.0 / 255.0, 1.0);
    UIFont *font = [UIFont boldSystemFontOfSize:15];
    NSString *nickName = userName;
    CGSize size = [nickName sizeWithAttributes:@{ NSFontAttributeName :font }];
    [nickName drawInRect:CGRectMake(width / 2 - size.width / 2, rect.origin.y + rect.size.height + 50, size.width, size.height) withAttributes:@{ NSFontAttributeName :font }];
    
    // 画小圆
    CGFloat smallradius = 45;
    CGContextAddArc(ctx, centerX, centerY, smallradius, 0, M_PI * 2, 0);
    // 剪裁
    CGContextClip(ctx);
    // 画头像
    UIImage *userHead = userhead;
    [userHead drawInRect:CGRectMake(width / 2 - 50, width - 70, 100, 100)];
    
    
    // 画一个半透明的圆环
    return UIGraphicsGetImageFromCurrentImageContext();
}

@end