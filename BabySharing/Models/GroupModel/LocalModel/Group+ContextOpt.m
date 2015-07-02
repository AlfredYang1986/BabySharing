//
//  Group+ContextOpt.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 7/06/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "Group+ContextOpt.h"
#import "SubGroup.h"
#import "Messages.h"

@implementation Group (ContextOpt)

+ (NSArray*)enumAllGroupsInLocalDBInContext:(NSManagedObjectContext*)context {
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"Group"];
    
    NSSortDescriptor* des = [NSSortDescriptor sortDescriptorWithKey:@"group_name" ascending:NO];
    request.sortDescriptors = [NSArray arrayWithObjects: des, nil];
    
    NSError* error = nil;
    return [context executeFetchRequest:request error:&error];
}

+ (NSArray*)reloadAllGroupsByData:(NSArray*)gps inContext:(NSManagedObjectContext*)context {
    [self removeAllGroupsInContext:context];
   
    for (NSDictionary* g in gps) {
        [self addOneGroupByData:g inContext:context];
    }
   
    [self saveGroupsInContext:context];
    return [self enumAllGroupsInLocalDBInContext:context];
}

+ (Group*)addOneGroupByData:(NSDictionary*)g inContext:(NSManagedObjectContext*)context {
    Group* tmp = [NSEntityDescription insertNewObjectForEntityForName:@"Group" inManagedObjectContext:context];
    
    tmp.group_id = [g objectForKey:@"group_id"];
    tmp.group_name = [g objectForKey:@"group_name"];
    
    NSNumber* found_mills = [g objectForKey:@"group_found_time"];
    NSTimeInterval found_seconds = found_mills.longLongValue / 1000.0;
    tmp.group_found_time = [NSDate dateWithTimeIntervalSince1970:found_seconds];
   
    NSArray * arr = [g objectForKey:@"sub_groups"];
    for (NSDictionary* sb in arr) {
        [self addOneSubGroupByData:sb toGroup:tmp inContext:context];
    }
    
    return tmp;
}

+ (SubGroup*)addOneSubGroupByData:(NSDictionary*)sb toGroup:(Group*)g inContext:(NSManagedObjectContext*)context {
    
    SubGroup* tmp = [NSEntityDescription insertNewObjectForEntityForName:@"SubGroup" inManagedObjectContext:context];
    
    tmp.sub_group_id = [sb objectForKey:@"sub_group_id"];
    tmp.sub_group_name = [sb objectForKey:@"sub_group_name"];
    
    NSNumber* found_mills = [sb objectForKey:@"sub_group_found_time"];
    NSTimeInterval found_seconds = found_mills.longLongValue / 1000.0;
    tmp.sub_group_found_time = [NSDate dateWithTimeIntervalSince1970:found_seconds];

    NSNumber* update_mills = [sb objectForKey:@"sub_group_update_time"];
    NSTimeInterval update_seconds = update_mills.longLongValue / 1000.0;
    tmp.sub_group_update_time = [NSDate dateWithTimeIntervalSince1970:update_seconds];
   
    [g addSubGroupsObject:tmp];
    
    return tmp;
}

+ (void)removeAllGroupsInContext:(NSManagedObjectContext*)context {
    NSArray* gps = [self enumAllGroupsInLocalDBInContext:context];
    for (Group* g in gps) {
       
        while (g.subGroups.count != 0) {
            SubGroup* sb = [g.subGroups.objectEnumerator nextObject];
            
            while (sb.messages.count != 0) {
                Messages* m = [sb.messages.objectEnumerator nextObject];
                [sb removeMessagesObject:m];
                [context deleteObject:m];
            }
            
            [g removeSubGroupsObject:sb];
            [context deleteObject:sb];
        }
        [context deleteObject:g];
    }
   
    [self saveGroupsInContext:context];
}

+ (void)saveGroupsInContext:(NSManagedObjectContext*)context {
    [context save:nil];
}

+ (NSArray*)enumAllSubGroupsInGroup:(Group*)group inLocalDBInContext:(NSManagedObjectContext*)context {
    return [group.subGroups allObjects];
}

+ (NSArray*)enumAllMessagesInSubGroup:(SubGroup*)sb inContext:(NSManagedObjectContext*)context {
    return [sb.messages allObjects];
}

+ (NSArray*)enumAllMesssagesInContext:(NSManagedObjectContext*)context {
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"Messages"];
    
    NSError* error = nil;
    return [context executeFetchRequest:request error:&error];
}

+ (Group*)enumGroupByGroupID:(NSString*)group_id inContext:(NSManagedObjectContext*)context {
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"Group"];
    request.predicate = [NSPredicate predicateWithFormat:@"group_id = %@", group_id];
    NSSortDescriptor* des = [NSSortDescriptor sortDescriptorWithKey:@"group_name" ascending:NO];
    request.sortDescriptors = [NSArray arrayWithObjects: des, nil];
    
    NSError* error = nil;
    NSArray* matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || matches.count > 1) {
        NSLog(@"error with primary key");
        return nil;
    } else if (matches.count == 1) {
        return matches.firstObject;
        
    } else {
        NSLog(@"group with group_id is not exist");
        return nil;
    }
}

+ (SubGroup*)enumSubGroupBySubGroupID:(NSString*)sub_group_id inContext:(NSManagedObjectContext*)context {
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"SubGroup"];
    request.predicate = [NSPredicate predicateWithFormat:@"sub_group_id = %@", sub_group_id];
    
    NSError* error = nil;
    NSArray* matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || matches.count > 1) {
        NSLog(@"error with primary key");
        return nil;
    } else if (matches.count == 1) {
        return matches.firstObject;
        
    } else {
        NSLog(@"sub group with sub_group_id is not exist");
        return nil;
    }
}
@end
