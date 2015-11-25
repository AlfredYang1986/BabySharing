//
//  HomeCycleSegue.m
//  BabySharing
//
//  Created by Alfred Yang on 25/11/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import "HomeCycleSegue.h"
#import "INTUAnimationEngine.h"
#import "CycleViewController.h"

@implementation HomeCycleSegue

-(void)perform {
    
    UIViewController *src = (UIViewController *) self.sourceViewController;
    CycleViewController *dst = (CycleViewController *) self.destinationViewController;
    UINavigationController* nav = src.navigationController;
    
    UIView* src_view = src.view;
    UIView* dst_view = dst.view;
    
    static const CGFloat kAnimationDuration = 0.5; // in seconds
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    CGRect rc_1 = CGRectMake(0, 0, width, height);
    CGRect rc_2 = CGRectMake(width - 50, 0, width, height);
    
    src_view.frame = rc_1;
    src_view.tag = -99;
    src_view.clipsToBounds = YES;
    dst_view.frame = rc_1;
   
    [nav pushViewController:dst animated:NO];
    [dst_view addSubview:src_view];
    dst.baseController = (id)src;
//    [src_view addSubview:dst_view];
    
    [INTUAnimationEngine animateWithDuration:kAnimationDuration
                                       delay:0.0
                                      easing:INTUEaseInOutQuadratic
                                     options:INTUAnimationOptionNone
                                  animations:^(CGFloat progress) {
                                      src_view.frame = INTUInterpolateCGRect(rc_1, rc_2, progress);
                                  }
                                  completion:^(BOOL finished) {
                                      NSLog(@"%@", finished ? @"Animation Completed" : @"Animation Canceled");
//                                      [nav popViewControllerAnimated:NO];
//                                      [nav pushViewController:dst animated:NO];
//                                      [dst.view removeFromSuperview];
                                      [dst blockTouchEventForOtherViews];
                                  }];
}
@end
