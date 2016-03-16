//
//  showContentSegue.m
//  BabySharing
//
//  Created by Alfred Yang on 3/16/16.
//  Copyright © 2016 BM. All rights reserved.
//

#import "showContentSegue.h"

@implementation showContentSegue

-(void)perform {
    UIViewController* src = self.sourceViewController;
    UIViewController* dst = self.destinationViewController;
   
    [UIView transitionFromView:src.view toView:dst.view duration:0.4f options:UIViewAnimationOptionTransitionCrossDissolve completion:^(BOOL finished) {
        [src presentViewController:dst animated:NO completion:^{
            NSLog(@"show content segue");
        }];
    }];
}

@end
