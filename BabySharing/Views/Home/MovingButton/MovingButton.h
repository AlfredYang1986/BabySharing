//
//  MovingButton.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 1/06/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MovingButton;
typedef void(^movingFinished)(BOOL finished, MovingButton* btn);

@interface MovingButton : UIButton
@property (nonatomic, readonly) CGPoint origin_pos;
@property (nonatomic, readonly) CGPoint target_pos;
@property (nonatomic, readonly) CGFloat rotate_angle;

@property (nonatomic, readonly) BOOL  isMoved;

- (id)initWithOrigin:(CGPoint)origin andFinal:(CGPoint)target andRangle:(CGFloat)angle;
- (void)resetPos;
- (void)moveWithFinishBlock:(movingFinished)block;
@end
