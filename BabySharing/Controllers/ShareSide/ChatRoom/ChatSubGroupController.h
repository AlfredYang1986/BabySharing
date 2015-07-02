//
//  ChatSubGroupController.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 7/06/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateChatController.h"

@class Group;

@interface ChatSubGroupController : UIViewController<UITableViewDataSource, UITableViewDelegate, SubGroupOpt>

@property (nonatomic, weak, setter=setGroup:) Group* current_group;
@property (weak, nonatomic) IBOutlet UITableView *subGroupView;

- (void)setGroup:(Group*)g;
@end
