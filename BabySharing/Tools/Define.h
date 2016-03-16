//
//  Define.h
//  BabySharing
//
//  Created by monkeyheng on 16/3/4.
//  Copyright © 2016年 BM. All rights reserved.
//
// 去除警告
#define SuppressPerformSelectorLeakWarning(Stuff) \
    do { \
        _Pragma("clang diagnostic push") \
        _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
        Stuff; \
        _Pragma("clang diagnostic pop") \
    } while (0)

#define TextColor [UIColor colorWithRed:74.0 / 255.0 green:74.0 / 255.0 blue:74.0 / 255.0 alpha:1.0]
#define Blue [UIColor colorWithRed:70.0 / 255.0 green:219.0 / 255.0 blue:209.0 / 255.0 alpha:1.0]
#define FontColor1 [UIColor colorWithRed:155.0 / 255.0 green:155.0 / 255.0 blue:155.0 / 255.0 alpha:1.0]
#define Background [UIColor colorWithRed:242.0 / 255.0 green:242.0 / 255.0 blue:242.0 / 255.0 alpha:1.0]
#define LineColor  [UIColor colorWithRed:0.5922 green:0.5922 blue:0.5922 alpha:0.25]