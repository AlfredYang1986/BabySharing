//
//  QueryContentChaters+CoreDataProperties.h
//  BabySharing
//
//  Created by monkeyheng on 16/3/18.
//  Copyright © 2016年 BM. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "QueryContentChaters.h"

NS_ASSUME_NONNULL_BEGIN

@interface QueryContentChaters (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *chaterImg;
@property (nullable, nonatomic, retain) QueryContent *chatersTo;

@end

NS_ASSUME_NONNULL_END
