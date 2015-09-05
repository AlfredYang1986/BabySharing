//
//  SystemSettingModel.m
//  BabySharing
//
//  Created by Alfred Yang on 5/09/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "SystemSettingModel.h"
#import "ModelDefines.h"
//#import "RemoteInstance.h"
#import "AppDelegate.h"
#import "UserSetting+ContextOpt.h"
#import "MessageSetting.h"

@implementation SystemSettingModel
//@synthesize querydata = _querydata;
@synthesize delegate = _delegate;
@synthesize doc = _doc;

#pragma mark -- instuction
- (void)enumDataFromLocalDB:(UIManagedDocument*)document {
//    dispatch_queue_t aq = dispatch_queue_create("load_relationship_data", NULL);
//
//    dispatch_async(aq, ^(void){
//        dispatch_async(dispatch_get_main_queue(), ^(void){
//            [document.managedObjectContext performBlock:^(void){
//                _querydata =  [QueryContent enumLocalQueyDataInContext:document.managedObjectContext];
//                if (_querydata == nil || _querydata.count == 0) {
//                    [self refreshQueryDataByUser:self.delegate.lm.current_user_id withToken:self.delegate.lm.current_auth_token];
//                }
//                [[NSNotificationCenter defaultCenter]postNotificationName:@"query data ready" object:nil];
//            }];
//        });
//    });
}

- (id)initWithDelegate:(AppDelegate*)app {
    self = [super init];
    if (self) {
        
        _delegate = app;
        /**
         * get previous data from local database
         */
        NSString* docs=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSURL* url =[NSURL fileURLWithPath:[docs stringByAppendingPathComponent:LOCALDB_USERSETTING]];
        _doc = (UIManagedDocument*)[[UIManagedDocument alloc]initWithFileURL:url];
        
        if (![[NSFileManager defaultManager]fileExistsAtPath:[url path] isDirectory:nil]) {
            [_doc saveToURL:url forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
                NSLog(@"create query database callback");
                [self enumDataFromLocalDB:_doc];
            }];
        } else if (_doc.documentState == UIDocumentStateClosed) {
            [_doc openWithCompletionHandler:^(BOOL success) {
                NSLog(@"open query database callback");
                [self enumDataFromLocalDB:_doc];
            }];
        } else {
            
        }
    }
    
    return self;
}

#pragma mark -- current version
- (NSString*)getCurrentVersion {
    return @"0.0.1";
}

#pragma mark -- query message Setting
- (void)resetMessageSettingValue:(BOOL)isOn andAttrName:(NSString*)name {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setObject:[NSNumber numberWithBool:isOn] forKey:name];
    [UserSetting refreshMessageSettingWithUserID:_delegate.lm.current_user_id andSetting:[dic copy] inContext:_doc.managedObjectContext];
}

- (BOOL)isModeSilenceOn {
    MessageSetting* ms = [UserSetting queryMessageSettingWithUserID:_delegate.lm.current_user_id inContext:_doc.managedObjectContext];
    return ms.mode_silence.boolValue;
}

- (void)resetModeSilence:(BOOL)isOn {
    [self resetMessageSettingValue:isOn andAttrName:@"mode_silence"];
}

- (BOOL)isModeVoiceOn {
    MessageSetting* ms = [UserSetting queryMessageSettingWithUserID:_delegate.lm.current_user_id inContext:_doc.managedObjectContext];
    return ms.mode_voice.boolValue;
}

- (void)resetModeVoice:(BOOL)isOn {
    [self resetMessageSettingValue:isOn andAttrName:@"mode_voice"];
}

- (BOOL)isModeViberOn {
    MessageSetting* ms = [UserSetting queryMessageSettingWithUserID:_delegate.lm.current_user_id inContext:_doc.managedObjectContext];
    return ms.mode_viber.boolValue;
}

- (void)resetModeViber:(BOOL)isOn {
    [self resetMessageSettingValue:isOn andAttrName:@"mode_viber"];
}

- (BOOL)isNotifyCycleOn {
    MessageSetting* ms = [UserSetting queryMessageSettingWithUserID:_delegate.lm.current_user_id inContext:_doc.managedObjectContext];
    return ms.notify_cycle.boolValue;
}

- (void)resetNotifyCycle:(BOOL)isOn {
    [self resetMessageSettingValue:isOn andAttrName:@"notify_cycle"];
}

- (BOOL)isNotifyP2POn {
    MessageSetting* ms = [UserSetting queryMessageSettingWithUserID:_delegate.lm.current_user_id inContext:_doc.managedObjectContext];
    return ms.notify_p2p.boolValue;
}

- (void)resetNotifyP2P:(BOOL)isOn {
    [self resetMessageSettingValue:isOn andAttrName:@"notify_p2p"];
}

- (BOOL)isNotifyNotificationOn {
    MessageSetting* ms = [UserSetting queryMessageSettingWithUserID:_delegate.lm.current_user_id inContext:_doc.managedObjectContext];
    return ms.notify_notification.boolValue;
}

- (void)resetNotifyNotification:(BOOL)isOn {
    [self resetMessageSettingValue:isOn andAttrName:@"notify_notification"];
}

- (BOOL)isNotifyDongDaOn {
    MessageSetting* ms = [UserSetting queryMessageSettingWithUserID:_delegate.lm.current_user_id inContext:_doc.managedObjectContext];
    return ms.notify_dongda.boolValue;
}

- (void)resetNotifyDongDa:(BOOL)isOn {
    [self resetMessageSettingValue:isOn andAttrName:@"notify_dongda"];
}
@end
