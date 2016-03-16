//
//  MessageModel.m
//  ChatModel
//
//  Created by Alfred Yang on 3/05/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "MessageModel.h"
#import "ModelDefines.h"
#import <CoreData/CoreData.h>
#import "RemoteInstance.h"
//#import "Messages+ContextOpt.h"
#import "AppDelegate.h"
#import "EnumDefines.h"
#import "NotificationOwner+ContextOpt.h"

#import "GotyeOCAPI.h"
#import "GotyeOCChatTarget.h"
#import "GotyeOCMessage.h"

#import "Targets.h"

@implementation MessageModel

@synthesize delegate = _delegate;
@synthesize doc = _doc;

#pragma mark -- constractor
- (void)enumDataFromLocalDB:(UIManagedDocument*)document {
    dispatch_queue_t aq = dispatch_queue_create("load_message_queue", NULL);
    
    dispatch_async(aq, ^(void){
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [document.managedObjectContext performBlock:^(void){
                [[NSNotificationCenter defaultCenter] postNotificationName:kDongDaNotificationkeyMessageIsReady object:nil];
            }];
        });
    });
}

- (id)initWithDelegate:(AppDelegate*)app {
    self = [super init];
    /**
     * get authorised user array in the local database
     */
    _delegate = app;
    NSString* docs=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSURL* url =[NSURL fileURLWithPath:[docs stringByAppendingPathComponent:LOCALDB_MESSAGEG_NOTIFICATION]];
    _doc = (UIManagedDocument*)[[UIManagedDocument alloc]initWithFileURL:url];
    
    if (![[NSFileManager defaultManager]fileExistsAtPath:[url path] isDirectory:NO]) {
        [_doc saveToURL:url forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success){
            [self enumDataFromLocalDB:_doc];
        }];
    } else if (_doc.documentState == UIDocumentStateClosed) {
        [_doc openWithCompletionHandler:^(BOOL success){
            [self enumDataFromLocalDB:_doc];
        }];
    } else {
        
    }
    return self;
}

#pragma mark -- save notifications
- (void)save {
    NSError* error = nil;
    [_doc.managedObjectContext save:&error];
    NSLog(@"%@", error);
}

#pragma mark -- notification functions
- (void)addNotification:(NSDictionary*)notification withFinishBlock:(receiveNotification)block {
    [NotificationOwner addNotification:notification forUser:_delegate.lm.current_user_id inContext:_doc.managedObjectContext];
    if (block) block();
}

- (NSArray*)enumNotifications {
    return [NotificationOwner enumNotificationsForOwner:_delegate.lm.current_user_id inContext:_doc.managedObjectContext];
}

- (void)removeAllNotifications {
    [NotificationOwner removeAllNotificationsForOwner:_delegate.lm.current_user_id inContext:_doc.managedObjectContext];
}

- (void)removeOneNotification:(Notifications*)notification {
    [NotificationOwner removeOneNotification:notification ForOwner:_delegate.lm.current_user_id inContext:_doc.managedObjectContext];
}

- (NSInteger)unReadNotificationCount {
    return [NotificationOwner unReadNotificationCountForOwner:_delegate.lm.current_user_id inContext:_doc.managedObjectContext];
}

- (NSInteger)allNotificationInDeviceCount {
    return [NotificationOwner allNotificationCountInDeviceForOwner:_delegate.lm.current_user_id inContext:_doc.managedObjectContext];
}

- (void)markAllNotificationsAsReaded {
    [NotificationOwner markAllNotificationAsReadedForOwner:_delegate.lm.current_user_id inContext:_doc.managedObjectContext];
}

#pragma mark -- p2p chat message and group chat message
- (void)addMessage:(NSDictionary*)message {
    [NotificationOwner addMessageWith:_delegate.lm.current_user_id message:message inContext:_doc.managedObjectContext];
}

- (NSArray*)enumAllTargets {
    return [NotificationOwner enumAllTargetForOwner:_delegate.lm.current_user_id inContext:_doc.managedObjectContext];
}

- (NSArray*)enumAllMessagesWithTarget:(Targets*)target {
    return [NotificationOwner enumAllMessagesForTarget:target inContext:_doc.managedObjectContext];
}

- (void)sendMessageToUser:(NSString*)target_id messageType:(MessageType)type messageContent:(NSString*)contents {
   
    GotyeOCChatTarget* ct = [GotyeOCUser userWithName:target_id];
    GotyeOCMessage* m = [GotyeOCMessage createTextMessage:ct text:contents];
    [GotyeOCAPI sendMessage:m];
}

- (Targets*)enumAllTargetWithTargetID:(NSString*)target_id {
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"target_id=%@", target_id];
    return [[NotificationOwner enumAllTargetForOwner:_delegate.lm.current_user_id inContext:_doc.managedObjectContext] filteredArrayUsingPredicate:pred].firstObject;
}

- (Targets*)addTarget:(NSDictionary*)tar {
    return [NotificationOwner addTargetWith:_delegate.lm.current_user_id targetDic:tar inContext:_doc.managedObjectContext];
}

#pragma mark -- p2p chat message and group chat message use GotyeOCAPI
- (NSInteger)getMesssageSessionCount {
//    return [GotyeOCAPI getSessionList].count;
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"name!=%@", @"alfred_test"];
    return [[GotyeOCAPI getSessionList] filteredArrayUsingPredicate:pred].count;
}

- (NSInteger)getMesssageSessionCountWithTargetType:(MessageReceiverType*)type {
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"type=%d", type];
    return [[GotyeOCAPI getSessionList] filteredArrayUsingPredicate:pred].count;
}

- (id)getTargetByIndex:(NSInteger)index {
    return [[GotyeOCAPI getSessionList] objectAtIndex:index];
}

- (id)getTargetByIndex:(NSInteger)index WithTargetType:(MessageReceiverType*)type {
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"type=%d", type];
    return [[[GotyeOCAPI getSessionList] filteredArrayUsingPredicate:pred] objectAtIndex:index];
}

- (NSString*)getLastestMessageWith:(GotyeOCChatTarget*)target {
    return [GotyeOCAPI getLastMessage:target].text;
}

- (NSString*)getLastestMessageDateWith:(GotyeOCChatTarget *)target {
    GotyeOCMessage* msg = [GotyeOCAPI getLastMessage:target];
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    NSTimeInterval now_time = [NSDate date].timeIntervalSince1970;
    if (now_time - msg.date > 24 * 60 * 60) {
        [formatter setDateFormat:@"MM-dd"];
    } else {
        [formatter setDateFormat:@"hh:mm"];
    }
    
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:msg.date];
    return [formatter stringFromDate:date];
}

- (NSInteger)getUnreadMessageCount:(GotyeOCChatTarget*)target {
    return [GotyeOCAPI getUnreadMessageCount:target];
}

- (NSArray*)getAllMessagesWithTarget:(NSString*)target_id andTargetType:(MessageReceiverType)type {
    GotyeOCChatTarget* t = nil;
    switch (type) {
        case MessageReceiverTypeUser:
            t = [GotyeOCUser userWithName:target_id];
                 break;
            
        default:
            break;
    }
    
    return [GotyeOCAPI getMessageList:t more:NO];
}

- (void)beginActiveForTarget:(NSString*)target_id {
    GotyeOCChatTarget* t = [GotyeOCUser userWithName:target_id];
    [GotyeOCAPI activeSession:t];
}

- (void)endActiveForTarget:(NSString*)target_id {
    GotyeOCChatTarget* t = [GotyeOCUser userWithName:target_id];
    [GotyeOCAPI deactiveSession:t];
}

- (NSInteger)getAllUnreadMessageCount {
    return [GotyeOCAPI getUnreadMessageCountOfTypes:@[@0]];
}

#pragma mark -- chat group
- (void)createChatGroupWithGroupThemeName:(NSString*)theme_name andPostID:(NSString*)post_id andOwnerID:(NSString*)owner_id andFinishBlock:(chatGroupOptFinishBlock)block {
    
    AppDelegate* delegate = (AppDelegate*)([UIApplication sharedApplication].delegate);
    NSString* auth_token = delegate.lm.current_auth_token;
    NSString* user_id = delegate.lm.current_user_id;
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:auth_token forKey:@"auth_token"];
    [dic setValue:user_id forKey:@"user_id"];
    [dic setValue:theme_name forKey:@"group_name"];
    [dic setValue:post_id forKey:@"post_id"];
    [dic setValue:owner_id forKey:@"owner_id"];
    
    NSError * error = nil;
    NSData* jsonData =[NSJSONSerialization dataWithJSONObject:[dic copy] options:NSJSONWritingPrettyPrinted error:&error];
    
    NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:CHAT_GROUP_CREATE]];
    
    if ([[result objectForKey:@"status"] isEqualToString:@"ok"]) {
  
        NSDictionary* reVal = [result objectForKey:@"result"];
        [self addChatGroupWithGroupAttr:reVal];
        GotyeOCRoom* room = [GotyeOCRoom roomWithId:((NSNumber*)[reVal objectForKey:@"group_id"]).longLongValue];
        [GotyeOCAPI enterRoom:room];
        block(YES, reVal);
    } else {
        block(NO, [result objectForKey:@"error"]);
    }
}

- (void)updateChatGroupWithGroup:(NSDictionary*)dic_group andFinishBlock:(chatGroupOptFinishBlock)block {
    AppDelegate* delegate = (AppDelegate*)([UIApplication sharedApplication].delegate);
    NSString* auth_token = delegate.lm.current_auth_token;
    NSString* user_id = delegate.lm.current_user_id;
    
    NSMutableDictionary* dic = [dic_group mutableCopy];
    [dic setValue:auth_token forKey:@"auth_token"];
    [dic setValue:user_id forKey:@"user_id"];
    
    NSError * error = nil;
    NSData* jsonData =[NSJSONSerialization dataWithJSONObject:[dic copy] options:NSJSONWritingPrettyPrinted error:&error];
    
    NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:CHAT_GROUP_UPDATE]];
    
    if ([[result objectForKey:@"status"] isEqualToString:@"ok"]) {
        
        NSDictionary* reVal = [result objectForKey:@"result"];
        [self addChatGroupWithGroupAttr:reVal];
        block(YES, reVal);
    } else {
        
        block(NO, [result objectForKey:@"error"]);
    }
}

- (void)addChatGroupWithGroupAttr:(NSDictionary*)attr {
    [NotificationOwner addChatGroupWithOwnerID:_delegate.lm.current_user_id chatGroup:attr inContext:_doc.managedObjectContext];
}

- (NSInteger)myChatGroupCount {
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"in_the_group=1 AND target_type=1"];
    return [NotificationOwner chatGroupCountWithOwnerID:_delegate.lm.current_user_id andPred:pred inContext:_doc.managedObjectContext];
}

- (NSArray*)enumMyChatGroupLocal {
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"in_the_group=1 AND target_type=1"];
    NSArray* result = [NotificationOwner enumTargetForOwner:_delegate.lm.current_user_id andPred:pred inContext:_doc.managedObjectContext];
   
    for (Targets* t in result) {
        GotyeOCGroup* group = [GotyeOCGroup groupWithId:t.group_id.longLongValue];
        GotyeOCMessage* m = [GotyeOCAPI getLastMessage:group];
        t.last_time = [NSDate dateWithTimeIntervalSince1970:m.date];
    }
    
    result = [result sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Targets* left = (Targets*)obj1;
        Targets* right = (Targets*)obj2;
        if (left.last_time.timeIntervalSince1970 < right.last_time.timeIntervalSince1970) return NSOrderedDescending;
        else if (left.last_time.timeIntervalSince1970 > right.last_time.timeIntervalSince1970) return NSOrderedAscending;
        else return NSOrderedSame;
    }];
    
    return result;
}

- (NSInteger)recommendChatGroupCount {
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"in_the_group=0 AND target_type=1"];
    return [NotificationOwner chatGroupCountWithOwnerID:_delegate.lm.current_user_id andPred:pred inContext:_doc.managedObjectContext];
}

- (NSArray*)enumRecommendChatGroupLocal {
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"in_the_group=0 AND target_type=1"];
    return [NotificationOwner enumTargetForOwner:_delegate.lm.current_user_id andPred:pred inContext:_doc.managedObjectContext];
}

- (void)enumChatGroupWithFinishBlock:(chatGroupOptFinishBlock)block {

    AppDelegate* delegate = (AppDelegate*)([UIApplication sharedApplication].delegate);
    NSString* auth_token = delegate.lm.current_auth_token;
    NSString* user_id = delegate.lm.current_user_id;
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:auth_token forKey:@"auth_token"];
    [dic setValue:user_id forKey:@"user_id"];
    
    NSError * error = nil;
    NSData* jsonData =[NSJSONSerialization dataWithJSONObject:[dic copy] options:NSJSONWritingPrettyPrinted error:&error];
    
    NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:CHAT_GROUP_QUERY]];
    
    if ([[result objectForKey:@"status"] isEqualToString:@"ok"]) {
  
        NSArray* reVal = [result objectForKey:@"result"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [NotificationOwner updateMultipleChatGroupWithOwnerID:_delegate.lm.current_user_id chatGroups:reVal inContext:_doc.managedObjectContext];
            block(YES, reVal);
        });
    } else {

        NSDictionary* error = [result objectForKey:@"error"];
        block(NO, error);
    }
}

- (void)joinChatGroup:(NSNumber*)group_id andFinishBlock:(chatGroupOptFinishBlock)block {
    
    NSString* auth_token = _delegate.lm.current_auth_token;
    NSString* user_id = _delegate.lm.current_user_id;
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:auth_token forKey:@"auth_token"];
    [dic setValue:user_id forKey:@"user_id"];
    [dic setValue:group_id forKey:@"group_id"];
        
    NSError * error = nil;
    NSData* jsonData =[NSJSONSerialization dataWithJSONObject:[dic copy] options:NSJSONWritingPrettyPrinted error:&error];
        
    NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:CHAT_GROUP_JOIN]];
        
    if ([[result objectForKey:@"status"] isEqualToString:@"ok"]) {
      
        dispatch_async(dispatch_get_main_queue(), ^{
            [NotificationOwner addChatGroupWithOwnerID:_delegate.lm.current_user_id chatGroup:[result objectForKey:@"result"] inContext:_doc.managedObjectContext];
            block(YES, nil);
        });
    } else {
        NSDictionary* reError = [result objectForKey:@"error"];
        NSString* msg = [reError objectForKey:@"message"];
            
        NSLog(@"query user profile failed");
        NSLog(@"%@", msg);
    }
}

- (void)leaveChatGroup:(NSNumber*)group_id andFinishBlock:(chatGroupOptFinishBlock)block {
    
    /**
     * TODO: leave chat group in gotye
     */
    
    NSString* auth_token = _delegate.lm.current_auth_token;
    NSString* user_id = _delegate.lm.current_user_id;
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:auth_token forKey:@"auth_token"];
    [dic setValue:user_id forKey:@"user_id"];
    [dic setValue:group_id forKey:@"group_id"];
    
    NSError * error = nil;
    NSData* jsonData =[NSJSONSerialization dataWithJSONObject:[dic copy] options:NSJSONWritingPrettyPrinted error:&error];
    
    NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:CHAT_GROUP_LEAVE]];
    
    if ([[result objectForKey:@"status"] isEqualToString:@"ok"]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [NotificationOwner leaveChatGroupWithOnwerID:_delegate.lm.current_user_id andGroupID:group_id inManagedObjectContext:_doc.managedObjectContext];
            block(YES, nil);
        });
    } else {
        NSDictionary* reError = [result objectForKey:@"error"];
        NSString* msg = [reError objectForKey:@"message"];
        
        NSLog(@"query user profile failed");
        NSLog(@"%@", msg);
    }
}
@end
