//
//  MessageChatGroupHeader.h
//  BabySharing
//
//  Created by Alfred Yang on 20/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoginModel;
@class MessageModel;

@interface MessageChatGroupHeader : UITableViewHeaderFooterView

+ (CGFloat)preferredHeight;

- (void)setFounderScreenName:(NSString*)name;
- (void)setFounderScreenPhoto:(NSString *)photo;
- (void)setFounderRelations:(NSNumber*)relation;
- (void)setFounderRoleTag:(NSString*)role_tag;

- (void)setChatGroupThemeTitle:(NSString*)title;
- (void)setCHatGroupJoinerNumber:(NSNumber*)number;

- (void)setChatGroupUserList:(NSArray*)user_lst;
@end
