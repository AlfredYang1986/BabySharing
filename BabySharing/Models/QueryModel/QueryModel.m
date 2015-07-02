//
//  QueryModel.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 9/01/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "QueryModel.h"
#import <CoreData/CoreData.h>
#import "QueryContent+ContextOpt.h"
#import "RemoteInstance.h"
#import "AppDelegate.h"
#import "ModelDefines.h"
#import "ModelDefines.h"

@implementation QueryModel {

}

@synthesize doc = _doc;
@synthesize querydata = _querydata;
@synthesize delegate = _delegate;

#pragma mark -- constractor
- (void)enumDataFromLocalDB:(UIManagedDocument*)document {
    dispatch_queue_t aq = dispatch_queue_create("load_query_data", NULL);
    
    dispatch_async(aq, ^(void){
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [document.managedObjectContext performBlock:^(void){
                _querydata =  [QueryContent enumLocalQueyDataInContext:document.managedObjectContext];
                if (_querydata == nil || _querydata.count == 0) {
                    [self refreshQueryDataByUser:self.delegate.lm.current_user_id withToken:self.delegate.lm.current_auth_token];
                }
                [[NSNotificationCenter defaultCenter]postNotificationName:@"query data ready" object:nil];
            }];
        });
    });
}

- (id)initWithDelegate:(AppDelegate*)app {
    self = [super init];
    if (self) {
    
        _delegate = app;
        /**
         * get previous data from local database
         */
        NSString* docs=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSURL* url =[NSURL fileURLWithPath:[docs stringByAppendingPathComponent:LOCALDB_QUERY]];
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

#pragma mark -- home query operation
- (void)refreshQueryDataByUser:(NSString*)user_id withToken:(NSString*)token {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:token forKey:@"auth_token"];
    [dic setValue:user_id forKey:@"user_id"];
    
    NSError * error = nil;
    NSData* jsonData =[NSJSONSerialization dataWithJSONObject:[dic copy] options:NSJSONWritingPrettyPrinted error:&error];
    
    NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:[QUERY_HOST_DOMAIN stringByAppendingString:QUERY_REFRESH_HOME]]];
    
    if ([[result objectForKey:@"status"] isEqualToString:@"ok"]) {
        NSArray* reVal = [result objectForKey:@"result"];
        NSNumber*  time = [result objectForKey:@"date"];
        _querydata = [QueryContent refrashLocalQueryDataInContext:_doc.managedObjectContext withData:reVal andTimeSpan:time.longLongValue];
        
    } else {
        NSDictionary* reError = [result objectForKey:@"error"];
        NSString* msg = [reError objectForKey:@"message"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:msg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)refreshQueryDataByUser:(NSString*)user_id withToken:(NSString*)token withFinishBlock:(queryDataFinishBlock)block {
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:token forKey:@"auth_token"];
    [dic setValue:user_id forKey:@"user_id"];
    
    NSError * error = nil;
    NSData* jsonData =[NSJSONSerialization dataWithJSONObject:[dic copy] options:NSJSONWritingPrettyPrinted error:&error];
    
    NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:[QUERY_HOST_DOMAIN stringByAppendingString:QUERY_REFRESH_HOME]]];
    
    if ([[result objectForKey:@"status"] isEqualToString:@"ok"]) {
        NSArray* reVal = [result objectForKey:@"result"];
        NSNumber*  time = [result objectForKey:@"date"];
        _querydata = [QueryContent refrashLocalQueryDataInContext:_doc.managedObjectContext withData:reVal andTimeSpan:time.longLongValue];
        block();
        
    } else {
        NSDictionary* reError = [result objectForKey:@"error"];
        NSString* msg = [reError objectForKey:@"message"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:msg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)appendQueryDataByUser:(NSString*)user_id withToken:(NSString*)token andBeginIndex:(NSInteger)skip {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:token forKey:@"auth_token"];
    [dic setValue:user_id forKey:@"user_id"];
    [dic setValue:[NSNumber numberWithInt:skip] forKey:@"skip"];
 
    NSNumber* time = [QueryContent enumContentTimeSpanInContext:_doc.managedObjectContext];
    [dic setValue:time forKey:@"date"];
    
    NSError * error = nil;
    NSData* jsonData =[NSJSONSerialization dataWithJSONObject:[dic copy] options:NSJSONWritingPrettyPrinted error:&error];
    
    NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:[QUERY_HOST_DOMAIN stringByAppendingString:QUERY_REFRESH_HOME]]];
    
    if ([[result objectForKey:@"status"] isEqualToString:@"ok"]) {
        NSArray* reVal = [result objectForKey:@"result"];
        
        _querydata = [QueryContent appendLocalQueryDataInContext:_doc.managedObjectContext withData:reVal];
        
    } else {
        NSDictionary* reError = [result objectForKey:@"error"];
        NSString* msg = [reError objectForKey:@"message"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:msg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark -- save content
- (void)saveTop:(NSInteger)top {
    [QueryContent saveTop:top inContext:_doc.managedObjectContext];
}

#pragma mark -- comments query operation
- (QueryContent*)refreshCommentsByUser:(NSString*)user_id withToken:(NSString*)token andPostID:(NSString*)post_id {
   
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:token forKey:@"auth_token"];
    [dic setValue:user_id forKey:@"user_id"];
    [dic setValue:post_id forKey:@"post_id"];
    
    NSError * error = nil;
    NSData* jsonData =[NSJSONSerialization dataWithJSONObject:[dic copy] options:NSJSONWritingPrettyPrinted error:&error];
    
    NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:[QUERY_HOST_DOMAIN stringByAppendingString:QUERY_COMMENTS]]];
    
    QueryContent* content = [QueryContent enumQueryContentByPostID:post_id inContext:_doc.managedObjectContext];
    
    if ([[result objectForKey:@"status"] isEqualToString:@"ok"]) {
        NSDictionary* re_dic = [result objectForKey:@"result"];
        NSArray* reVal = [re_dic objectForKey:@"comments"];
        NSNumber* count = [re_dic objectForKey:@"comments_count"];
        [QueryContent changeCommentTimeSpan:[result objectForKey:@"date"] forPostID:post_id inContext:_doc.managedObjectContext];
        [QueryContent refreshCommentToPostWithID:post_id withAttrs:reVal andTotalCount:count inContext:_doc.managedObjectContext];
        _querydata = [QueryContent appendLocalQueryDataInContext:_doc.managedObjectContext withData:reVal];

//        content.comment_count = [re_dic objectForKey:@"comments_count"];
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"comments update" object:nil];
        
    } else {
        NSDictionary* reError = [result objectForKey:@"error"];
        NSString* msg = [reError objectForKey:@"message"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:msg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
    }
    return content;
}

- (QueryContent*)appendCommentsByUser:(NSString*)user_id withToken:(NSString*)token andBeginIndex:(NSInteger)skip andPostID:(NSString*)post_id {
  
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:token forKey:@"auth_token"];
    [dic setValue:user_id forKey:@"user_id"];
    [dic setValue:post_id forKey:@"post_id"];
    
    QueryContent* content = [QueryContent enumQueryContentByPostID:post_id inContext:_doc.managedObjectContext];
    [dic setValue:content.comment_time_span forKey:@"date"];
    [dic setValue:[NSNumber numberWithInt:content.comments.count] forKey:@"skip"];
    
    NSError * error = nil;
    NSData* jsonData =[NSJSONSerialization dataWithJSONObject:[dic copy] options:NSJSONWritingPrettyPrinted error:&error];
    
    NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:[QUERY_HOST_DOMAIN stringByAppendingString:QUERY_COMMENTS]]];
    
    if ([[result objectForKey:@"status"] isEqualToString:@"ok"]) {
        NSDictionary* re_dic = [result objectForKey:@"result"];
        NSArray* reVal = [re_dic objectForKey:@"comments"];
        NSNumber* count = [re_dic objectForKey:@"comments_count"];
        [QueryContent appendCommentToPostWithID:post_id withAttrs:reVal andTotalCount:count inContext:_doc.managedObjectContext];
        _querydata = [QueryContent enumLocalQueyDataInContext:_doc.managedObjectContext];
//        content.comment_count = [re_dic objectForKey:@"comments_count"];
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"comments update" object:nil];
        
    } else {
        NSDictionary* reError = [result objectForKey:@"error"];
        NSString* msg = [reError objectForKey:@"message"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:msg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
    }
    return content;
}


@end
