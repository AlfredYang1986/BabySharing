//
//  MessageViewCell.h
//  BabySharing
//
//  Created by Alfred Yang on 3/07/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageViewCell : UITableViewCell
@property (nonatomic) NSInteger currentIndex;
+ (CGFloat)getPreferredHeight;
@end