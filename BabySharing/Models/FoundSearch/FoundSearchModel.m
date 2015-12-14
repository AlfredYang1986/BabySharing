//
//  FonndSearchModel.m
//  BabySharing
//
//  Created by Alfred Yang on 14/12/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import "FoundSearchModel.h"
#import "ModelDefines.h"
//#import <CoreData/CoreData.h>
#import "RemoteInstance.h"
#import "AppDelegate.h"

#import "RecommandTag.h"
#import "RecommandTag+ContextOpt.h"

@implementation FoundSearchModel

@synthesize doc = _doc;
@synthesize recommandsdata = _recommandsdata;
@synthesize previewDic = _previewDic;
@synthesize delegate = _delegate;

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

- (void)enumRecommandTagsLocal {
    _recommandsdata = [RecommandTag enumRecommandTagsInContext:_doc.managedObjectContext];
}

- (void)queryRecommandTagsWithFinishBlock:(queryRecommondTagFinishBlock)block {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    
    [dic setValue:_delegate.lm.current_auth_token forKey:@"auth_token"];
    [dic setValue:_delegate.lm.current_user_id forKey:@"user_id"];
//    [dic setValue:follow_user_id forKey:@"follow_user_id"];
//    [dic setValue:_delegate.lm.current_user_id forKey:@"owner_id"];
    
    NSError * error = nil;
    NSData* jsonData =[NSJSONSerialization dataWithJSONObject:[dic copy] options:NSJSONWritingPrettyPrinted error:&error];
    
    NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:TAG_RECOMMAND_QUERY]];
    
    if ([[result objectForKey:@"status"] isEqualToString:@"ok"]) {
        NSArray* reVal = [result objectForKey:@"recommands"];
        NSLog(@"recommand tag are: %@", reVal);
        [RecommandTag upDateRecommandTags:reVal inContext:_doc.managedObjectContext];
        [self enumRecommandTagsLocal];
        block(YES, reVal);
        
    } else {
        block(NO, nil);
    }
}

- (void)queryFoundTagSearchWithInput:(NSString*)input andFinishBlock:(queryFoundTagSearchFinishBlock)block {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    
    [dic setValue:_delegate.lm.current_auth_token forKey:@"auth_token"];
    [dic setValue:_delegate.lm.current_user_id forKey:@"user_id"];
    [dic setValue:input forKey:@"tag_name"];
    //    [dic setValue:_delegate.lm.current_user_id forKey:@"owner_id"];
    
    NSError * error = nil;
    NSData* jsonData =[NSJSONSerialization dataWithJSONObject:[dic copy] options:NSJSONWritingPrettyPrinted error:&error];
    
//    NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:TAG_PREVIEW_QUERY]];
    NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:TAG_FOUND_SEARCH]];
    
    if ([[result objectForKey:@"status"] isEqualToString:@"ok"]) {
        NSArray* reVal = [result objectForKey:@"preview"];
        NSLog(@"search result: %@", reVal);
        _previewDic = reVal;
        block(YES, nil);
        
    } else {
        block(NO, nil);
    }
}
@end
