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

@interface ChatMessageCell : UITableViewCell

@property (nonatomic, weak, setter=setGotyeOCMessage:) GotyeOCMessage* message;
@property (nonatomic, weak) LoginModel* lm;

+ (CGFloat)preferredHeightWithInputText:(NSString*)content;

- (void)setGotyeOCMessage:(GotyeOCMessage*)msg;
@end
