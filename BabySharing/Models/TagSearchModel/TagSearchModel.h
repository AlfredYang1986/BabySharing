//
//  TagSearchModel.h
//  BabySharing
//
//  Created by monkeyheng on 16/2/23.
//  Copyright © 2016年 BM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface TagSearchModel : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
@property (nullable, nonatomic, retain) NSString *user_id;
@property (nullable, nonatomic, retain) NSString *search_text;
// 1 品牌 2 时刻 3 地点
@property (nullable, nonatomic, retain) NSNumber *search_type;

@end

NS_ASSUME_NONNULL_END

