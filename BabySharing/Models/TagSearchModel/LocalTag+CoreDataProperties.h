//
//  LocalTag+CoreDataProperties.h
//  BabySharing
//
//  Created by monkeyheng on 16/2/27.
//  Copyright © 2016年 BM. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "LocalTag.h"

NS_ASSUME_NONNULL_BEGIN

@interface LocalTag (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *tag_userID;
@property (nullable, nonatomic, retain) NSNumber *tag_type;
@property (nullable, nonatomic, retain) NSString *tag_text;

@end

NS_ASSUME_NONNULL_END
