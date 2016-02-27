//
//  RecommandTag+ContextOpt.m
//  BabySharing
//
//  Created by Alfred Yang on 14/12/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import "RecommandTag+ContextOpt.h"
#import "AppDelegate.h"

@implementation RecommandTag(ContextOpt)

+ (void)upDateRecommandTags:(NSArray*)tags_arr inContext:(NSManagedObjectContext*)context {
    [self removeAllRecommandTagsInContext:context];
    for (NSDictionary* dic in tags_arr) {
        RecommandTag* tmp = [NSEntityDescription insertNewObjectForEntityForName:@"RecommandTag" inManagedObjectContext:context];
        tmp.tag_name = [dic objectForKey:@"tag_name"];
        tmp.tag_type = [dic objectForKey:@"tag_type"];
    }
    
//    [context save:nil];
}

+ (void)removeAllRecommandTagsInContext:(NSManagedObjectContext*)context {
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"RecommandTag"];
    
    NSError* error = nil;
    NSMutableArray* matches = [[context executeFetchRequest:request error:&error] mutableCopy];

    while (matches.count != 0) {
        RecommandTag* tmp = [matches lastObject];
        [matches removeObject:tmp];
        [context deleteObject:tmp];
    }
}

+ (NSArray*)enumRecommandTagsInContext:(NSManagedObjectContext*)context {
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"RecommandTag"];
    
    NSError* error = nil;
    NSArray* match = [context executeFetchRequest:request error:&error];
    NSLog(@"%@", match);
    return match;
}
@end
