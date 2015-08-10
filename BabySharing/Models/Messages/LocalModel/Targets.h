//
//  Targets.h
//  
//
//  Created by Alfred Yang on 10/08/2015.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Messages, NotificationOwner;

@interface Targets : NSManagedObject

@property (nonatomic, retain) NSDate * last_time;
@property (nonatomic, retain) NSString * target_id;
@property (nonatomic, retain) NSNumber * target_type;
@property (nonatomic, retain) NSString * target_photo;
@property (nonatomic, retain) NSString * target_name;
@property (nonatomic, retain) NotificationOwner *chatFrom;
@property (nonatomic, retain) NSSet *messages;
@end

@interface Targets (CoreDataGeneratedAccessors)

- (void)addMessagesObject:(Messages *)value;
- (void)removeMessagesObject:(Messages *)value;
- (void)addMessages:(NSSet *)values;
- (void)removeMessages:(NSSet *)values;

@end
