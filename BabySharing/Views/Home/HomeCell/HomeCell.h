//
//  HomeCell.h
//  BabySharing
//
//  Created by monkeyheng on 16/3/10.
//  Copyright © 2016年 BM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeCell : UITableViewCell

@property (nonatomic, strong) UILabel *number;
- (void)updateViewWith:(NSObject *)object;

@end
