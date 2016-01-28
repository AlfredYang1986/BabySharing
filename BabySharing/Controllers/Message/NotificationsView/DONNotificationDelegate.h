//
//  DONNotificationDelegate.h
//  BabySharing
//
//  Created by Alfred Yang on 10/12/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MessageNotificationDetailCell.h"

@class MessageModel;
@class LoginModel;

@interface DONNotificationDelegate : NSObject <UITableViewDelegate, UITableViewDataSource, MessageNotificationCellDelegate>
@property (weak, nonatomic) UITableView* queryView;
@property (weak, nonatomic) UIViewController* controller;

- (void)reloadData;
@end
