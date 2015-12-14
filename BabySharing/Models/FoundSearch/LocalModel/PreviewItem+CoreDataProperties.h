//
//  PreviewItem+CoreDataProperties.h
//  BabySharing
//
//  Created by Alfred Yang on 14/12/2015.
//  Copyright © 2015 BM. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "PreviewItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface PreviewItem (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *type;
@property (nullable, nonatomic, retain) NSManagedObject *content;

@end

NS_ASSUME_NONNULL_END
