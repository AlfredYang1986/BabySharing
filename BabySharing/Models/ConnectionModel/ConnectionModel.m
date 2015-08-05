//
//  ConnectionModel.m
//  BabySharing
//
//  Created by Alfred Yang on 5/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "ConnectionModel.h"
#import "ModelDefines.h"
#import <CoreData/CoreData.h>

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
@end
