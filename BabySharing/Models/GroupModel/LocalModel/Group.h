//
//  Group.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 8/06/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SubGroup;

@interface Group : NSManagedObject

@property (nonatomic, retain) NSDate * group_found_time;
@property (nonatomic, retain) NSString * group_id;
@property (nonatomic, retain) NSString * group_name;
@property (nonatomic, retain) NSSet *subGroups;
@end

@interface Group (CoreDataGeneratedAccessors)

- (void)addSubGroupsObject:(SubGroup *)value;
- (void)removeSubGroupsObject:(SubGroup *)value;
- (void)addSubGroups:(NSSet *)values;
- (void)removeSubGroups:(NSSet *)values;

@end
