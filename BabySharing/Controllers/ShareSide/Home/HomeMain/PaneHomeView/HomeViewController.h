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

@interface HomeViewController : ShareSideBaseController

@property (weak, nonatomic) NSString* nav_title;
@property (nonatomic) BOOL isPushed;
@property (strong, nonatomic) id<HomeViewControllerDataDelegate> delegate;
@end
