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

@end
