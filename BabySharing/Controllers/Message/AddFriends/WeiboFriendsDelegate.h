//
//  WeiboFriendsDelegate.h
//  BabySharing
//
//  Created by Alfred Yang on 3/09/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AddingFriendsProtocol.h"

@interface WeiboFriendsDelegate : NSObject <UITableViewDelegate, UITableViewDataSource, AddingFriendsProtocol>

@property (nonatomic, weak) id<AsyncDelegateProtocol> delegate;
@end
