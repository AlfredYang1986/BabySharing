//
//  HomeViewController.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 9/01/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ShareSideBaseController.h"
#import "MainHomeViewDataDelegate.h"
#import "QueryCellDelegate.h"

@class Targets;

@interface HomeViewController : ShareSideBaseController <QueryCellActionProtocol> 

@property (weak, nonatomic) NSString* nav_title;
@property (nonatomic) BOOL isPushed;
@property (strong, nonatomic, setter=setDataelegate:) id<HomeViewControllerDataDelegate> delegate;

@property (nonatomic, setter=setCurrentContentIndex:) NSInteger current_index;

- (NSInteger)getShowingIndex:(UITableView*)tableView;
- (void)pushControllerWithTarget:(Targets*)target;
@end
