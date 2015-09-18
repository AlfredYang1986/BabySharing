//
//  CommentsHeaderAndFooterCell.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 12/01/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QueryDetailActionDelegate.h"

typedef NS_ENUM(NSInteger, CommentsHeaderAndFooterStates) {
    CommentsHeaderAndFooterStatesHeader,
    CommentsHeaderAndFooterStatesFooter,
};

@interface CommentsHeaderAndFooterCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) id<QueryDetailActionDelegate> delegate;
@property (nonatomic) CommentsHeaderAndFooterStates state;
@end
