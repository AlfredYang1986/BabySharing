//
//  CoreDataManager.h
//  微视频
//
//  Created by monkeyheng on 15/7/18.
//  Copyright (c) 2015年 monkeyheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface TagSearchModelManager: NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
+ (TagSearchModelManager *)defaultsWithEntityName:(NSString *)entityName;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void)deleteWithEntityName:(NSString *)entityName key:(NSString *)key value:(NSString *)value;
- (NSArray *)selectWithEntityName:(NSString *)entityName key:(NSString *)key value:(NSString *)value;
- (NSArray *)selectWithuser_id:(NSString *)user_id search_type:(NSInteger)search_type;

@end
