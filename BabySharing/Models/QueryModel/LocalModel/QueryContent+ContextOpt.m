//
//  QueryContent+ContextOpt.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 10/01/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "QueryContent+ContextOpt.h"
#import "QueryContentItem.h"
#import "QueryComments.h"
#import "QueryLikes.h"
#import "QueryTimeSpan.h"
#import "QueryContentTag.h"



@implementation QueryContent (ContextOpt)

#pragma mark -- enum posts
+ (NSArray*)enumLocalQueyDataInContext:(NSManagedObjectContext*)context {
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"QueryContent"];
    
    NSSortDescriptor* des = [NSSortDescriptor sortDescriptorWithKey:@"content_post_date" ascending:NO];
    request.sortDescriptors = [NSArray arrayWithObjects: des, nil];
    
    NSError* error = nil;
    return [context executeFetchRequest:request error:&error];
}

+ (NSArray*)refrashLocalQueryDataInContext:(NSManagedObjectContext*)context withData:(NSArray*)arr andTimeSpan:(long long)time {
    [QueryContent removeAllQueryDataInContext:context];
   
    [QueryContent changeTimeSpan:time inContext:context];
    for (NSDictionary* iter in arr) {
        [QueryContent initWithAttrs:iter inContext:context];
    }
//    [context save:nil];
    
    return [QueryContent enumLocalQueyDataInContext:context];
}

+ (NSArray*)appendLocalQueryDataInContext:(NSManagedObjectContext*)context withData:(NSArray*)arr {
    
    for (NSDictionary* iter in arr) {
        [QueryContent initWithAttrs:iter inContext:context];
    }
//    [context save:nil];
    
    return [QueryContent enumLocalQueyDataInContext:context];
}

+ (QueryContent*)enumQueryContentByPostID:(NSString*)post_id inContext:(NSManagedObjectContext*)context {
    
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"QueryContent"];
    request.predicate = [NSPredicate predicateWithFormat:@"content_post_id = %@", post_id];
    NSSortDescriptor* des = [NSSortDescriptor sortDescriptorWithKey:@"content_post_date" ascending:NO];
    
    request.sortDescriptors = [NSArray arrayWithObjects: des, nil];
    
    NSError* error = nil;
    NSArray* matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || matches.count > 1) {
        NSLog(@"error with primary key");
        return nil;
    } else if (matches.count == 1) {
        return matches.firstObject;
        
    } else {
        NSLog(@"nothing need to be delected");
        return nil;
    }
}

#pragma mark -- remove posts
+ (void)removeAllQueryDataInContext:(NSManagedObjectContext*)context {
    NSArray* currrent = [QueryContent enumLocalQueyDataInContext:context];
    
    for (QueryContent* iter in currrent) {
        
        [QueryContent removeAllItemForContent:iter inContext:context];
        [QueryContent removeAllCommentsForContent:iter inContext:context];
        [QueryContent removeAllLikesForContent:iter inContext:context];
        [context deleteObject:iter];
    }
}

#pragma mark -- init posts
+ (QueryContent*)initWithAttrs:(NSDictionary*)attr inContext:(NSManagedObjectContext*)context {
    
    QueryContent* tmp = [NSEntityDescription insertNewObjectForEntityForName:@"QueryContent" inManagedObjectContext:context];
    tmp.content_title = [attr objectForKey:@"title"];
    tmp.content_description = [attr objectForKey:@"description"];
    tmp.owner_id = [attr objectForKey:@"owner_id"];
    tmp.owner_name = [attr objectForKey:@"owner_name"];
    tmp.owner_photo = [attr objectForKey:@"owner_photo"];
    
    NSNumber* mills = [attr objectForKey:@"date"];
    NSTimeInterval seconds = mills.longLongValue / 1000.0;
    tmp.content_post_date = [NSDate dateWithTimeIntervalSince1970:seconds];
   
    tmp.likes_count = [attr objectForKey:@"likes_count"];
    tmp.comment_count = [attr objectForKey:@"comments_count"];
    tmp.content_post_location = [attr objectForKey:@"location"];
    
    tmp.content_post_id = [attr objectForKey:@"post_id"];
    
    tmp.comment_time_span = [NSNumber numberWithLongLong:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970] * 1000].longLongValue];
    tmp.likes_time_span = tmp.comment_time_span;
    
    tmp.relations = [attr objectForKey:@"relations"];
   
    NSArray* items = [attr objectForKey:@"items"];
    for (NSDictionary* item in items) {
        [QueryContent addOneItemToContent:tmp withAttr:item inContext:context];
    }
    
    NSArray* comments = [attr objectForKey:@"comments"];
    for (NSDictionary* item in comments) {
        [QueryContent addOneCommentToContent:tmp withAttr:item inContext:context];
    }
    
    NSArray* likes = [attr objectForKey:@"likes"];
    for (NSDictionary* item in likes) {
        [QueryContent addOneLikeToContent:tmp withAttr:item inContext:context];
    }
    
    NSArray* tags = [attr objectForKey:@"tags"];
    for (NSDictionary* item in tags) {
        [QueryContent addOneTagToContent:tmp withAttr:item inContext:context];
    }
    
    return tmp;
}

#pragma mark -- save post
+ (void)saveTop:(NSInteger)top inContext:(NSManagedObjectContext*)context {
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"QueryContent"];
    
    NSSortDescriptor* des = [NSSortDescriptor sortDescriptorWithKey:@"content_post_date" ascending:NO];
    request.sortDescriptors = [NSArray arrayWithObjects: des, nil];
    
    NSError* error = nil;
    NSArray* arr = [context executeFetchRequest:request error:&error];
    for (NSInteger index = top; index < arr.count; ++index) {
        
        QueryContent* iter = [arr objectAtIndex:index];
        [QueryContent removeAllItemForContent:iter inContext:context];
        [QueryContent removeAllCommentsForContent:iter inContext:context];
        [QueryContent removeAllLikesForContent:iter inContext:context];
       
        [context deleteObject:iter];
    }
    [context save:nil];
}

#pragma mark -- add a comment to a post
+ (PostCommentsError)checkPostCommentValidataWithPostID:(NSString*)post_id withAttr:(NSDictionary*)comment_attr inContext:(NSManagedObjectContext*)context {
    
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"QueryContent"];
    request.predicate = [NSPredicate predicateWithFormat:@"content_post_id = %@", post_id];
    NSSortDescriptor* des = [NSSortDescriptor sortDescriptorWithKey:@"content_post_date" ascending:NO];
    
    request.sortDescriptors = [NSArray arrayWithObjects: des, nil];
    
    NSError* error = nil;
    NSArray* matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || matches.count > 1) {
        NSLog(@"error with primary key");
        return PostCommentsErrorPostIDNotExisting;
    } else if (matches.count == 1) {
        return PostCommentsErrorNoError;
    } else {
        NSLog(@"nothing need to be delected");
        return PostCommentsErrorPostIDNotExisting;
    }
}

+ (QueryContent*)refreshCommentToPostWithID:(NSString*)post_id withAttrs:(NSArray*)comments_array andTotalCount:(NSNumber*)count inContext:(NSManagedObjectContext*)context {

    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"QueryContent"];
    request.predicate = [NSPredicate predicateWithFormat:@"content_post_id = %@", post_id];
    NSSortDescriptor* des = [NSSortDescriptor sortDescriptorWithKey:@"content_post_date" ascending:NO];
    
    request.sortDescriptors = [NSArray arrayWithObjects: des, nil];
    
    NSError* error = nil;
    NSArray* matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || matches.count > 1) {
        NSLog(@"error with primary key");
        return nil;
    } else if (matches.count == 1) {
        QueryContent* content = matches.firstObject;
        content.comment_count = count;
        [QueryContent removeAllCommentsForContent:content inContext:context];
        for (NSDictionary* attr in comments_array) {
            [QueryContent addOneCommentToContent:content withAttr:attr inContext:context];
        }
        return content;
    } else {
        NSLog(@"nothing need to be delected");
        return nil;
    }
}

+ (QueryContent*)appendCommentToPostWithID:(NSString*)post_id withAttrs:(NSArray*)comments_array andTotalCount:(NSNumber*)count inContext:(NSManagedObjectContext*)context {

    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"QueryContent"];
    request.predicate = [NSPredicate predicateWithFormat:@"content_post_id = %@", post_id];
    NSSortDescriptor* des = [NSSortDescriptor sortDescriptorWithKey:@"content_post_date" ascending:NO];
    
    request.sortDescriptors = [NSArray arrayWithObjects: des, nil];
    
    NSError* error = nil;
    NSArray* matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || matches.count > 1) {
        NSLog(@"error with primary key");
        return nil;
    } else if (matches.count == 1) {
        QueryContent* content = matches.firstObject;
        content.comment_count = count;
        for (NSDictionary* attr in comments_array) {
            [QueryContent addOneCommentToContent:content withAttr:attr inContext:context];
        }
        return content;
    } else {
        NSLog(@"nothing need to be delected");
        return nil;
    }
}

#pragma mark -- like a post
+ (PostLikesError)checkPostLikeValidataWithPostID:(NSString*)post_id withAttr:(NSDictionary*)comment_attr inContext:(NSManagedObjectContext*)context {
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"QueryContent"];
    request.predicate = [NSPredicate predicateWithFormat:@"content_post_id = %@", post_id];
    NSSortDescriptor* des = [NSSortDescriptor sortDescriptorWithKey:@"content_post_date" ascending:NO];
    
    request.sortDescriptors = [NSArray arrayWithObjects: des, nil];
    
    NSError* error = nil;
    NSArray* matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || matches.count > 1) {
        NSLog(@"error with primary key");
        return PostLikesErrorPostIDNotExisting;
    } else if (matches.count == 1) {
        return PostLikesErrorNoError;
    } else {
        NSLog(@"nothing need to be delected");
        return PostLikesErrorPostIDNotExisting;
    }
}

+ (void)likePostWithID:(NSString*)post_id withAttr:(NSDictionary*)like_attr inContext:(NSManagedObjectContext*)context {

}

#pragma mark -- private op tags
+ (void)addOneTagToContent:(QueryContent*)content withAttr:(NSDictionary*)tag_attr inContext:(NSManagedObjectContext*)context {
    QueryContentTag* tmp_tag = [NSEntityDescription insertNewObjectForEntityForName:@"QueryContentTag" inManagedObjectContext:context];
    
    tmp_tag.tag_type = [tag_attr objectForKey:@"type"];
    tmp_tag.tag_content = [tag_attr objectForKey:@"content"];
    tmp_tag.tag_offset_x = [tag_attr objectForKey:@"offsetX"];
    tmp_tag.tag_offset_y = [tag_attr objectForKey:@"offsetY"];
    
    [content addTagsObject:tmp_tag];
}

+ (void)removeAllTagsForContent:(QueryContent*)content inContext:(NSManagedObjectContext*)context {
    
    while (content.tags.count != 0) {
        QueryContentTag* tag = [content.tags.objectEnumerator nextObject];
        [content removeTagsObject:tag];
        [context deleteObject:tag];
    }
}

#pragma martk -- private op comment
+ (void)addOneCommentToContent:(QueryContent*)content withAttr:(NSDictionary*)comment_attr inContext:(NSManagedObjectContext*)context {

    QueryComments* tmp_comment = [NSEntityDescription insertNewObjectForEntityForName:@"QueryComments" inManagedObjectContext:context];
    tmp_comment.comment_owner_id = [comment_attr objectForKey:@"comment_owner_id"];
    tmp_comment.comment_owner_name = [comment_attr objectForKey:@"comment_owner_name"];
    tmp_comment.comment_owner_photo = [comment_attr objectForKey:@"comment_owner_photo"];
    
    NSNumber* mills = [comment_attr objectForKey:@"comment_date"];
    NSTimeInterval seconds = mills.longLongValue / 1000.0;
    tmp_comment.comment_date = [NSDate dateWithTimeIntervalSince1970:seconds];
    
    tmp_comment.comment_content = [comment_attr objectForKey:@"comment_content"];
    
    [content addCommentsObject:tmp_comment];
}

+ (void)removeAllCommentsForContent:(QueryContent*)content inContext:(NSManagedObjectContext*)context {
   
    while (content.comments.count != 0) {
        QueryComments* item = [content.comments.objectEnumerator nextObject];
        [content removeCommentsObject:item];
        [context deleteObject:item];
    }
}

#pragma mark -- private op likes
+ (void)addOneLikeToContent:(QueryContent*)content withAttr:(NSDictionary*)like_attr inContext:(NSManagedObjectContext*)context {

    QueryLikes* tmp_like = [NSEntityDescription insertNewObjectForEntityForName:@"QueryLikes" inManagedObjectContext:context];
    tmp_like.like_owner_id = [like_attr objectForKey:@"like_owner_id"];
    tmp_like.like_owner_name = [like_attr objectForKey:@"like_owner_name"];
    tmp_like.like_owner_photo = [like_attr objectForKey:@"like_owner_photo"];
        
    NSNumber* mills = [like_attr objectForKey:@"like_date"];
    NSTimeInterval seconds = mills.longLongValue / 1000.0;
    tmp_like.like_date = [NSDate dateWithTimeIntervalSince1970:seconds];
        
    [content addLikesObject:tmp_like];
}

+ (void)removeAllLikesForContent:(QueryContent*)content inContext:(NSManagedObjectContext*)context {
   
    while (content.likes.count != 0) {
        QueryLikes* item = [content.likes.objectEnumerator nextObject];
        [content removeLikesObject:item];
        [context deleteObject:item];
    }
}

#pragma mark -- private op items
+ (void)addOneItemToContent:(QueryContent*)content withAttr:(NSDictionary*)item_attr inContext:(NSManagedObjectContext*)context {

    QueryContentItem* tmp_item = [NSEntityDescription insertNewObjectForEntityForName:@"QueryContentItem" inManagedObjectContext:context];
    tmp_item.item_type = [item_attr objectForKey:@"type"];
    tmp_item.item_name = [item_attr objectForKey:@"name"];
    
    [content addItemsObject:tmp_item];
}

+ (void)removeAllItemForContent:(QueryContent*)content inContext:(NSManagedObjectContext*)context {
    
    while (content.items.count != 0) {
        QueryContentItem* item = [content.items.objectEnumerator nextObject];
        [content removeItemsObject:item];
        [context deleteObject:item];
    }
}

#pragma mark -- query content time span
+ (void)changeTimeSpan:(long long)time inContext:(NSManagedObjectContext*)context {
    
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"QueryTimeSpan"];
    
    NSError* error = nil;
    NSArray* matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || matches.count > 1) {
        NSLog(@"error with primary key");
    } else if (matches.count == 1) {
        NSLog(@"time span %@", ((NSNumber*)matches.firstObject));
        NSLog(@"change time span");
        QueryTimeSpan* tmp = [matches firstObject];
        tmp.content_time_span = [NSNumber numberWithLongLong:time];
        
    } else {
        NSLog(@"nothing time span, add time span");
        QueryTimeSpan* tmp = [NSEntityDescription insertNewObjectForEntityForName:@"QueryTimeSpan" inManagedObjectContext:context];
        tmp.content_time_span = [NSNumber numberWithLongLong:time];
    }
}

+ (NSNumber*)enumContentTimeSpanInContext:(NSManagedObjectContext*)context {
    
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"QueryTimeSpan"];
    
    NSError* error = nil;
    NSArray* matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || matches.count > 1) {
        NSLog(@"error with primary key");
        return nil;
    } else if (matches.count == 1) {
        NSLog(@"time span %@", ((NSNumber*)matches.firstObject));
        NSLog(@"change time span");
        QueryTimeSpan* tmp = [matches firstObject];
        return tmp.content_time_span;
        
    } else {
        NSLog(@"nothing time span, add time span");
        return nil;
    }
}

+ (NSNumber*)enumCommentTimeSpanInContext:(NSManagedObjectContext*)context andPostID:(NSString*)post_id {
    
    QueryContent* content = [QueryContent enumQueryContentByPostID:post_id inContext:context];
    return content.comment_time_span;
}

#pragma mark -- query comment time span
+ (void)changeCommentTimeSpan:(NSNumber*)time forPostID:(NSString*)post_id inContext:(NSManagedObjectContext*)context {
    
    QueryContent* content = [QueryContent enumQueryContentByPostID:post_id inContext:context];
    content.comment_time_span = time;
}

#pragma mark -- query relations between owner and current user
+ (UserPostOwnerConnections)queryRelationsWithPost:(NSString*)post_id inContext:(NSManagedObjectContext*)context {
    
    QueryContent* content = [QueryContent enumQueryContentByPostID:post_id inContext:context];
    return (UserPostOwnerConnections)content.relations.integerValue;
}

+ (void)refreshRelationsWithPost:(NSString*)post_id withConnections:(UserPostOwnerConnections)relation inContext:(NSManagedObjectContext*)context {
    QueryContent* content = [QueryContent enumQueryContentByPostID:post_id inContext:context];
    content.relations = [NSNumber numberWithInt:relation];
}
@end