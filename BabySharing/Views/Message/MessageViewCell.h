//
//  MessageViewCell.h
//  BabySharing
//
//  Created by Alfred Yang on 3/07/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UIBadgeView;

@interface MessageViewCell : UITableViewCell
@property (nonatomic) NSInteger currentIndex;
@property (weak, nonatomic) IBOutlet UIBadgeView *number;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
+ (CGFloat)getPreferredHeight;
@end
