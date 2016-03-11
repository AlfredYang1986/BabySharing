//
//  ChatGroupController.h
//  BabySharing
//
//  Created by Alfred Yang on 19/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoginModel;
@class MessageModel;

@interface ChatGroupController : UIViewController
@property (strong, nonatomic) NSString* founder_id;
@property (strong, nonatomic) NSString* group_name;
@property (strong, nonatomic, setter=resetGroupID:) NSNumber* group_id;
@property (strong, nonatomic) NSNumber* joiner_count;
@property (weak, nonatomic, readonly) LoginModel* lm;
@property (weak, nonatomic, readonly) MessageModel* mm;
@end
