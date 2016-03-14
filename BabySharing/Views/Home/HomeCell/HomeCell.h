//
//  HomeCell.h
//  BabySharing
//
//  Created by monkeyheng on 16/3/10.
//  Copyright © 2016年 BM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QueryContent.h"
#import "QueryCellDelegate.h"

@interface HomeCell : UITableViewCell

@property (nonatomic, strong) UILabel *number;
@property (nonatomic, strong) id<QueryCellActionProtocol> delegate;
- (void)stopViedo;
- (void)updateViewWith:(QueryContent *)content;

@end
