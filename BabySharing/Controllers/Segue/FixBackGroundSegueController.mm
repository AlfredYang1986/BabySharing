//
//  FixBackGroundSegueController.m
//  BabySharing
//
//  Created by Alfred Yang on 27/11/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import "FixBackGroundSegueController.h"
#include <vector>
using std::vector;

@interface FixBackGroundSegueController ()

@end

@implementation FixBackGroundSegueController

@synthesize backgroundView = _backgroundView;

//- (vector<std::pair<UIView*, CGPoint>>)animationViewsInController {
- (void *)animationViewsInController {
    vector<std::pair<UIView*, CGPoint>> *arr = new vector<std::pair<UIView*, CGPoint>>();
    for (UIView* iter in self.view.subviews) {
        if (iter != _backgroundView && iter.tag != -1) {
            arr -> push_back(std::make_pair(iter, iter.center));
        }
    }
    return (void *)arr;
}
@end
