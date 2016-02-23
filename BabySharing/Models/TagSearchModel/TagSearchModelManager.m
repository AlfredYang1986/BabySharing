//
//  CoreDataManager.m
//  微视频
//
//  Created by monkeyheng on 15/7/18.
//  Copyright (c) 2015年 monkeyheng. All rights reserved.
//

#import "TagSearchModelManager.h"
@interface TagSearchModelManager()

@property (nonatomic, strong) NSString *entityName;
@property (nonatomic, strong) NSURL *url;

@end

@implementation TagSearchModelManager

+ (TagSearchModelManager *)defaultsWithEntityName:(NSString *)entityName {
    static TagSearchModelManager *manager;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        manager = [[TagSearchModelManager alloc] init];
    });
    NSString* docs=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    manager.url =[NSURL fileURLWithPath:[docs stringByAppendingPathComponent:entityName]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:[manager.url path]]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:[manager.url path] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    manager.entityName = entityName;
    
    return manager;
}


#pragma mark - Core Data stack
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.monkeyheng.___" in the application's documents directory.
    return self.url;
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:self.entityName withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", self.entityName]];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark 删除
- (void)deleteWithEntityName:(NSString *)entityName key:(NSString *)key value:(NSString *)value {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:entityName];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@ == %@", key, @"%@"], value];
    
    request.predicate = predicate;
    
    NSArray *arr = [self.managedObjectContext executeFetchRequest:request error:nil];
    
    for (NSManagedObject *object in arr) {
        [self.managedObjectContext deleteObject:object];
    }
    [self saveContext];
}

- (NSArray *)selectWithEntityName:(NSString *)entityName key:(NSString *)key value:(NSString *)value {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:entityName];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@ == %@", key, @"%@"], value];
    
    request.predicate = predicate;
    
    NSArray *arr = [self.managedObjectContext executeFetchRequest:request error:nil];
    
    return arr;
}


@end
