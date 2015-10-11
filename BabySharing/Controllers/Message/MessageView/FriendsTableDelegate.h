//
//  FriendsTableDelegate.h
//  BabySharing
//
//  Created by Alfred Yang on 4/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FriendsTableDelegate : NSObject <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView* queryView;
@property (nonatomic, weak) UIViewController* current;

- (void)refreshShowingListWithUserList:(NSArray*)user_lst;
- (void)filterDataWithPredicate:(NSPredicate*)pred;
@end
