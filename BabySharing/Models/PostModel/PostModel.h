//
//  PostModel.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 7/01/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QueryContent;

typedef void(^likeFinishBlock)(BOOL success, QueryContent* content);

@interface PostModel : NSObject

- (BOOL)postJsonContentWithFileName:(NSString *)path withMessage:(NSString *)message;
- (BOOL)postJsonContentWithFileURL:(NSURL*)path withMessage:(NSString *)message;
- (BOOL)postJsonContentToServieWithTags:(NSArray*)tags andDescription:(NSString*)message andPhotos:(NSArray*)photos;

- (QueryContent*)postCommentToServiceWithPostID:(NSString*)post_id andCommentContent:(NSString*)comment_content;

- (QueryContent*)postLikeToServiceWithPostID:(NSString*)post_id;
- (void)postLikeToServiceWithPostID:(NSString*)post_id withFinishBlock:(likeFinishBlock)block;
- (void)postPushToServiceWithPostID:(NSString*)post_id withFinishBlock:(likeFinishBlock)block;
@end
