//
//  QueryLikesCell.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 22/01/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QueryDetailActionDelegate.h"

@class QueryContent;

@interface QueryLikesCell : UITableViewCell
@property (weak, nonatomic) id<QueryDetailActionDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *likesLabel;

- (void)setPhotoNameList:(QueryContent*)current_content;
@end
