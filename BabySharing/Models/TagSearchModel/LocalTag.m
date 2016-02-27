//
//  LocalTag.m
//  BabySharing
//
//  Created by monkeyheng on 16/2/27.
//  Copyright © 2016年 BM. All rights reserved.
//

#import "LocalTag.h"
#import "ModelDefines.h"
#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@implementation LocalTag

//+ (void)updateLocalTagWithType:(NSInteger)type text:(NSString *)text{
//    NSString* docs=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSURL* url =[NSURL fileURLWithPath:[docs stringByAppendingPathComponent:LOCALDB_TAG]];
//    UIManagedDocument *managedDocument = [[UIManagedDocument alloc] initWithFileURL:url];
//    BOOL aaa = [[NSFileManager defaultManager] fileExistsAtPath:[url path] isDirectory:nil];
//    if (!aaa) {
//        [managedDocument saveToURL:url forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
//            NSLog(@"create query database callback");
//            LocalTag* tmp = [NSEntityDescription insertNewObjectForEntityForName:@"LocalTag" inManagedObjectContext:managedDocument.managedObjectContext];
//            tmp.tag_userID = @"12344";
//            tmp.tag_type = [NSNumber numberWithInteger:type];
//            tmp.tag_text = text;
//        }];
//    } else if (managedDocument.documentState == UIDocumentStateClosed) {
//        [managedDocument openWithCompletionHandler:^(BOOL success) {
//            NSLog(@"open query database callback");
//            LocalTag* tmp = [NSEntityDescription insertNewObjectForEntityForName:@"LocalTag" inManagedObjectContext:managedDocument.managedObjectContext];
//            tmp.tag_userID = @"12344";
//            tmp.tag_type = [NSNumber numberWithInteger:type];
//            tmp.tag_text = text;
//        }];
//    }
//}
//
//+ (void)enumLocalTagWithType:(NSInteger)type match:(nonnull LocalTagblock)match{
//    
//    NSString* docs=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSURL* url =[NSURL fileURLWithPath:[docs stringByAppendingPathComponent:LOCALDB_TAG]];
//    UIManagedDocument *managedDocument = [[UIManagedDocument alloc] initWithFileURL:url];
//    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"LocalTag"];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"tag_type = %@", [NSString stringWithFormat:@"%ld", type]]];
////    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"tag_userId = %@ and tag_type = %@", [AppDelegate defaultAppDelegate].lm.current_auth_token, [NSString stringWithFormat:@"%ld", type]]];
//    request.predicate = predicate;
//    if (![[NSFileManager defaultManager]fileExistsAtPath:[url path] isDirectory:nil]) {
//        [managedDocument saveToURL:url forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
//            NSLog(@"create query database callback");
//            NSLog(@"%@ === %@", [managedDocument.managedObjectContext executeFetchRequest:request error:nil], @"");
//        }];
//    } else if (managedDocument.documentState == UIDocumentStateClosed) {
//        [managedDocument openWithCompletionHandler:^(BOOL success) {
//            NSLog(@"open query database callback");
//            NSArray *arr = [managedDocument.managedObjectContext executeFetchRequest:request error:nil];
//            NSLog(@"%@ === %@", [managedDocument.managedObjectContext executeFetchRequest:request error:nil], @"");\
//            match(arr);
//        }];
//    }
//}
@end
