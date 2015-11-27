//
//  LandingNextSegue.m
//  BabySharing
//
//  Created by Alfred Yang on 27/11/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import "LandingNextSegue.h"
#import "INTUAnimationEngine.h"
#import "FixBackGroundSegueController.h"

#include <vector>
#include <iterator>
using std::vector;
using std::iterator;

@implementation LandingNextSegue

-(void)perform {

    FixBkgHelper* helper = [[FixBkgHelper alloc]init];
    
    FixBackGroundSegueController* src = (FixBackGroundSegueController*) self.sourceViewController;
    FixBackGroundSegueController* dst = (FixBackGroundSegueController*) self.destinationViewController;
    UINavigationController* nav = src.navigationController;
   
    vector<std::pair<UIView*, CGPoint>> * src_views = (vector<std::pair<UIView*, CGPoint>>*)[src animationViewsInController];
    vector<std::pair<UIView*, CGPoint>> * dst_views = (vector<std::pair<UIView*, CGPoint>>*)[dst animationViewsInController];
    
    UIView* base_view = dst.view;
   
    static const CGFloat kAnimationDuration = 0.8f; // in seconds
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    [nav pushViewController:dst animated:NO];

    for (vector<std::pair<UIView*, CGPoint>>::iterator iter = src_views->begin(); iter != src_views->end(); ++iter) {
        [base_view addSubview:(*iter).first];
    }

    [INTUAnimationEngine animateWithDuration:kAnimationDuration
                                       delay:0.0
                                      easing:INTUEaseInOutQuadratic
                                     options:INTUAnimationOptionNone
                                  animations:^(CGFloat progress) {
                                      
                                      for (vector<std::pair<UIView*, CGPoint>>::iterator iter = src_views->begin(); iter != src_views->end(); ++iter) {
                                          UIView* tmp = (UIView*)(*iter).first;
                                          CGPoint start = (CGPoint)(*iter).second;
                                          tmp.center = [helper moveLeftFromPoint:start WithStep:width InProgress:progress];
                                      }
                                      
                                      for (vector<std::pair<UIView*, CGPoint>>::iterator iter = dst_views->begin(); iter != dst_views->end(); ++iter) {
                                          UIView* tmp = (UIView*)(*iter).first;
                                          CGPoint start = CGPointMake((*iter).second.x + width, (*iter).second.y);
                                          tmp.center = [helper moveLeftFromPoint:start WithStep:width InProgress:progress];
                                      }
                                  }
                                  completion:^(BOOL finished) {
                                      NSLog(@"%@", finished ? @"Animation Completed" : @"Animation Canceled");
                                      // [nav popViewControllerAnimated:NO];
                                      // [nav pushViewController:dst animated:NO];
                                      // [dst.view removeFromSuperview];
                                      for (vector<std::pair<UIView*, CGPoint>>::iterator iter = src_views->begin(); iter != src_views->end(); ++iter) {
                                          [(*iter).first removeFromSuperview];
                                          (*iter).first.center = (*iter).second;
                                          [src.view addSubview:(*iter).first];
                                      }
                                  }];
}
@end
