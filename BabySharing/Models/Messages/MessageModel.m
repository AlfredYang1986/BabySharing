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

@implementation MessageModel

@synthesize delegate = _delegate;
@synthesize doc = _doc;

#pragma mark -- constractor
- (void)enumDataFromLocalDB:(UIManagedDocument*)document {
    dispatch_queue_t aq = dispatch_queue_create("load_message_queue", NULL);
    
    dispatch_async(aq, ^(void){
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [document.managedObjectContext performBlock:^(void){
                [[NSNotificationCenter defaultCenter] postNotificationName:@"message data ready" object:nil];
            }];
        });
    });
}

- (id)initWithDelegate:(AppDelegate*)app {
    self = [super init];
    /**
     * get authorised user array in the local database
     */
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
    [_doc.managedObjectContext save:nil];
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
@end
