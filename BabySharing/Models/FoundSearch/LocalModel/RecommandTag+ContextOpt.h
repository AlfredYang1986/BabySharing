//
//  RecommandTag+ContextOpt.h
//  BabySharing
//
//  Created by Alfred Yang on 14/12/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RecommandTag.h"
#import "RecommandTag+CoreDataProperties.h"

@interface RecommandTag(ContextOpt)

+ (void)upDateRecommandTags:(NSArray*)tags_arr inContext:(NSManagedObjectContext*)context;
+ (NSArray*)enumRecommandTagsInContext:(NSManagedObjectContext*)context;
+ (void)removeAllRecommandTagsInContext:(NSManagedObjectContext*)context;
@end
