//
//  QueryModel.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 9/01/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class AppDelegate;
@class QueryContent;

@interface QueryModel : NSObject

@property (strong, nonatomic) UIManagedDocument* doc;
@property (strong, nonatomic, readonly) NSArray* querydata;

@property (weak, nonatomic, readonly) AppDelegate* delegate;

#pragma mark -- constractor
- (id)initWithDelegate:(AppDelegate*)app;

#pragma mark -- home query operation
- (void)refreshQueryDataByUser:(NSString*)user_id withToken:(NSString*)token;
typedef void(^queryDataFinishBlock)(void);
- (void)refreshQueryDataByUser:(NSString*)user_id withToken:(NSString*)token withFinishBlock:(queryDataFinishBlock)block;
- (void)appendQueryDataByUser:(NSString*)user_id withToken:(NSString*)token andBeginIndex:(NSInteger)skip;

#pragma mark -- save content
- (void)saveTop:(NSInteger)top;

#pragma mark -- comments query operation
- (QueryContent*)refreshCommentsByUser:(NSString*)user_id withToken:(NSString*)token andPostID:(NSString*)post_id;
- (QueryContent*)appendCommentsByUser:(NSString*)user_id withToken:(NSString*)token andBeginIndex:(NSInteger)skip andPostID:(NSString*)post_id;
@end
