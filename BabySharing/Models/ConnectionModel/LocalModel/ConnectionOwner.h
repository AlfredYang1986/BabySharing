//
//  ConnectionOwner.h
//  
//
//  Created by Alfred Yang on 7/08/2015.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Followed, Following, Friends;

@interface ConnectionOwner : NSManagedObject

@property (nonatomic, retain) NSString * user_id;
@property (nonatomic, retain) NSSet *followed;
@property (nonatomic, retain) NSSet *following;
@property (nonatomic, retain) NSSet *friends;
@end

@interface ConnectionOwner (CoreDataGeneratedAccessors)

- (void)addFollowedObject:(Followed *)value;
- (void)removeFollowedObject:(Followed *)value;
- (void)addFollowed:(NSSet *)values;
- (void)removeFollowed:(NSSet *)values;

- (void)addFollowingObject:(Following *)value;
- (void)removeFollowingObject:(Following *)value;
- (void)addFollowing:(NSSet *)values;
- (void)removeFollowing:(NSSet *)values;

- (void)addFriendsObject:(Friends *)value;
- (void)removeFriendsObject:(Friends *)value;
- (void)addFriends:(NSSet *)values;
- (void)removeFriends:(NSSet *)values;

@end
