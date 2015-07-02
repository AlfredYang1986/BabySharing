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
@property (weak, nonatomic) IBOutlet UILabel *comment_post_date_label;
@property (weak, nonatomic) IBOutlet UILabel *owner_name_label;
@property (weak, nonatomic) IBOutlet UIImageView *owner_photo_view;
@property (weak, nonatomic) IBOutlet UITextView *commentField;
@property (weak, nonatomic) id<QueryDetailActionDelegate> delegate;
@property (weak, nonatomic) QueryComments* current_comments;

- (void)setCommentOwnerImg:(NSString*)name;
@end
