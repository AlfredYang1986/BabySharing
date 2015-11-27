//
//  FixBkgHelper.m
//  BabySharing
//
//  Created by Alfred Yang on 27/11/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import "FixBkgHelper.h"
#import "INTUAnimationEngine.h"

@implementation FixBkgHelper

- (CGPoint)moveLeftFromPoint:(CGPoint)start WithStep:(CGFloat)step InProgress:(CGFloat)progress {
    return INTUInterpolateCGPoint(start, CGPointMake(start.x - step, start.y), progress);
}
@end
