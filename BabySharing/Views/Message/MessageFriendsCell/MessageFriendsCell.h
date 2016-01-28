//
//  MessageFriendsCell.h
//  BabySharing
//
//  Created by Alfred Yang on 11/12/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelDefines.h"

@interface MessageFriendsCell : UITableViewCell

@property (nonatomic, setter=setHiddenLine:) BOOL isHiddenLine;
@property (nonatomic, setter=setCellHeight:) CGFloat cellHeight;

+ (CGFloat)preferredHeight;

- (void)setUserScreenName:(NSString*)name;
- (void)setUserRoleTag:(NSString*)role_tag;
- (void)setUserScreenPhoto:(NSString*)photo_name;
- (void)setRelationship:(UserPostOwnerConnections)connections;
@end
