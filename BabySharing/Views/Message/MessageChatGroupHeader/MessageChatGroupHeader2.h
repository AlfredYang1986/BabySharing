//
//  MessageChatGroupHeader2.h
//  BabySharing
//
//  Created by Alfred Yang on 1/26/16.
//  Copyright © 2016 BM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageChatGroupHeader2 : UITableViewHeaderFooterView

+ (CGFloat)preferredHeightWithContent:(NSString*)content;

- (void)setFounderScreenName:(NSString*)name;
- (void)setFounderScreenPhoto:(NSString *)photo;
- (void)setFounderRelations:(NSNumber*)relation;
- (void)setFounderRoleTag:(NSString*)role_tag;

- (void)setChatGroupThemeTitle:(NSString*)title;
//- (void)setCHatGroupJoinerNumber:(NSNumber*)number;

//- (void)setChatGroupUserList:(NSArray*)user_lst;
@end
