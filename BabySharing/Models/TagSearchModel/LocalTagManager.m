//
//  LocalTagManager.m
//  BabySharing
//
//  Created by monkeyheng on 16/2/28.
//  Copyright © 2016年 BM. All rights reserved.
//

#import "LocalTagManager.h"
#import "LocalTag.h"
#import <UIKit/UIKit.h>
#import "ModelDefines.h"
#import "AppDelegate.h"

@interface LocalTagManager()

@property (nonatomic, strong) UIManagedDocument *managerDocument;

@end

@implementation LocalTagManager

- (instancetype)init {
    self = [super init];
    if (self) {
        NSString* docs=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSURL* url =[NSURL fileURLWithPath:[docs stringByAppendingPathComponent:LOCALDB_TAG]];
        self.managerDocument = [[UIManagedDocument alloc] initWithFileURL:url];
        if (![[NSFileManager defaultManager]fileExistsAtPath:[url path] isDirectory:nil]) {
            [self.managerDocument saveToURL:url forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
                NSLog(@"create query database callback");
            }];
        } else if (self.managerDocument.documentState == UIDocumentStateClosed) {
            [self.managerDocument openWithCompletionHandler:^(BOOL success) {
                NSLog(@"open query database callback");
            }];
        }
    }
    return self;
}

- (void)updateLocalTagWithType:(NSInteger)type text:(NSString *)text{
    LocalTag* tmp = [NSEntityDescription insertNewObjectForEntityForName:@"LocalTag" inManagedObjectContext:self.managerDocument.managedObjectContext];
    tmp.tag_userID = [AppDelegate defaultAppDelegate].lm.current_user_id;
    tmp.tag_type = [NSNumber numberWithInteger:type];
    tmp.tag_text = text;
}

- (NSArray *)enumLocalTagWithType:(NSInteger)type{
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"LocalTag"];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"tag_userID = %@", [AppDelegate defaultAppDelegate].lm.current_user_id]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"tag_type = %ld", (long)type]];
    request.predicate = predicate;
    NSError *error;
    NSArray *arr = [self.managerDocument.managedObjectContext executeFetchRequest:request error:&error];
    NSMutableArray *array = [NSMutableArray array];
    for (LocalTag *localtag in arr) {
        if ([localtag.tag_userID isEqualToString:[AppDelegate defaultAppDelegate].lm.current_user_id]) {
            [array addObject:localtag];
        }
    }
    return array;
}

@end
