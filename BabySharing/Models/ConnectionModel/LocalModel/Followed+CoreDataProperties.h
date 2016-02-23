//
//  Followed+CoreDataProperties.h
//  BabySharing
//
//  Created by Alfred Yang on 2/23/16.
//  Copyright © 2016 BM. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Followed.h"

NS_ASSUME_NONNULL_BEGIN

@interface Followed (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *user_id;
@property (nullable, nonatomic, retain) NSNumber *relations;
@property (nullable, nonatomic, retain) ConnectionOwner *followedBy;

@end

NS_ASSUME_NONNULL_END
