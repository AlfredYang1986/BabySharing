//
//  Tools.h
//  BabySharing
//
//  Created by monkeyheng on 16/2/23.
//  Copyright © 2016年 BM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Tools : NSObject

+ (UIImage *)imageWithView:(UIView *)view;
+ (NSString *)subStringWithByte:(NSInteger)byte str:(NSString *)str;
+ (NSInteger)bityWithStr:(NSString *)str;
+ (UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size;
+ (NSArray *)sortWithArr:(NSArray *)arr headStr:(NSString *)headStr;
+ (UIColor *)colorWithRED:(CGFloat)RED GREEN:(CGFloat)GREEN BLUE:(CGFloat)BLUE ALPHA:(CGFloat)ALPHA;
+ (UIImage *)addPortraitToImage:(UIImage *)image;

@end
