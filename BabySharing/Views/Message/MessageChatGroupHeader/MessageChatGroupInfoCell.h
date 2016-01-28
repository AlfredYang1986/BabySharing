//
//  MessageChatGroupInfoCell.h
//  BabySharing
//
//  Created by Alfred Yang on 1/28/16.
//  Copyright © 2016 BM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageChatGroupInfoCell : UITableViewCell

+ (CGFloat)preferredHeight;

- (void)setChatGroupJoinerNumber:(NSNumber*)number;
- (void)setChatGroupUserList:(NSArray*)user_lst;
@end
