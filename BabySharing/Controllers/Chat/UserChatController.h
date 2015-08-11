//
//  UserChatController.h
//  BabySharing
//
//  Created by Alfred Yang on 11/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LoginModel.h"
#import "MessageModel.h"

@interface UserChatController : UIViewController

@property (nonatomic, strong) NSString* chat_user_id;
@property (nonatomic, strong) NSString* chat_user_name;
@property (nonatomic, strong) NSString* chat_user_photo;

@property (nonatomic, weak) LoginModel* lm;
@property (nonatomic, weak) MessageModel* mm;

@property (weak, nonatomic) IBOutlet UITableView *queryView;
@end
