//
//  RecommandRoleTag+ContextOpt.h
//  BabySharing
//
//  Created by Alfred Yang on 2/18/16.
//  Copyright © 2016 BM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RecommandRoleTag.h"
#import "RecommandRoleTag+ContextOpt.h"

@interface RecommandRoleTag(ContextOpt)

+ (void)upDateRecommandRoleTags:(NSArray*)tags_arr inContext:(NSManagedObjectContext*)context;
+ (NSArray*)enumRecommandRoleTagsInContext:(NSManagedObjectContext*)context;
+ (void)removeAllRecommandRoleTagsInContext:(NSManagedObjectContext*)context;

@end
