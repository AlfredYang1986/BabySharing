//
//  Targets+CoreDataProperties.h
//  BabySharing
//
//  Created by Alfred Yang on 3/10/16.
//  Copyright © 2016 BM. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Targets.h"

NS_ASSUME_NONNULL_BEGIN

@interface Targets (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *group_id;
@property (nullable, nonatomic, retain) NSNumber *in_the_group;
@property (nullable, nonatomic, retain) NSDate *last_time;
@property (nullable, nonatomic, retain) NSNumber *number_count;
@property (nullable, nonatomic, retain) NSString *owner_id;
@property (nullable, nonatomic, retain) NSString *target_id;
@property (nullable, nonatomic, retain) NSString *target_name;
@property (nullable, nonatomic, retain) NSString *target_photo;
@property (nullable, nonatomic, retain) NSNumber *target_type;
@property (nullable, nonatomic, retain) NSString *post_id;
@property (nullable, nonatomic, retain) NSString *post_thumb;
@property (nullable, nonatomic, retain) NotificationOwner *chatFrom;
@property (nullable, nonatomic, retain) NSSet<Messages *> *messages;

@end

@interface Targets (CoreDataGeneratedAccessors)

- (void)addMessagesObject:(Messages *)value;
- (void)removeMessagesObject:(Messages *)value;
- (void)addMessages:(NSSet<Messages *> *)values;
- (void)removeMessages:(NSSet<Messages *> *)values;

@end

NS_ASSUME_NONNULL_END
