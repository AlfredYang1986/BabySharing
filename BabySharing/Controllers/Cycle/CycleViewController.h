//
//  CycleViewController.h
//  BabySharing
//
//  Created by Alfred Yang on 12/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeViewController;

@interface CycleViewController : UIViewController

- (void)blockTouchEventForOtherViews;

@property (weak, nonatomic) HomeViewController* baseController;

@end
