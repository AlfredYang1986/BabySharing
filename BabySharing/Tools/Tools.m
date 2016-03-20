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
        if ([str characterAtIndex:i] >= 32 && [str characterAtIndex:i] <= 126) {
            count += 1;
        } else {
            count += 2;
        }
        if (count > byte) {
            break;
        } else {
            subStr = [str substringToIndex:i + 1];
        }
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
        unichar aa = [str characterAtIndex:i];
        if (aa >= 32 && aa <= 126) {
            count += 1;
        } else {
            count += 2;
        }
    }
    return count;
}

+ (UIImage *)imageWithView:(UIView *)view {
    // 绘制UIview成图片
//    CGRect rect = [view bounds];
//    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    [view.layer.presentationLayer renderInContext:context];
//    [view.layer renderInContext:context];
//    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return img;
    
    
    UIImage *image;
    CGSize blurredImageSize = [view frame].size;
    UIGraphicsBeginImageContextWithOptions(blurredImageSize, YES, .0f);
    [view drawViewHierarchyInRect: [view bounds] afterScreenUpdates: YES];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
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
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 定义矩形的rect
    CGRect rectangle = CGRectMake(0, 0, width, height);
    
    // 在当前路径下添加一个矩形路径
    CGContextAddRect(ctx, rectangle);
    
    // 设置试图的当前填充色
    CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
    
    // 绘制当前路径区域
    CGContextFillPath(ctx);
    
    CGRect rect = CGRectInset(CGRectMake(0, 0, width, width), 10, 10);
    [newImage drawInRect:rect];
    
    // 画边框大圆
    [[UIColor whiteColor] set];
    CGFloat bigRadius = 50; //大圆半径
    CGFloat centerX = width / 2;
    CGFloat centerY = width - 20;
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

+ (NSString *)stringFromDate:(NSDate *)date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    
    [dateFormatter setDateFormat:@"MM-dd"];
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
    
}

+ (NSString *)compareCurrentTime:(NSDate *)compareDate {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    
    
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    
    
    
    
//    秒数差
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60 * 60) {
//        一个小时内
        result = [NSString stringWithFormat:@"刚刚"];
    } else if((temp = timeInterval / (60 * 60)) < 24){
//        几个小时内
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    } else if((temp = timeInterval / (60 * 60) / 24) < 30){
//        几天内
        result = [NSString stringWithFormat:@"%ld天前",temp];
    } else if((temp = timeInterval / (60 * 60) / 24) / 30 < 12){
//        几月内
        result = [NSString stringWithFormat:@"%ld月前",temp];
    } else {
//         几年内
        temp = timeInterval / (60 * 60) / 24 / 30 / 12;
        result = [NSString stringWithFormat:@"%ld年前",temp];
    }
    NSLog(@"MonkeyHengLog: %@ === %@", [dateFormatter stringFromDate:compareDate], result);
    return result;
}

+ (NSString*)getDeviceUUID {
    return [[UIDevice currentDevice].identifierForVendor UUIDString];
}
@end
