//
//  LocalTagManager.h
//  BabySharing
//
//  Created by monkeyheng on 16/2/28.
//  Copyright © 2016年 BM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalTagManager : NSObject

- (void)updateLocalTagWithType:(NSInteger)type text:(NSString *)text;
- (NSArray *)enumLocalTagWithType:(NSInteger)type;

@end
