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
