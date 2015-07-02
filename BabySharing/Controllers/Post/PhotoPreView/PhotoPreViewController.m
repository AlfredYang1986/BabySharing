//
//  PhotoPreViewController.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 11/06/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "PhotoPreViewController.h"
#import "INTUAnimationEngine.h"
#import "PhotoPreViewEffectController.h"

@interface PhotoPreViewController ()

@end

@implementation PhotoPreViewController {
    float aspectRatio;
    CGPoint point;
    
    CGFloat screen_width;
    CGFloat screen_height;
    CGFloat control_pane_height;
    
    CGFloat last_scale;
    
    CGFloat top_margin;
}

@synthesize preImgView = _preImgView;
@synthesize floatingView = _floatingView;
@synthesize scaleBtn = _scaleBtn;

@synthesize photoArray = _photoArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _floatingView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];

    UIImage* img = [_photoArray firstObject];
    _preImgView.image = img;

    [self.view bringSubviewToFront:_floatingView];
    [self.view bringSubviewToFront:_scaleBtn];
//    _floatingView.hidden = YES;
    
    screen_width = [UIScreen mainScreen].bounds.size.width;
    screen_height = [UIScreen mainScreen].bounds.size.height;
    control_pane_height = screen_width / 2;
    last_scale = 1.f;
    
    _preImgView.userInteractionEnabled = YES;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [_preImgView addGestureRecognizer:pan];
    
    UIPinchGestureRecognizer* pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(handlePinch:)];
    [_preImgView addGestureRecognizer:pinch];

    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    UIImage *image_cancel = [UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"Previous"] ofType:@"png"]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:image_cancel style:UIBarButtonItemStylePlain target:self action:@selector(dismissPhotoPreViewController:)];
    UIImage *image_next = [UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"Next"] ofType:@"png"]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:image_next style:UIBarButtonItemStylePlain target:self action:@selector(didSelectNextBtn:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    // need relayout the subviews
    
    top_margin = self.navigationController.navigationBar.frame.size.height;
    screen_width = [UIScreen mainScreen].bounds.size.width;
    screen_height = [UIScreen mainScreen].bounds.size.height;
    control_pane_height = screen_width / 2;
    
    [self roverImgViewWithAnimaiton:NO];
    
    _floatingView.frame = CGRectMake(0, screen_height - control_pane_height, screen_width, control_pane_height);
    _scaleBtn.center = _floatingView.center;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -- move the pic
- (void)handlePan:(UIPanGestureRecognizer*)gesture {
    NSLog(@"pan gesture");
    if (gesture.state == UIGestureRecognizerStateBegan) {
        NSLog(@"begin");
        point = [gesture translationInView:_preImgView];
            
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        NSLog(@"end");
        point = CGPointMake(-1, -1);
        CGFloat move_x = [self distanceMoveHer];
        CGFloat move_y = [self distanceMoveVer];
        [self moveView:move_x and:move_y];
        
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        NSLog(@"changeed");
        CGPoint newPoint = [gesture translationInView:_preImgView];
       
        _preImgView.center = CGPointMake(_preImgView.center.x + (newPoint.x - point.x) / last_scale, _preImgView.center.y + (newPoint.y - point.y) / last_scale);
        point = newPoint;
    }
}

- (CGFloat)distanceMoveVer {
    if (_preImgView.frame.origin.y > top_margin)
        return -_preImgView.frame.origin.y + top_margin;
    else if (_preImgView.frame.origin.y + _preImgView.frame.size.height < screen_height - control_pane_height)
        return screen_height - control_pane_height - (_preImgView.frame.origin.y + _preImgView.frame.size.height);
    else return 0;
}

- (CGFloat)distanceMoveHer {
    
    if (_preImgView.frame.origin.x > 0)
        return -_preImgView.frame.origin.x;
    else if (_preImgView.frame.origin.x + _preImgView.frame.size.width < screen_width)
        return screen_width - (_preImgView.frame.origin.x + _preImgView.frame.size.width);
    else return 0;
}

- (void)moveView:(float)move_x and:(float)move_y
{
    static const CGFloat kAnimationDuration = 0.30; // in seconds
    CGPoint center = _preImgView.center;
    CGPoint newCenter = CGPointMake(_preImgView.center.x + move_x, _preImgView.center.y + move_y);
    [INTUAnimationEngine animateWithDuration:kAnimationDuration
                                       delay:0.0
                                      easing:INTUEaseInOutQuadratic
                                     options:INTUAnimationOptionNone
                                  animations:^(CGFloat progress) {
                                      _preImgView.center = INTUInterpolateCGPoint(center, newCenter, progress);
                                      
                                      // NSLog(@"Progress: %.2f", progress);
                                  }
                                  completion:^(BOOL finished) {
                                      // NOTE: When passing INTUAnimationOptionRepeat, this completion block is NOT executed at the end of each cycle. It will only run if the animation is canceled.
                                      NSLog(@"%@", finished ? @"Animation Completed" : @"Animation Canceled");
                                      //                                                         self.animationID = NSNotFound;
                                  }];
}

- (void)scaleView:(CGRect)frame_old and:(CGRect)frame_new {
    static const CGFloat kAnimationDuration = 0.30; // in seconds
    [INTUAnimationEngine animateWithDuration:kAnimationDuration
                                       delay:0.0
                                      easing:INTUEaseInOutQuadratic
                                     options:INTUAnimationOptionNone
                                  animations:^(CGFloat progress) {
                                      _preImgView.frame = INTUInterpolateCGRect(frame_old, frame_new, progress);
                                      
                                      // NSLog(@"Progress: %.2f", progress);
                                  }
                                  completion:^(BOOL finished) {
                                      // NOTE: When passing INTUAnimationOptionRepeat, this completion block is NOT executed at the end of each cycle. It will only run if the animation is canceled.
                                      NSLog(@"%@", finished ? @"Animation Completed" : @"Animation Canceled");
                                      //                                                         self.animationID = NSNotFound;
                                  }];
}

#pragma mark -- scale the pic
- (void)handlePinch:(UIPinchGestureRecognizer*)gesture {
    NSLog(@"pinch gesture");
    if (gesture.state == UIGestureRecognizerStateBegan) {
        NSLog(@"begin");
        
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        NSLog(@"end: scale: %f", last_scale);
        [self checkScale];
        
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        NSLog(@"changeed");
        gesture.scale= gesture.scale - last_scale + 1;
//        _preImgView.transform = CGAffineTransformScale(_preImgView.transform, gesture.scale,gesture.scale);
        CGPoint cp = _preImgView.center;
        _preImgView.frame = CGRectMake(_preImgView.frame.origin.x, _preImgView.frame.origin.y, _preImgView.frame.size.width * gesture.scale, _preImgView.frame.size.height * gesture.scale);
        _preImgView.center = cp;
        last_scale = gesture.scale;;
    }
}

- (void)checkScale {
    if (_preImgView.bounds.size.width > _preImgView.bounds.size.height) {
        if (_preImgView.frame.size.height < screen_height - control_pane_height) {
            CGFloat width = (screen_height - control_pane_height - top_margin) / _preImgView.frame.size.height * _preImgView.frame.size.width;
            [self scaleView:_preImgView.frame and:CGRectMake(0, top_margin, width, (screen_height - control_pane_height - top_margin))];
        }
    } else {
        if (_preImgView.frame.size.width < screen_width) {
            CGFloat height = screen_width / _preImgView.frame.size.width * _preImgView.frame.size.height;
            [self scaleView:_preImgView.frame and:CGRectMake(0, top_margin, screen_width, height - top_margin)];
        }
    }
}

#pragma mark -- auto cut
- (IBAction)didSelectAutoCutBtn {
    [self roverImgViewWithAnimaiton:YES];
}

- (void)roverImgViewWithAnimaiton:(BOOL)bAnimation {
    CGRect frame_new;
    UIImage* img = _preImgView.image;
    if (img.size.width > img.size.height) {
        frame_new = CGRectMake(0, top_margin, img.size.width / img.size.height * (screen_height  - control_pane_height), screen_height - control_pane_height - top_margin);
    } else {
        frame_new = CGRectMake(0, top_margin, screen_width, img.size.height / img.size.width * screen_width - top_margin);
    };
    if (bAnimation) {
        [self scaleView:_preImgView.frame and:frame_new];
    } else {
        _preImgView.frame = frame_new;
    }
}

#pragma mark -- segue
- (void)dismissPhotoPreViewController:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didSelectNextBtn:(id)sender {
    [self performSegueWithIdentifier:@"editSegue" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"editSegue"]) {
        CGFloat width = screen_width;
        CGFloat height = screen_height - control_pane_height - top_margin;
        CGFloat scale_x = _preImgView.image.size.width / _preImgView.frame.size.width;
        CGFloat scale_y = _preImgView.image.size.height / _preImgView.frame.size.height;
        
        CGFloat offset_x = fabs(_preImgView.frame.origin.x);
        CGFloat offset_y = fabs(_preImgView.frame.origin.y - top_margin);

        UIImage* cutted_img = [self clipImage:_preImgView.image withRect:CGRectMake(offset_x * scale_x, offset_y * scale_y, width * scale_x, height * scale_y)];
        ((PhotoPreViewEffectController*)segue.destinationViewController).edting_img = cutted_img;
    }
}

- (UIImage*)clipImage:(UIImage*)img withRect:(CGRect)rect {
    
    CGImageRef subImageRef = CGImageCreateWithImageInRect(img.CGImage, rect);
//    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
//    UIGraphicsBeginImageContext(smallBounds.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
//    UIGraphicsEndImageContext();
    
    return smallImage;
}
@end

