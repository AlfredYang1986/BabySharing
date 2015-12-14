//
//  RecommandTag+CoreDataProperties.h
//  BabySharing
//
//  Created by Alfred Yang on 14/12/2015.
//  Copyright © 2015 BM. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "RecommandTag.h"

NS_ASSUME_NONNULL_BEGIN

@interface RecommandTag (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *tag_name;
@property (nullable, nonatomic, retain) NSNumber *tag_type;

@end

NS_ASSUME_NONNULL_END
