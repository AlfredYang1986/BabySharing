//
//  TagQueryModel.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 20/06/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class AppDelegate;

@interface TagQueryModel : NSObject

@property (strong, nonatomic) UIManagedDocument* doc;
@property (strong, nonatomic) NSArray* querydata;
@property (weak, nonatomic, readonly) AppDelegate* delegate;

#pragma mark -- constractor
- (id)initWithDelegate:(AppDelegate*)app;

#pragma mark -- query content with tags
typedef void(^queryFinishedBlock)(BOOL success);
- (NSArray*)queryTagContentsByUser:(NSString*)user_id withToken:(NSString*)token andTagType:(NSInteger)type andTagName:(NSString*)content withStartIndex:(NSInteger)startIndex finishedBlock:(queryFinishedBlock)block;
- (NSArray*)appendTagContentsByUser:(NSString*)user_id withToken:(NSString*)token andTagType:(NSInteger)type andTagName:(NSString*)content withStartIndex:(NSInteger)startIndex finishedBlock:(queryFinishedBlock)block;
@end
