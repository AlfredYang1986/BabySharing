//
//  DONNotificationDelegate.h
//  BabySharing
//
//  Created by Alfred Yang on 10/12/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class MessageModel;
@class LoginModel;

@interface DONNotificationDelegate : NSObject <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) UITableView* queryView;

- (void)reloadData;
@end
