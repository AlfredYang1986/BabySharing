//
//  MovingButton.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 1/06/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "MovingButton.h"
#import "INTUAnimationEngine.h"

#define BUTTON_WIDTH    60
#define BUTTON_HEIGHT   60

@implementation MovingButton {

}

@synthesize origin_pos = _origin_pos;
@synthesize target_pos = _target_pos;
@synthesize rotate_angle = _rotate_angle;
@synthesize isMoved = _isMoved;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithOrigin:(CGPoint)origin andFinal:(CGPoint)target andRangle:(CGFloat)angle {
    self = [super init];
    if (self) {
        _origin_pos= origin;
        _target_pos = target;
        _rotate_angle = angle;
        _isMoved = NO;
        self.bounds = CGRectMake(0, 0, BUTTON_WIDTH, BUTTON_HEIGHT);
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.6];
        self.layer.cornerRadius = 30.0;//（该值到一定的程度，就为圆形了。）
        self.layer.borderWidth = 1.0;
        self.layer.borderColor =[UIColor clearColor].CGColor;
        self.clipsToBounds = TRUE;//去除边界
    }
    
    return self;
}

- (void)resetPos {
    self.frame = CGRectMake(_origin_pos.x, _origin_pos.y, BUTTON_WIDTH, BUTTON_HEIGHT);
    self.bounds = CGRectMake(0, 0, BUTTON_WIDTH, BUTTON_HEIGHT);
    _isMoved = NO;
}

- (void)moveWithFinishBlock:(movingFinished)block {
    static const CGFloat kAnimationDuration = 0.3; // in seconds
    [INTUAnimationEngine animateWithDuration:kAnimationDuration
                                       delay:0.0
                                      easing:INTUEaseInOutQuadratic
                                     options:INTUAnimationOptionNone
                                  animations:^(CGFloat progress) {
                                      if (!_isMoved) {
                                          self.center = INTUInterpolateCGPoint(_origin_pos, _target_pos, progress);
                                          CGFloat rotationAngle = INTUInterpolateCGFloat(0, _rotate_angle, progress);
                                          self.transform = CGAffineTransformMakeRotation(rotationAngle);
                                      } else {
                                          self.center = INTUInterpolateCGPoint(_target_pos, _origin_pos, progress);
                                          CGFloat rotationAngle = INTUInterpolateCGFloat(_rotate_angle, 0, progress);
                                          self.transform = CGAffineTransformMakeRotation(rotationAngle);
                                      }
                                  }
                                  completion:^(BOOL finished) {
                                      // NOTE: When passing INTUAnimationOptionRepeat, this completion block is NOT executed at the end of each cycle. It will only run if the animation is canceled.
                                      //                                                         self.animationID = NSNotFound;
                                      _isMoved = !_isMoved;
                                      //                                                         [self viewDidLayoutSubviews];
                                      if (block) {
                                          block(finished, self);
                                      }
                                  }];
}
@end
