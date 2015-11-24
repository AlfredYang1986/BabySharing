//
//  HomeViewTableCellDelelage.h
//  BabySharing
//
//  Created by Alfred Yang on 23/11/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MainHomeViewDataDelegate.h"

@class MoviePlayTrait;
@class HomeViewController;

@interface HomeViewTableCellDelegate : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) id<HomeViewControllerDataDelegate> delegate;
@property (weak, nonatomic) MoviePlayTrait* trait;
@property (weak, nonatomic) HomeViewController* controller;

@property (nonatomic) NSInteger current_index;
@end
