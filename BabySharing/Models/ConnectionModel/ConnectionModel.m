//
//  ConnectionModel.m
//  BabySharing
//
//  Created by Alfred Yang on 5/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "ConnectionModel.h"
#import "ModelDefines.h"
//#import <CoreData/CoreData.h>
#import "RemoteInstance.h"
#import "AppDelegate.h"
#import "ConnectionOwner+ContextOpt.h"

@implementation ConnectionModel
@synthesize querydata = _querydata;
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
        NSURL* url =[NSURL fileURLWithPath:[docs stringByAppendingPathComponent:LOCALDB_RELATIONSHIP]];
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

#pragma mark -- follow and unfollow
- (void)followOneUser:(NSString*)follow_user_id withFinishBlock:(followFinishBlock)block {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    
    [dic setValue:_delegate.lm.current_auth_token forKey:@"auth_token"];
    [dic setValue:_delegate.lm.current_user_id forKey:@"user_id"];
    [dic setValue:follow_user_id forKey:@"follow_user_id"];
    [dic setValue:_delegate.lm.current_user_id forKey:@"owner_id"];
    
    NSError * error = nil;
    NSData* jsonData =[NSJSONSerialization dataWithJSONObject:[dic copy] options:NSJSONWritingPrettyPrinted error:&error];
    
    NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:RELATIONSHIP_FOLLOW]];
    
    if ([[result objectForKey:@"status"] isEqualToString:@"ok"]) {
        NSDictionary* reVal = [result objectForKey:@"result"];
        NSLog(@"connections result: %@", reVal);
        block(YES, @"");
        
    } else {
        //        NSDictionary* reError = [result objectForKey:@"error"];
        //        NSString* msg = [reError objectForKey:@"message"];
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:msg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        //        [alert show];
        block(NO, @"");
    }
}

- (void)unfollowOneUser:(NSString*)follow_user_id withFinishBlock:(followFinishBlock)block {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];

    [dic setValue:_delegate.lm.current_auth_token forKey:@"auth_token"];
    [dic setValue:_delegate.lm.current_user_id forKey:@"user_id"];
    [dic setValue:follow_user_id forKey:@"follow_user_id"];
    [dic setValue:_delegate.lm.current_user_id forKey:@"owner_id"];
    
    NSError * error = nil;
    NSData* jsonData =[NSJSONSerialization dataWithJSONObject:[dic copy] options:NSJSONWritingPrettyPrinted error:&error];
    
    NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:RELATIONSHIP_UNFOLLOW]];
    
    if ([[result objectForKey:@"status"] isEqualToString:@"ok"]) {
        NSDictionary* reVal = [result objectForKey:@"result"];
        NSLog(@"connections result: %@", reVal);
        block(YES, @"");
        
    } else {
        //        NSDictionary* reError = [result objectForKey:@"error"];
        //        NSString* msg = [reError objectForKey:@"message"];
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:msg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        //        [alert show];
        block(NO, @"");
    }
}

#pragma mark -- query connections
- (void)queryFollowingWithUser:(NSString*)owner_id andFinishBlock:(queryFinishBlock)block {
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    
    [dic setValue:_delegate.lm.current_user_id forKey:@"user_id"];
    [dic setValue:_delegate.lm.current_auth_token forKey:@"auth_token"];
    [dic setValue:owner_id forKey:@"owner_id"];
    
    NSError* error = nil;
    NSData* jsonData =[NSJSONSerialization dataWithJSONObject:[dic copy] options:NSJSONWritingPrettyPrinted error:&error];
    
    NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:RELATIONSHIP_QUERY_FOLLOWING]];
    
    if ([[result objectForKey:@"status"] isEqualToString:@"ok"]) {
        NSArray* reVal = [[result objectForKey:@"result"] objectForKey:@"following"];
        NSLog(@"following success : %@", reVal);
        [ConnectionOwner createOrUpdateOwner:owner_id andFollowings:reVal inContext:_doc.managedObjectContext];
        block(YES);
        
    } else {
        //        NSDictionary* reError = [result objectForKey:@"error"];
        //        NSString* msg = [reError objectForKey:@"message"];
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:msg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        //        [alert show];
        NSLog(@"following query error");
        block(NO);
    }
}

- (void)queryFollowedWithUser:(NSString*)owner_id andFinishBlock:(queryFinishBlock)block {
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    
    [dic setValue:_delegate.lm.current_user_id forKey:@"user_id"];
    [dic setValue:_delegate.lm.current_auth_token forKey:@"auth_token"];
    [dic setValue:owner_id forKey:@"owner_id"];
    
    NSError* error = nil;
    NSData* jsonData =[NSJSONSerialization dataWithJSONObject:[dic copy] options:NSJSONWritingPrettyPrinted error:&error];
    
    NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:RELATIONSHIP_QUERY_FOLLOWED]];
    
    if ([[result objectForKey:@"status"] isEqualToString:@"ok"]) {
        NSArray* reVal = [[result objectForKey:@"result"] objectForKey:@"followed"];
        NSLog(@"following success : %@", reVal);
        [ConnectionOwner createOrUpdateOwner:owner_id andFollowed:reVal inContext:_doc.managedObjectContext];
        block(YES);
        
    } else {
        //        NSDictionary* reError = [result objectForKey:@"error"];
        //        NSString* msg = [reError objectForKey:@"message"];
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:msg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        //        [alert show];
        NSLog(@"following query error");
        block(NO);
    }
}

- (void)queryFriendsWithUser:(NSString*)owner_id andFinishBlock:(queryFinishBlock)block {
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    
    [dic setValue:_delegate.lm.current_user_id forKey:@"user_id"];
    [dic setValue:_delegate.lm.current_auth_token forKey:@"auth_token"];
    [dic setValue:owner_id forKey:@"owner_id"];
    
    NSError* error = nil;
    NSData* jsonData =[NSJSONSerialization dataWithJSONObject:[dic copy] options:NSJSONWritingPrettyPrinted error:&error];
    
    NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:RELATIONSHIP_QUERY_FRIENDS]];
    
    if ([[result objectForKey:@"status"] isEqualToString:@"ok"]) {
        NSArray* reVal = [[result objectForKey:@"result"] objectForKey:@"friends"];
        NSLog(@"following success : %@", reVal);
        [ConnectionOwner createOrUpdateOwner:owner_id andFriends:reVal inContext:_doc.managedObjectContext];
        block(YES);
        
    } else {
        //        NSDictionary* reError = [result objectForKey:@"error"];
        //        NSString* msg = [reError objectForKey:@"message"];
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:msg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        //        [alert show];
        NSLog(@"following query error");
        block(NO);
    }
}

#pragma mark -- query connections from local
- (NSArray*)queryLocalFollowingWithUser:(NSString*)owner_id {
    return [ConnectionOwner queryFollowingsWithOwner:owner_id inContext:_doc.managedObjectContext];
}

- (NSArray*)queryLocalFollowedWithUser:(NSString*)owner_id {
    return [ConnectionOwner queryFollowedWithOwner:owner_id inContext:_doc.managedObjectContext];
}

- (NSArray*)queryLocalFriendsWithUser:(NSString*)owner_id {
    return [ConnectionOwner queryMutureFriendsWithOwner:owner_id inContext:_doc.managedObjectContext];
}

@end
