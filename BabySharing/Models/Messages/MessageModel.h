//
//  MessageModel.h
//  ChatModel
//
//  Created by Alfred Yang on 3/05/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EnumDefines.h"
//#import "NotificationOwner+ContextOpt.h"

//@class Targets;
@class AppDelegate;
@class Notifications;
@class Targets;
@class GotyeOCChatTarget;

typedef void(^receiveNotification)(void);
typedef void(^chatGroupOptFinishBlock)(BOOL success, id result);

@interface MessageModel : NSObject

@property (nonatomic, weak, readonly) AppDelegate *delegate;
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
- (void)addMessage:(NSDictionary*)message;
- (Targets*)addTarget:(NSDictionary*)tar;
- (NSArray*)enumAllTargets;
- (Targets*)enumAllTargetWithTargetID:(NSString*)target_id;
- (NSArray*)enumAllMessagesWithTarget:(Targets*)target;
- (void)sendMessageToUser:(NSString*)target_id messageType:(MessageType)type messageContent:(NSString*)contents;

#pragma mark -- p2p chat message and group chat message use GotyeOCAPI
- (NSInteger)getMesssageSessionCount;
- (NSInteger)getMesssageSessionCountWithTargetType:(MessageReceiverType*)type;
- (id)getTargetByIndex:(NSInteger)index;
- (id)getTargetByIndex:(NSInteger)index WithTargetType:(MessageReceiverType*)type;

- (NSString*)getLastestMessageWith:(GotyeOCChatTarget*)target;
- (NSString*)getLastestMessageDateWith:(GotyeOCChatTarget *)target;
- (NSInteger)getUnreadMessageCount:(GotyeOCChatTarget*)target;
- (NSInteger)getAllUnreadMessageCount;

- (NSArray*)getAllMessagesWithTarget:(NSString*)target_id andTargetType:(MessageReceiverType)type;
- (void)beginActiveForTarget:(NSString*)target_id;
- (void)endActiveForTarget:(NSString*)target_id;

#pragma mark -- chat group
- (void)createChatGroupWithGroupThemeName:(NSString*)theme_name andPostID:(NSString*)post_id andOwnerID:(NSString*)owner_id andFinishBlock:(chatGroupOptFinishBlock)block;
//- (void)createChatGroupWithGroupThemeName:(NSString*)theme_name andFinishBlock:(chatGroupOptFinishBlock)block;
- (void)updateChatGroupWithGroup:(NSDictionary*)dic andFinishBlock:(chatGroupOptFinishBlock)block;
- (void)addChatGroupWithGroupAttr:(NSDictionary*)attr;
- (NSInteger)myChatGroupCount;
- (NSInteger)recommendChatGroupCount;
- (NSArray*)enumMyChatGroupLocal;
- (NSArray*)enumRecommendChatGroupLocal;
- (void)enumChatGroupWithFinishBlock:(chatGroupOptFinishBlock)block;
- (void)joinChatGroup:(NSNumber*)group_id andFinishBlock:(chatGroupOptFinishBlock)block;
- (void)leaveChatGroup:(NSNumber*)group_id andFinishBlock:(chatGroupOptFinishBlock)block;
@end
