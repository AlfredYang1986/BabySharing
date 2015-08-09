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

@interface NotificationOwner(ContextOpt)

#pragma mark -- notification functions
+ (NotificationOwner*)enumNotificationOwnerWithID:(NSString*)user_id inContext:(NSManagedObjectContext*)context;
+ (Notifications*)addNotification:(NSDictionary*)notification forUser:(NSString*)user_id inContext:(NSManagedObjectContext*)context;
+ (NSArray*)enumNotificationsForOwner:(NSString*)user_id inContext:(NSManagedObjectContext*)context;
+ (void)removeAllNotificationsForOwner:(NSString*)user_id inContext:(NSManagedObjectContext*)context;
+ (void)removeOneNotification:(Notifications*)notification ForOwner:(NSString*)user_id inContext:(NSManagedObjectContext*)context;

+ (NSInteger)unReadNotificationCountForOwner:(NSString*)user_id inContext:(NSManagedObjectContext*)context;
@end
