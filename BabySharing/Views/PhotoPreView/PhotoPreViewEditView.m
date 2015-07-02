//
//  PhotoPreVIewEditVIew.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 11/06/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "PhotoPreViewEditView.h"
#import "INTUAnimationEngine.h"

#define MARGIN 16
#define BUTTON_WIDTH    50

#define EFFECT_PASTE     0
#define EFFECT_PHOTO     1

#define EFFECTS          2

@interface PhotoPreViewEditView ()

@end

@implementation PhotoPreViewEditView {
    NSMutableArray* control_panes;
    CGPoint point;
}

@synthesize sg = _sg;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    NSLog(@"awake from nib with photo preview edit view");
    /**
     * init self rect
     */
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    self.bounds = CGRectMake(0, 0, width, width / 2);
    self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
   
    /**
     * init sub views
     */
    _sg = (UISegmentedControl*)[self viewWithTag:-1];
    _sg.frame = CGRectMake(MARGIN, MARGIN, _sg.frame.size.width, _sg.frame.size.height);
    _sg.selectedSegmentIndex = 0;
    [_sg addTarget:self action:@selector(segValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    /**
     * init control views
     */
    control_panes = [[NSMutableArray alloc]initWithCapacity:EFFECTS];
    CGFloat offset = _sg.frame.size.height + MARGIN;
    for (int index = 0; index < EFFECTS; ++index) {
        UIView* tmp = [[UIView alloc]initWithFrame:CGRectMake(0, offset, width, width / 2 - offset)];
        tmp.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
        control_panes[index] = tmp;
        tmp.hidden = YES;
        UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
        [tmp addGestureRecognizer:pan];
        [self addSubview:tmp];
    }
    ((UIView*)[control_panes objectAtIndex:_sg.selectedSegmentIndex]).hidden = NO;
}

- (void)handlePan:(UIPanGestureRecognizer*)gesture {
    NSLog(@"pan gesture");
    if (gesture.state == UIGestureRecognizerStateBegan) {
        NSLog(@"begin");
        point = [gesture translationInView:self];
        
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        NSLog(@"end");
        point = CGPointMake(-1, -1);
        CGFloat move_x = [self distanceMoveHer:[control_panes objectAtIndex:_sg.selectedSegmentIndex]];
        [self moveView:move_x];
        
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        NSLog(@"changeed");
        CGPoint newPoint = [gesture translationInView:self];
       
        UIView* tmp = [control_panes objectAtIndex:_sg.selectedSegmentIndex];
        tmp.center = CGPointMake(tmp.center.x + (newPoint.x - point.x), tmp.center.y);
        point = newPoint;
    }
}

- (CGFloat)distanceMoveHer:(UIView*)view {
    CGFloat width =  [UIScreen mainScreen].bounds.size.width;
    if (view.frame.origin.x > 0) {
        return - view.frame.origin.x;
    } else if (view.frame.origin.x + view.frame.size.width < width) {
        return width - (view.frame.origin.x + view.frame.size.width);
    } else {
        return 0;
    }
}

- (void)moveView:(CGFloat)move_x {
    static const CGFloat kAnimationDuration = 0.30; // in seconds
    UIView* tmp = [control_panes objectAtIndex:_sg.selectedSegmentIndex];
    CGPoint center = tmp.center;
    CGPoint newCenter = CGPointMake(tmp.center.x + move_x, tmp.center.y);
    [INTUAnimationEngine animateWithDuration:kAnimationDuration
                                       delay:0.0
                                      easing:INTUEaseInOutQuadratic
                                     options:INTUAnimationOptionNone
                                  animations:^(CGFloat progress) {
                                      tmp.center = INTUInterpolateCGPoint(center, newCenter, progress);
                                      
                                      // NSLog(@"Progress: %.2f", progress);
                                  }
                                  completion:^(BOOL finished) {
                                      // NOTE: When passing INTUAnimationOptionRepeat, this completion block is NOT executed at the end of each cycle. It will only run if the animation is canceled.
                                      NSLog(@"%@", finished ? @"Animation Completed" : @"Animation Canceled");
                                      //                                                         self.animationID = NSNotFound;
                                  }];
}

- (void)segValueChanged:(UISegmentedControl*)sg {
    for (UIView* pane in control_panes) {
        pane.hidden = YES;
    }
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    UIView* tmp = [control_panes objectAtIndex:_sg.selectedSegmentIndex];
    CGFloat offset = _sg.frame.size.height + MARGIN;
    tmp.frame = CGRectMake(0, offset, width, width / 2 - offset);
    tmp.hidden = NO;
}

- (void)layoutMySelf {
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat screen_height = [UIScreen mainScreen].bounds.size.height;
    CGFloat height = width / 2;
    
   
    self.frame = CGRectMake(0, screen_height - height, width, height);
}

- (void)addControllButtons:(NSArray*)buttons andType:(EffectType)type {
    UIView* tmp = [control_panes objectAtIndex:type];
    for (int index = 0; index < buttons.count; ++index) {
        CGFloat x_pos = index * (BUTTON_WIDTH + MARGIN) + MARGIN;
        CGFloat y_pos = MARGIN;
        UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(x_pos, y_pos, BUTTON_WIDTH, BUTTON_WIDTH)];
        [btn setTitle:[buttons objectAtIndex:index] forState:UIControlStateNormal];
        btn.layer.borderColor = [UIColor blueColor].CGColor;
        btn.layer.borderWidth = 1.f;
        [btn addTarget:self action:@selector(didSelectBtn:) forControlEvents:UIControlEventTouchDown];
        [tmp addSubview:btn];
    }
    CGFloat width = (buttons.count + 1) * (BUTTON_WIDTH + MARGIN);
    tmp.frame = CGRectMake(tmp.frame.origin.x, tmp.frame.origin.y, MAX(width, tmp.frame.size.width), tmp.frame.size.height);
}

- (void)addControllButtonsWithImage:(NSArray*)buttons andType:(EffectType)type {
    UIView* tmp = [control_panes objectAtIndex:type];
    for (int index = 0; index < buttons.count; ++index) {
        CGFloat x_pos = index * (BUTTON_WIDTH + MARGIN) + MARGIN;
        CGFloat y_pos = MARGIN;
        UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(x_pos, y_pos, BUTTON_WIDTH, BUTTON_WIDTH)];
        [btn setImage:[buttons objectAtIndex:index] forState:UIControlStateNormal];
        btn.layer.borderColor = [UIColor blueColor].CGColor;
        btn.layer.borderWidth = 1.f;
        [btn addTarget:self action:@selector(didSelectBtn:) forControlEvents:UIControlEventTouchDown];
        [tmp addSubview:btn];
    }
    CGFloat width = (buttons.count + 1) * (BUTTON_WIDTH + MARGIN);
    tmp.frame = CGRectMake(tmp.frame.origin.x, tmp.frame.origin.y, MAX(width, tmp.frame.size.width), tmp.frame.size.height);
}

- (void)didSelectBtn:(UIButton*)sender {
    NSString* title = sender.titleLabel.text;
    struct effect_protocol eff;
    eff.name = title ? title.cString : "";
    eff.img = sender.imageView.image.CGImage;
    eff.type = _sg.selectedSegmentIndex;
    [_delegate didSelectOneEffectBtn:eff];
}
@end
