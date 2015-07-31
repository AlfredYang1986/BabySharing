//
//  QueryCommonsCell.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 12/01/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QueryDetailActionDelegate.h"

@class QueryComments;

@interface QueryCommentsCell : UITableViewCell

@property (weak, nonatomic) id<QueryDetailActionDelegate> delegate;
@property (weak, nonatomic) QueryComments* current_comments;

+ (CGFloat)preferredHeightWithComment:(NSString*)comment;

- (void)setTime:(NSDate*)date;
- (void)setTags:(NSString*)tags;
- (void)setComments:(NSString*)comments;
- (void)setCommentOwnerName:(NSString*)name;
- (void)setCommentOwnerPhoto:(NSString*)photo;
@end
