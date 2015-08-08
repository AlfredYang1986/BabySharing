//
//  NotificationOwner.h
//  BabySharing
//
//  Created by Alfred Yang on 8/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NSManagedObject;

@interface NotificationOwner : NSManagedObject

@property (nonatomic, retain) NSString * user_id;
@property (nonatomic, retain) NSSet *notifications;
@property (nonatomic, retain) NSSet *chatWith;
@end

@interface NotificationOwner (CoreDataGeneratedAccessors)

- (void)addNotificationsObject:(NSManagedObject *)value;
- (void)removeNotificationsObject:(NSManagedObject *)value;
- (void)addNotifications:(NSSet *)values;
- (void)removeNotifications:(NSSet *)values;

- (void)addChatWithObject:(NSManagedObject *)value;
- (void)removeChatWithObject:(NSManagedObject *)value;
- (void)addChatWith:(NSSet *)values;
- (void)removeChatWith:(NSSet *)values;

@end
