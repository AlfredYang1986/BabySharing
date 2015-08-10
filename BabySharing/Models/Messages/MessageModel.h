//
//  MessageModel.h
//  ChatModel
//
//  Created by Alfred Yang on 3/05/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import "NotificationOwner+ContextOpt.h"

//@class Targets;
@class AppDelegate;
@class Notifications;
@class Targets;

typedef void(^receiveNotification)(void);

@interface MessageModel : NSObject

@property (nonatomic, weak, readonly) AppDelegate* delegate;
@property (strong, nonatomic, readonly) UIManagedDocument* doc;

#pragma mark -- constructor
- (id)initWithDelegate:(AppDelegate*)delegate;

#pragma mark -- save notifications
- (void)save;

#pragma mark -- notification functions
- (void)addNotification:(NSDictionary*)notification withFinishBlock:(receiveNotification)block;
- (NSArray*)enumNotifications;
- (void)removeAllNotifications;
- (void)removeOneNotification:(Notifications*)notification;

- (NSInteger)unReadNotificationCount;
- (void)markAllNotificationsAsReaded;

#pragma mark -- p2p chat message and group chat message
- (void)addMessageWith:(NSString*)target message:(NSDictionary*)message;
- (NSArray*)enumAllTargets;
- (NSArray*)enumAllMessagesWithTarget:(Targets*)target;
@end
