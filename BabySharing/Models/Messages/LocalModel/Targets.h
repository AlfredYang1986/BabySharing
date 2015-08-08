//
//  Targets.h
//  BabySharing
//
//  Created by Alfred Yang on 8/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NSManagedObject, NotificationOwner;

@interface Targets : NSManagedObject

@property (nonatomic, retain) NSString * target_id;
@property (nonatomic, retain) NSNumber * target_type;
@property (nonatomic, retain) NSDate * last_time;
@property (nonatomic, retain) NSSet *messages;
@property (nonatomic, retain) NotificationOwner *chatFrom;
@end

@interface Targets (CoreDataGeneratedAccessors)

- (void)addMessagesObject:(NSManagedObject *)value;
- (void)removeMessagesObject:(NSManagedObject *)value;
- (void)addMessages:(NSSet *)values;
- (void)removeMessages:(NSSet *)values;

@end
