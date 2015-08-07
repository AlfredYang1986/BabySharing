//
//  ConnectionOwner+ContextOpt.m
//  BabySharing
//
//  Created by Alfred Yang on 5/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "ConnectionOwner+ContextOpt.h"

@implementation ConnectionOwner (ContextOpt)

#pragma mark -- create and update
+ (ConnectionOwner*)createOrUpdateOwner:(NSString*)owner_id andFollowings:(NSArray*)following_arr andFollowed:(NSArray*)followed_arr andFriends:(NSArray*)friends_arr inContext:(NSManagedObjectContext*)context {
    
    [self createOrUpdateOwner:owner_id andFollowed:followed_arr inContext:context];
    [self createOrUpdateOwner:owner_id andFollowings:following_arr inContext:context];
    return [self createOrUpdateOwner:owner_id andFriends:friends_arr inContext:context];
}

+ (ConnectionOwner*)createOrUpdateOwner:(NSString *)owner_id andFollowings:(NSArray *)following_arr inContext:(NSManagedObjectContext *)context {
   
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"ConnectionOwner"];
    request.predicate = [NSPredicate predicateWithFormat:@"user_id = %@", owner_id];
//    NSSortDescriptor* des = [NSSortDescriptor sortDescriptorWithKey:@"user_id" ascending:YES];
//    request.sortDescriptors = [NSArray arrayWithObjects: des, nil];
    
    NSError* error = nil;
    NSArray* matches = [context executeFetchRequest:request error:&error];

    ConnectionOwner* tmp = nil;
    if (!matches || matches.count > 1) {
        NSLog(@"should have one and only one current user");
        return nil;
    } else if (matches.count == 1) {
        tmp = [matches lastObject];
        [self removeAllLocalFollowingsWithOwner:tmp inContext:context];
    } else {
        tmp = [NSEntityDescription insertNewObjectForEntityForName:@"ConnectionOwner" inManagedObjectContext:context];
        tmp.user_id = owner_id;
    }
    [self addLocalFollowingsWithOwner:tmp withData:following_arr inContext:context];
    return tmp;
}

+ (ConnectionOwner*)createOrUpdateOwner:(NSString *)owner_id andFollowed:(NSArray *)followed_arr inContext:(NSManagedObjectContext *)context {
    
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"ConnectionOwner"];
    request.predicate = [NSPredicate predicateWithFormat:@"user_id = %@", owner_id];
//    NSSortDescriptor* des = [NSSortDescriptor sortDescriptorWithKey:@"user_id" ascending:YES];
//    request.sortDescriptors = [NSArray arrayWithObjects: des, nil];
    
    NSError* error = nil;
    NSArray* matches = [context executeFetchRequest:request error:&error];
    
    ConnectionOwner* tmp = nil;
    if (!matches || matches.count > 1) {
        NSLog(@"should have one and only one current user");
        return nil;
    } else if (matches.count == 1) {
        tmp = [matches lastObject];
        [self removeAllLocalFollowedWithOwner:tmp inContext:context];
    } else {
        tmp = [NSEntityDescription insertNewObjectForEntityForName:@"ConnectionOwner" inManagedObjectContext:context];
        tmp.user_id = owner_id;
    }
    [self addLocalFollowedWithOwner:tmp withData:followed_arr inContext:context];
    return tmp;
}

+ (ConnectionOwner*)createOrUpdateOwner:(NSString *)owner_id andFriends:(NSArray *)friends_arr inContext:(NSManagedObjectContext *)context {
    
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"ConnectionOwner"];
    request.predicate = [NSPredicate predicateWithFormat:@"user_id = %@", owner_id];
    //    NSSortDescriptor* des = [NSSortDescriptor sortDescriptorWithKey:@"user_id" ascending:YES];
    //    request.sortDescriptors = [NSArray arrayWithObjects: des, nil];
    
    NSError* error = nil;
    NSArray* matches = [context executeFetchRequest:request error:&error];
    
    ConnectionOwner* tmp = nil;
    if (!matches || matches.count > 1) {
        NSLog(@"should have one and only one current user");
        return nil;
    } else if (matches.count == 1) {
        tmp = [matches lastObject];
        [self removeAllLocalFriendsWithOwner:tmp inContext:context];
    } else {
        tmp = [NSEntityDescription insertNewObjectForEntityForName:@"ConnectionOwner" inManagedObjectContext:context];
        tmp.user_id = owner_id;
    }
    [self addLocalFriendsWithOwner:tmp withData:friends_arr inContext:context];
    return tmp;
}

+ (void)removeAllLocalFriendsWithOwner:(ConnectionOwner*)owner inContext:(NSManagedObjectContext*)context {
    while (owner.friends.count != 0) {
        Friends* tmp = owner.friends.anyObject;
        [owner removeFriendsObject:tmp];
        [context deleteObject:tmp];
    }
}

+ (void)addLocalFriendsWithOwner:(ConnectionOwner*)owner withData:(NSArray*)friends_arr inContext:(NSManagedObjectContext*)context {
    
    for (NSString* friend in friends_arr) {
        Friends* tmp = [NSEntityDescription insertNewObjectForEntityForName:@"Friends" inManagedObjectContext:context];
        tmp.user_id = friend;
        tmp.friendsWith = owner;
        [owner addFriendsObject:tmp];
    }
}

+ (void)removeAllLocalFollowingsWithOwner:(ConnectionOwner*)owner inContext:(NSManagedObjectContext*)context {
    while (owner.following.count != 0) {
        Following* tmp = owner.following.anyObject;
        [owner removeFollowingObject:tmp];
        [context deleteObject:tmp];
    }
}

+ (void)addLocalFollowingsWithOwner:(ConnectionOwner*)owner withData:(NSArray*)following_arr inContext:(NSManagedObjectContext*)context {
   
    for (NSString* following in following_arr) {
        Following* tmp = [NSEntityDescription insertNewObjectForEntityForName:@"Following" inManagedObjectContext:context];
        tmp.user_id = following;
        tmp.followingBy = owner;
        [owner addFollowingObject:tmp];
    }
}

+ (void)removeAllLocalFollowedWithOwner:(ConnectionOwner*)owner inContext:(NSManagedObjectContext*)context {
    while (owner.followed.count != 0) {
        Followed* tmp = owner.followed.anyObject;
        [owner removeFollowedObject:tmp];
        [context deleteObject:tmp];
    }
}

+ (void)addLocalFollowedWithOwner:(ConnectionOwner*)owner withData:(NSArray*)followed_arr inContext:(NSManagedObjectContext*)context {
        for (NSString* followed in followed_arr) {
        Followed* tmp = [NSEntityDescription insertNewObjectForEntityForName:@"Followed" inManagedObjectContext:context];
        tmp.user_id = followed;
        tmp.followedBy = owner;
        [owner addFollowedObject:tmp];
    }
}

#pragma mark -- query
+ (NSArray*)queryFollowingsWithOwner:(NSString*)owner_id inContext:(NSManagedObjectContext*)context {

    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"ConnectionOwner"];
    request.predicate = [NSPredicate predicateWithFormat:@"user_id = %@", owner_id];
//    NSSortDescriptor* des = [NSSortDescriptor sortDescriptorWithKey:@"user_id" ascending:YES];
//    request.sortDescriptors = [NSArray arrayWithObjects: des, nil];
    
    NSError* error = nil;
    NSArray* matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || matches.count > 1) {
        NSLog(@"should have one and only one current user");
        return nil;
    } else if (matches.count == 1) {
        ConnectionOwner* tmp = [matches lastObject];
        return tmp.following.allObjects;
    } else {
        NSLog(@"should have one and only one current user");
        return nil;
    }
}

+ (NSArray*)queryFollowedWithOwner:(NSString*)owner_id inContext:(NSManagedObjectContext*)context {

    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"ConnectionOwner"];
    request.predicate = [NSPredicate predicateWithFormat:@"user_id = %@", owner_id];
//    NSSortDescriptor* des = [NSSortDescriptor sortDescriptorWithKey:@"user_id" ascending:YES];
//    request.sortDescriptors = [NSArray arrayWithObjects: des, nil];
    
    NSError* error = nil;
    NSArray* matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || matches.count > 1) {
        NSLog(@"should have one and only one current user");
        return nil;
    } else if (matches.count == 1) {
        ConnectionOwner* tmp = [matches lastObject];
        return tmp.followed.allObjects;
    } else {
        NSLog(@"should have one and only one current user");
        return nil;
    }
}

+ (NSArray*)queryMutureFriendsWithOwner:(NSString*)owner_id inContext:(NSManagedObjectContext*)context {
    
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"ConnectionOwner"];
    request.predicate = [NSPredicate predicateWithFormat:@"user_id = %@", owner_id];
    //    NSSortDescriptor* des = [NSSortDescriptor sortDescriptorWithKey:@"user_id" ascending:YES];
    //    request.sortDescriptors = [NSArray arrayWithObjects: des, nil];
    
    NSError* error = nil;
    NSArray* matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || matches.count > 1) {
        NSLog(@"should have one and only one current user");
        return nil;
    } else if (matches.count == 1) {
        ConnectionOwner* tmp = [matches lastObject];
        return tmp.friends.allObjects;
    } else {
        NSLog(@"should have one and only one current user");
        return nil;
    }
}
@end
