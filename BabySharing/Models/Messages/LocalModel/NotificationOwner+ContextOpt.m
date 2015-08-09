//
//  NotificationOwner+ContextOpt.m
//  BabySharing
//
//  Created by Alfred Yang on 8/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "NotificationOwner+ContextOpt.h"
#import "EnumDefines.h"

@implementation NotificationOwner(ContextOpt)

#pragma mark -- notification functions
+ (NotificationOwner*)enumNotificationOwnerWithID:(NSString*)user_id inContext:(NSManagedObjectContext*)context {
    
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"NotificationOwner"];
    request.predicate = [NSPredicate predicateWithFormat:@"user_id = %@", user_id];
    
    NSError* error = nil;
    NSArray* matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || matches.count > 1) {
        NSLog(@"error with primary key");
        return nil;
    } else if (matches.count == 1) {
        return matches.firstObject;
    } else {
        NSLog(@"nothing need to be delected");
        NotificationOwner* tmp = [NSEntityDescription insertNewObjectForEntityForName:@"NotificationOwner" inManagedObjectContext:context];
        tmp.user_id = user_id;
        return tmp;
    }
}

+ (Notifications*)addNotification:(NSDictionary*)notification forUser:(NSString*)user_id inContext:(NSManagedObjectContext*)context {

    NotificationOwner* owner = [self enumNotificationOwnerWithID:user_id inContext:context];
   
    Notifications* tmp = [NSEntityDescription insertNewObjectForEntityForName:@"Notifications" inManagedObjectContext:context];
    
    tmp.date = [NSDate dateWithTimeIntervalSince1970:((NSNumber*)[notification objectForKey:@"date"]).longLongValue / 1000];
    tmp.type = (NSNumber*)[notification objectForKey:@"type"];
    tmp.sender_id = user_id;
    tmp.sender_screen_name = [notification objectForKey:@"sender_screen_name"];
    tmp.sender_screen_photo = [notification objectForKey:@"sender_screen_photo"];
    tmp.status = [NSNumber numberWithInt:MessagesStatusUnread];

    tmp.beNotified = owner;
    [owner addNotificationsObject:tmp];
   
    return tmp;
}

+ (NSArray*)enumNotificationsForOwner:(NSString*)user_id inContext:(NSManagedObjectContext*)context {
    
    NotificationOwner* owner = [self enumNotificationOwnerWithID:user_id inContext:context];
    return owner.notifications.allObjects;
}

+ (void)removeAllNotificationsForOwner:(NSString*)user_id inContext:(NSManagedObjectContext*)context {

    NotificationOwner* owner = [self enumNotificationOwnerWithID:user_id inContext:context];
    while (owner.notifications.count != 0) {
        Notifications* tmp = owner.notifications.anyObject;
        [owner removeNotificationsObject:tmp];
        [context deleteObject:tmp];
    }
}

+ (void)removeOneNotification:(Notifications*)notification ForOwner:(NSString*)user_id inContext:(NSManagedObjectContext*)context {
    
    NotificationOwner* owner = [self enumNotificationOwnerWithID:user_id inContext:context];
    [owner removeNotificationsObject:notification];
    [context deleteObject:notification];
}

+ (NSInteger)unReadNotificationCountForOwner:(NSString*)user_id inContext:(NSManagedObjectContext*)context {
    NotificationOwner* owner = [self enumNotificationOwnerWithID:user_id inContext:context];

    NSArray* notify_arr = owner.notifications.allObjects;
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"status=%d", [NSNumber numberWithInt:MessagesStatusUnread].integerValue];
   
    return [notify_arr filteredArrayUsingPredicate:pred].count;
}
@end
