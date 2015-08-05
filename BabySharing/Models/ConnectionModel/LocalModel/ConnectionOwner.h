//
//  ConnectionOwner.h
//  
//
//  Created by Alfred Yang on 5/08/2015.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Followed, NSManagedObject;

@interface ConnectionOwner : NSManagedObject

@property (nonatomic, retain) NSString * user_id;
@property (nonatomic, retain) NSSet *following;
@property (nonatomic, retain) NSSet *followed;
@end

@interface ConnectionOwner (CoreDataGeneratedAccessors)

- (void)addFollowingObject:(NSManagedObject *)value;
- (void)removeFollowingObject:(NSManagedObject *)value;
- (void)addFollowing:(NSSet *)values;
- (void)removeFollowing:(NSSet *)values;

- (void)addFollowedObject:(Followed *)value;
- (void)removeFollowedObject:(Followed *)value;
- (void)addFollowed:(NSSet *)values;
- (void)removeFollowed:(NSSet *)values;

@end
