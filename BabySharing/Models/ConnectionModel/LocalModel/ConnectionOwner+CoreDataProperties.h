//
//  ConnectionOwner+CoreDataProperties.h
//  BabySharing
//
//  Created by Alfred Yang on 2/23/16.
//  Copyright © 2016 BM. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ConnectionOwner.h"

NS_ASSUME_NONNULL_BEGIN

@interface ConnectionOwner (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *user_id;
@property (nullable, nonatomic, retain) NSSet<Followed *> *followed;
@property (nullable, nonatomic, retain) NSSet<Following *> *following;
@property (nullable, nonatomic, retain) NSSet<Friends *> *friends;

@end

@interface ConnectionOwner (CoreDataGeneratedAccessors)

- (void)addFollowedObject:(Followed *)value;
- (void)removeFollowedObject:(Followed *)value;
- (void)addFollowed:(NSSet<Followed *> *)values;
- (void)removeFollowed:(NSSet<Followed *> *)values;

- (void)addFollowingObject:(Following *)value;
- (void)removeFollowingObject:(Following *)value;
- (void)addFollowing:(NSSet<Following *> *)values;
- (void)removeFollowing:(NSSet<Following *> *)values;

- (void)addFriendsObject:(Friends *)value;
- (void)removeFriendsObject:(Friends *)value;
- (void)addFriends:(NSSet<Friends *> *)values;
- (void)removeFriends:(NSSet<Friends *> *)values;

@end

NS_ASSUME_NONNULL_END
