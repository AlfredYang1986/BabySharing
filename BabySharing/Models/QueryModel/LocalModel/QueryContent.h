//
//  QueryContent.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 14/06/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NSManagedObject, QueryComments, QueryContentItem, QueryLikes;

@interface QueryContent : NSManagedObject

@property (nonatomic, retain) NSNumber * comment_count;
@property (nonatomic, retain) NSNumber * comment_time_span;
@property (nonatomic, retain) NSString * content_description;
@property (nonatomic, retain) NSDate * content_post_date;
@property (nonatomic, retain) NSString * content_post_id;
@property (nonatomic, retain) NSString * content_post_location;
@property (nonatomic, retain) NSString * content_title;
@property (nonatomic, retain) NSNumber * likes_count;
@property (nonatomic, retain) NSNumber * likes_time_span;
@property (nonatomic, retain) NSString * owner_id;
@property (nonatomic, retain) NSString * owner_name;
@property (nonatomic, retain) NSString * owner_photo;
@property (nonatomic, retain) NSSet *comments;
@property (nonatomic, retain) NSSet *items;
@property (nonatomic, retain) NSSet *likes;
@property (nonatomic, retain) NSSet *tags;
@end

@interface QueryContent (CoreDataGeneratedAccessors)

- (void)addCommentsObject:(QueryComments *)value;
- (void)removeCommentsObject:(QueryComments *)value;
- (void)addComments:(NSSet *)values;
- (void)removeComments:(NSSet *)values;

- (void)addItemsObject:(QueryContentItem *)value;
- (void)removeItemsObject:(QueryContentItem *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;

- (void)addLikesObject:(QueryLikes *)value;
- (void)removeLikesObject:(QueryLikes *)value;
- (void)addLikes:(NSSet *)values;
- (void)removeLikes:(NSSet *)values;

- (void)addTagsObject:(NSManagedObject *)value;
- (void)removeTagsObject:(NSManagedObject *)value;
- (void)addTags:(NSSet *)values;
- (void)removeTags:(NSSet *)values;

@end
