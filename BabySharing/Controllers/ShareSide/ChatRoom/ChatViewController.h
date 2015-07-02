//
//  ChatViewController.h
//  ChatModel
//
//  Created by Alfred Yang on 5/05/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Group;
@class SubGroup;

@interface ChatViewController : UIViewController

@property (weak, nonatomic) SubGroup* sub_group;
@property (weak, nonatomic) Group* group;
@end
