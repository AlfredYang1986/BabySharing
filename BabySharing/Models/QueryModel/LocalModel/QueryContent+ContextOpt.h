//
//  QueryContent+ContextOpt.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 10/01/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QueryContent.h"

typedef NS_ENUM(NSInteger, PostCommentsError) {
    PostCommentsErrorNoError,
    PostCommentsErrorPostIDNotExisting,
};

typedef NS_ENUM(NSInteger, PostLikesError) {
    PostLikesErrorNoError,
    PostLikesErrorPostIDNotExisting,
};

@interface QueryContent (ContextOpt)

#pragma mark -- enum posts
+ (NSArray*)enumLocalQueyDataInContext:(NSManagedObjectContext*)context;
+ (NSArray*)refrashLocalQueryDataInContext:(NSManagedObjectContext*)context withData:(NSArray*)arr andTimeSpan:(long long)time;
+ (NSArray*)appendLocalQueryDataInContext:(NSManagedObjectContext*)context withData:(NSArray*)arr;
+ (QueryContent*)enumQueryContentByPostID:(NSString*)post_id inContext:(NSManagedObjectContext*)context;

#pragma mark -- remove posts
+ (void)removeAllQueryDataInContext:(NSManagedObjectContext*)context;

#pragma mark -- init posts
+ (QueryContent*)initWithAttrs:(NSDictionary*)attr inContext:(NSManagedObjectContext*)context;

#pragma mark -- save post
+ (void)saveTop:(NSInteger)top inContext:(NSManagedObjectContext*)context;

#pragma mark -- add a comment to a post
/**
 * check local first
 * if validate post to service
 * if post success, add to local database
 */
+ (PostCommentsError)checkPostCommentValidataWithPostID:(NSString*)post_id withAttr:(NSDictionary*)comment_attr inContext:(NSManagedObjectContext*)context;
+ (QueryContent*)refreshCommentToPostWithID:(NSString*)post_id withAttrs:(NSArray*)comments_array andTotalCount:(NSNumber*)count inContext:(NSManagedObjectContext*)context;
+ (QueryContent*)appendCommentToPostWithID:(NSString*)post_id withAttrs:(NSArray*)comments_array andTotalCount:(NSNumber*)count inContext:(NSManagedObjectContext*)context;

#pragma mark -- like a post
/**
 * check local first
 * if validate post to service
 * if post success, add to local database
 */
+ (PostLikesError)checkPostLikeValidataWithPostID:(NSString*)post_id withAttr:(NSDictionary*)comment_attr inContext:(NSManagedObjectContext*)context;
+ (void)likePostWithID:(NSString*)post_id withAttr:(NSDictionary*)like_attr inContext:(NSManagedObjectContext*)context;

#pragma mark -- query content time span
+ (void)changeTimeSpan:(long long)time inContext:(NSManagedObjectContext*)context;
+ (NSNumber*)enumContentTimeSpanInContext:(NSManagedObjectContext*)context;
+ (NSNumber*)enumCommentTimeSpanInContext:(NSManagedObjectContext*)context andPostID:(NSString*)post_id;

#pragma mark -- query comment time span
+ (void)changeCommentTimeSpan:(NSNumber*)time forPostID:(NSString*)post_id inContext:(NSManagedObjectContext*)context;
@end