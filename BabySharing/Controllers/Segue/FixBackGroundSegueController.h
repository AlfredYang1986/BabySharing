//
//  FixBackGroundSegueController.h
//  BabySharing
//
//  Created by Alfred Yang on 27/11/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FixBkgHelper.h"

@interface FixBackGroundSegueController : UIViewController

@property (weak, nonatomic) UIImageView* backgroundView;

- (void*)animationViewsInController;
@end
