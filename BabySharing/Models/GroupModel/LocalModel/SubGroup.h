//
//  SubGroup.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 8/06/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Group, Messages;

@interface SubGroup : NSManagedObject

@property (nonatomic, retain) NSDate * sub_group_found_time;
@property (nonatomic, retain) NSString * sub_group_id;
@property (nonatomic, retain) NSString * sub_group_name;
@property (nonatomic, retain) NSDate * sub_group_update_time;
@property (nonatomic, retain) Group *group;
@property (nonatomic, retain) NSSet *messages;
@end

@interface SubGroup (CoreDataGeneratedAccessors)

- (void)addMessagesObject:(Messages *)value;
- (void)removeMessagesObject:(Messages *)value;
- (void)addMessages:(NSSet *)values;
- (void)removeMessages:(NSSet *)values;

@end
