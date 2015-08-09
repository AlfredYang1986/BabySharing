//
//  DDNNotificationViewController.h
//  BabySharing
//
//  Created by Alfred Yang on 9/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MessageModel;
@class LoginModel;

@interface DDNNotificationViewController : UIViewController
@property (nonatomic, weak) MessageModel* mm;
@property (nonatomic, weak) LoginModel* lm;
@end
