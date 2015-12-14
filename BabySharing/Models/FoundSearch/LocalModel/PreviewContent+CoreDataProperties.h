//
//  PreviewContent+CoreDataProperties.h
//  BabySharing
//
//  Created by Alfred Yang on 14/12/2015.
//  Copyright © 2015 BM. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "PreviewContent.h"

NS_ASSUME_NONNULL_BEGIN

@interface PreviewContent (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *post_id;
@property (nullable, nonatomic, retain) PreviewTag *tag;
@property (nullable, nonatomic, retain) NSSet<PreviewItem *> *items;

@end

@interface PreviewContent (CoreDataGeneratedAccessors)

- (void)addItemsObject:(PreviewItem *)value;
- (void)removeItemsObject:(PreviewItem *)value;
- (void)addItems:(NSSet<PreviewItem *> *)values;
- (void)removeItems:(NSSet<PreviewItem *> *)values;

@end

NS_ASSUME_NONNULL_END
