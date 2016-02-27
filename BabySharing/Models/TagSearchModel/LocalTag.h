//
//  LocalTag.h
//  BabySharing
//
//  Created by monkeyheng on 16/2/27.
//  Copyright © 2016年 BM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^LocalTagblock)(NSArray *match);

@interface LocalTag : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
+ (void)updateLocalTagWithType:(NSInteger)type text:(NSString *)text;
+ (void)enumLocalTagWithType:(NSInteger)type match:(LocalTagblock)match;


@end

NS_ASSUME_NONNULL_END

#import "LocalTag+CoreDataProperties.h"
