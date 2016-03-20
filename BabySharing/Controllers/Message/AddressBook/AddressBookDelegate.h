//
//  AddressBookDelegate.h
//  BabySharing
//
//  Created by Alfred Yang on 7/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AddingFriendsProtocol.h"
#import "MessageFriendsCell.h"

@interface AddressBookDelegate : NSObject <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, AddingFriendsProtocol, MessageFriendsCellDelegate>

@property (nonatomic, weak) id<AsyncDelegateProtocol> delegate;

- (NSArray*)getAllPhones;
- (void)splitWithFriends:(NSArray*)lst;
@end
