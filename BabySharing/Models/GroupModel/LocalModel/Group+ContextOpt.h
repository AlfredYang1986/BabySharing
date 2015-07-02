//
//  Group+ContextOpt.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 7/06/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Group.h"

@class SubGroup;
@class NSManagedObjectContext;

@interface Group (ContextOpt)

+ (NSArray*)enumAllGroupsInLocalDBInContext:(NSManagedObjectContext*)context;
+ (NSArray*)reloadAllGroupsByData:(NSArray*)gps inContext:(NSManagedObjectContext*)context;
+ (Group*)addOneGroupByData:(NSDictionary*)g inContext:(NSManagedObjectContext*)context;
+ (SubGroup*)addOneSubGroupByData:(NSDictionary*)sb toGroup:(Group*)g inContext:(NSManagedObjectContext*)context;
+ (void)removeAllGroupsInContext:(NSManagedObjectContext*)context;
+ (void)saveGroupsInContext:(NSManagedObjectContext*)context;
+ (NSArray*)enumAllSubGroupsInGroup:(Group*)group inLocalDBInContext:(NSManagedObjectContext*)context;
+ (Group*)enumGroupByGroupID:(NSString*)group_id inContext:(NSManagedObjectContext*)context;
+ (SubGroup*)enumSubGroupBySubGroupID:(NSString*)sub_groud_id inContext:(NSManagedObjectContext*)context;
@end
