//
//  MessageFriendsCell.h
//  BabySharing
//
//  Created by Alfred Yang on 11/12/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelDefines.h"

@protocol MessageFriendsCellDelegate <NSObject>

- (void)didSelectedScreenPhoto:(NSString*)user_id;
- (void)didSelectedRelationBtn:(NSString*)user_id andCurrentRelation:(UserPostOwnerConnections)connections origin:(NSObject *)cell;

@end

@interface MessageFriendsCell : UITableViewCell

@property (nonatomic, setter=setHiddenLine:) BOOL isHiddenLine;
@property (nonatomic, setter=setLineMargin:) CGFloat lineMargin;
@property (nonatomic, setter=setCellHeight:) CGFloat cellHeight;
@property (nonatomic) BOOL isTopLine;

@property (nonatomic, weak) id<MessageFriendsCellDelegate> delegate;
@property (nonatomic, strong) NSString* user_id;
@property (nonatomic, setter=setRelationship:) UserPostOwnerConnections connections;

+ (CGFloat)preferredHeight;

- (void)setUserScreenName:(NSString*)name;
- (void)setUserRoleTag:(NSString*)role_tag;
- (void)setUserScreenPhoto:(NSString*)photo_name;
- (void)setRelationship:(UserPostOwnerConnections)connections;

@end
