//
//  GroupModel.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 7/06/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "GroupModel.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "ModelDefines.h"
#import "Group+ContextOpt.h"
#import "RemoteInstance.h"

@implementation GroupModel

@synthesize doc = _doc;
@synthesize groupdata = _groupdata;     // array for current groups
@synthesize delegate = _delegate;       // app delegate for callback

#pragma mark -- constractor
- (void)enumDataFromLocalDB:(UIManagedDocument*)document {
    dispatch_queue_t aq = dispatch_queue_create("load_group_data", NULL);
    
    dispatch_async(aq, ^(void){
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [document.managedObjectContext performBlock:^(void){
                [Group removeAllGroupsInContext:document.managedObjectContext];
                _groupdata = [Group enumAllGroupsInLocalDBInContext:document.managedObjectContext];
                if (_groupdata == nil || _groupdata.count == 0) {
                    [self refreshGroups];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"group data ready" object:nil];
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
        NSURL* url =[NSURL fileURLWithPath:[docs stringByAppendingPathComponent:LOCALDB_GROUP]];
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

#pragma mark -- query for service
- (void)refreshGroups {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:_delegate.lm.current_auth_token forKey:@"auth_token"];
    [dic setValue:_delegate.lm.current_user_id forKey:@"user_id"];
    
    NSError * error = nil;
    NSData* jsonData =[NSJSONSerialization dataWithJSONObject:[dic copy] options:NSJSONWritingPrettyPrinted error:&error];
    
//    NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:[GROUP_HOST_DOMAIN_SENDBOX stringByAppendingString:QUERY_GROUP]]];
    NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:[GROUP_HOST_DOMAIN stringByAppendingString:QUERY_GROUP]]];
    
    if ([[result objectForKey:@"status"] isEqualToString:@"ok"]) {
        NSArray* reVal = [[result objectForKey:@"result"] objectForKey:@"groups"];
        _groupdata = [Group reloadAllGroupsByData:reVal inContext:_doc.managedObjectContext];
        
    } else {
        NSDictionary* reError = [result objectForKey:@"error"];
        NSString* msg = [reError objectForKey:@"message"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:msg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark -- create a new sub group
- (Group*)createSubGroup:(NSString*)sub_group_name inGroup:(Group*)g {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    NSString * group_id = g.group_id;
    [dic setValue:_delegate.lm.current_auth_token forKey:@"auth_token"];
    [dic setValue:_delegate.lm.current_user_id forKey:@"user_id"];
    [dic setValue:group_id forKey:@"group_id"];
    [dic setValue:sub_group_name forKey:@"sub_group_name"];
    
    NSError * error = nil;
    NSData* jsonData =[NSJSONSerialization dataWithJSONObject:[dic copy] options:NSJSONWritingPrettyPrinted error:&error];
    
//    NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:[GROUP_HOST_DOMAIN_SENDBOX stringByAppendingString:CREATE_SUB_GROUP]]];
    NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:[GROUP_HOST_DOMAIN stringByAppendingString:CREATE_SUB_GROUP]]];
    
    if ([[result objectForKey:@"status"] isEqualToString:@"ok"]) {
        NSArray* reVal = [[result objectForKey:@"result"] objectForKey:@"groups"];
        _groupdata = [Group reloadAllGroupsByData:reVal inContext:_doc.managedObjectContext];
      
        NSPredicate* p = [NSPredicate predicateWithFormat:@"group_id = %@", group_id];
        return [_groupdata filteredArrayUsingPredicate:p].firstObject;
        
    } else {
        NSDictionary* reError = [result objectForKey:@"error"];
        NSString* msg = [reError objectForKey:@"message"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:msg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
        return nil;
    }
}
@end
