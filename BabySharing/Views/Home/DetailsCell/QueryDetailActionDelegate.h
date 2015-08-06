//
//  QueryDetailActionDelegate.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 12/01/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#ifndef YYBabyAndMother_QueryDetailActionDelegate_h
#define YYBabyAndMother_QueryDetailActionDelegate_h

#import <Foundation/Foundation.h>

@class QueryOwnerCell;

@protocol QueryDetailActionDelegate <NSObject>

#pragma mark -- image cell
- (void)didSelectDetialImageTagsWithContents:(NSString*)tag_name;

#pragma mark -- owner cell
- (void)didSelectDetialFollowOwner:(QueryOwnerCell*)cell;
- (void)didSelectDetialOwnerNameOrImage:(NSString*)owner_id;

#pragma mark -- like cell
- (void)didSelectDetialLikeBtn;

#pragma mark -- comment cell
- (void)didSelectDetialCommentDetailWithIndex:(NSInteger)index;
- (void)didSelectDetialMoreComments;

#pragma mark -- tags actions
- (void)didSelectTagWithType:(NSInteger)type andName:(NSString*)name;
@end

#endif
