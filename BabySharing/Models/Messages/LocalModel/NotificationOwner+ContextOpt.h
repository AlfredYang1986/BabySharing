//
//  NotificationOwner+ContextOpt.h
//  BabySharing
//
//  Created by Alfred Yang on 8/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NotificationOwner.h"
#import <CoreData/CoreData.h>
#import "Notifications.h"

@class Targets;

@interface NotificationOwner(ContextOpt)

#pragma mark -- notification functions
+ (NotificationOwner*)enumNotificationOwnerWithID:(NSString*)user_id inContext:(NSManagedObjectContext*)context;
+ (Notifications*)addNotification:(NSDictionary*)notification forUser:(NSString*)user_id inContext:(NSManagedObjectContext*)context;
+ (NSArray*)enumNotificationsForOwner:(NSString*)user_id inContext:(NSManagedObjectContext*)context;
+ (void)removeAllNotificationsForOwner:(NSString*)user_id inContext:(NSManagedObjectContext*)context;
+ (void)removeOneNotification:(Notifications*)notification ForOwner:(NSString*)user_id inContext:(NSManagedObjectContext*)context;

+ (NSInteger)unReadNotificationCountForOwner:(NSString*)user_id inContext:(NSManagedObjectContext*)context;
+ (void)markAllNotificationAsReadedForOwner:(NSString*)user_id inContext:(NSManagedObjectContext*)context;

#pragma mark -- p2p and user Group
+ (void)addMessageWith:(NSString*)owner_id message:(NSDictionary*)message inContext:(NSManagedObjectContext*)context;
+ (Targets*)addTargetWith:(NSString*)owner_id targetDic:(NSDictionary*)tar inContext:(NSManagedObjectContext*)context;
+ (NSArray*)enumAllTargetForOwner:(NSString*)owner_id inContext:(NSManagedObjectContext*)context;
+ (NSArray*)enumAllMessagesForTarget:(Targets*)target inContext:(NSManagedObjectContext*)context;

#pragma mark -- chat group
+ (Targets*)addChatGroupWithOwnerID:(NSString*)owner_id chatGroup:(NSDictionary*)tar inContext:(NSManagedObjectContext*)context;
+ (NSArray*)updateMultipleChatGroupWithOwnerID:(NSString*)owner_id chatGroups:(NSDictionary*)tar inContext:(NSManagedObjectContext*)context;
+ (NSInteger)chatGroupCountWithOwnerID:(NSString*)owner_id inContext:(NSManagedObjectContext*)context;
+ (NSArray*)enumAllTargetForOwner:(NSString*)owner_id andType:(NSInteger)type inContext:(NSManagedObjectContext*)context;
@end
