//
//  RecommandRoleTag+ContextOpt.m
//  BabySharing
//
//  Created by Alfred Yang on 2/18/16.
//  Copyright © 2016 BM. All rights reserved.
//

#import "RecommandRoleTag+ContextOpt.h"

@implementation RecommandRoleTag(ContextOpt)

+ (void)upDateRecommandRoleTags:(NSArray*)tags_arr inContext:(NSManagedObjectContext*)context {
    [self removeAllRecommandRoleTagsInContext:context];
//    for (NSDictionary* dic in tags_arr) {
    for (NSString* str in tags_arr) {
        RecommandRoleTag* tmp = [NSEntityDescription insertNewObjectForEntityForName:@"RecommandRoleTag" inManagedObjectContext:context];
        tmp.tag_name = str;//[dic objectForKey:@"tag_name"];
    }
    
    //    [context save:nil];
}

+ (NSArray*)enumRecommandRoleTagsInContext:(NSManagedObjectContext*)context {
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"RecommandRoleTag"];
    
    NSError* error = nil;
    NSArray* match = [context executeFetchRequest:request error:&error];
    NSLog(@"%@", match);
    return match;
}

+ (void)removeAllRecommandRoleTagsInContext:(NSManagedObjectContext*)context {
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"RecommandRoleTag"];
    
    NSError* error = nil;
    NSMutableArray* matches = [[context executeFetchRequest:request error:&error] mutableCopy];
    
    while (matches.count != 0) {
        RecommandRoleTag* tmp = [matches lastObject];
        [matches removeObject:tmp];
        [context deleteObject:tmp];
    }
}
@end
