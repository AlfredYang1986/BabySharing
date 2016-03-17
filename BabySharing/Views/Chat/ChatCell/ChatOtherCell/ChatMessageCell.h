//
//  ChatViewCell.h
//  BabySharing
//
//  Created by Alfred Yang on 12/10/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GotyeOCMessage;
@class LoginModel;

@protocol ChatMessageCellDelegate <NSObject>

- (void)didSelectedScreenPhotoForUserID:(NSString*)user_id;
@end

@interface ChatMessageCell : UITableViewCell

@property (nonatomic, weak, setter=setGotyeOCMessage:) GotyeOCMessage* message;
@property (nonatomic, weak) LoginModel* lm;
@property (nonatomic, weak) id<ChatMessageCellDelegate> delegate;

+ (CGFloat)preferredHeightWithInputText:(NSString*)content andSenderID:(NSString*)sender_user_id;

- (void)setGotyeOCMessage:(GotyeOCMessage*)msg;
@end
