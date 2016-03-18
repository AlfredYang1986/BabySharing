//
//  QueryContent.h
//  
//
//  Created by Alfred Yang on 6/08/2015.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@class QueryComments, QueryContentItem, QueryContentTag, QueryLikes, QueryContentChaters;

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
@property (nonatomic, retain) NSString * owner_role;
@property (nonatomic, retain) NSNumber * relations;
@property (nonatomic, retain) NSSet *comments;
@property (nonatomic, retain) NSSet *items;
@property (nonatomic, retain) NSSet *likes;
@property (nonatomic, retain) NSSet *tags;
@property (nonatomic, retain) NSSet *chaters;

@property (nonatomic, retain) NSNumber *isLike;
@property (nonatomic, retain) NSNumber *isPush;
@property (nonatomic, retain) NSNumber *group_chat_count;

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

- (void)addTagsObject:(QueryContentTag *)value;
- (void)removeTagsObject:(QueryContentTag *)value;
- (void)addTags:(NSSet *)values;
- (void)removeTags:(NSSet *)values;

- (void)addChatersObject:(QueryContentChaters *)value;
- (void)removeChatersObject:(QueryContentChaters *)value;
- (void)addChaters:(NSSet<QueryContentChaters *> *)values;
- (void)removeChaters:(NSSet<QueryContentChaters *> *)values;


@end
