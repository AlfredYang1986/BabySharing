//
//  ConnectionOwner+ContextOpt.h
//  BabySharing
//
//  Created by Alfred Yang on 5/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConnectionOwner.h"
#import "Following.h"
#import "Followed.h"
#import "Friends.h"

@interface ConnectionOwner (ContextOpt)

#pragma mark -- create and update
+ (ConnectionOwner*)createOrUpdateOwner:(NSString*)owner_id andFollowings:(NSArray*)following_arr andFollowed:(NSArray*)followed_arr andFriends:(NSArray*)friends_arr inContext:(NSManagedObjectContext*)context;
+ (ConnectionOwner*)createOrUpdateOwner:(NSString *)owner_id andFollowings:(NSArray *)following_arr inContext:(NSManagedObjectContext *)context;
+ (ConnectionOwner*)createOrUpdateOwner:(NSString *)owner_id andFollowed:(NSArray *)followed_arr inContext:(NSManagedObjectContext *)context;
+ (ConnectionOwner*)createOrUpdateOwner:(NSString *)owner_id andFriends:(NSArray *)friends_arr inContext:(NSManagedObjectContext *)context;

#pragma mark -- query
+ (NSArray*)queryFollowingsWithOwner:(NSString*)owner_id inContext:(NSManagedObjectContext*)context;
+ (NSArray*)queryFollowedWithOwner:(NSString*)owner_id inContext:(NSManagedObjectContext*)context;
+ (NSArray*)queryMutureFriendsWithOwner:(NSString*)owner_id inContext:(NSManagedObjectContext*)context;
@end
