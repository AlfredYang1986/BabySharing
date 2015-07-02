//
//  PhotoPreViewEffectControllerViewController.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 11/06/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "PhotoPreViewEffectController.h"
#import "INTUAnimationEngine.h"
#import "GPUImage.h"
#import "PhotoTagsController.h"

@interface PhotoPreViewEffectController ()
@property (weak, nonatomic) IBOutlet PhotoPreViewEditView *effectView;

@end

@implementation PhotoPreViewEffectController {
    CGPoint point;
    CGFloat top_margin;
    
    CGFloat screen_width;
    CGFloat screen_height;
    CGFloat control_pane_height;
    
    UIView* cur_long_press;
    
    // for effort of the image
    GPUImagePicture* ip;
    
    // filters
    GPUImageTiltShiftFilter* tiltShiftFilter;
    GPUImageSketchFilter* sketchFilter;
    GPUImageColorInvertFilter* colorInvertFilter;
    GPUImageSmoothToonFilter* smoothToonFilter;
}

@synthesize effectView = _effectView;
@synthesize edting_img = _edting_img;
@synthesize imgView = _imgView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"view did load");
  
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    
    UIImage *dice_1 = [UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"Dice1"] ofType:@"png"]];
    UIImage *dice_2 = [UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"Dice2"] ofType:@"png"]];
    UIImage *dice_3 = [UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"Dice3"] ofType:@"png"]];
   
    NSString* filepath = [resourceBundle pathForResource:@"Previous" ofType:@"png"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:filepath] style:UIBarButtonItemStylePlain target:self action:@selector(didSelectBackBtn:)];
    
    NSString* nextPath = [resourceBundle pathForResource:@"Next" ofType:@"png"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:nextPath] style:UIBarButtonItemStylePlain target:self action:@selector(didSelectNextBtn:)];
    
    [_effectView addControllButtonsWithImage:@[dice_1, dice_2, dice_3] andType:EffectTypePaste];
    [_effectView addControllButtons:@[@"tilt", @"sketch", @"color", @"smooth"] andType:EffectTypePhoto];
    _effectView.delegate = self;
   
    _imgView.contentMode = UIViewContentModeScaleToFill;
    _imgView.image = _edting_img;
    _imgView.userInteractionEnabled = YES;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    [_effectView layoutMySelf];
  
    top_margin = self.navigationController.navigationBar.frame.size.height;
    screen_width = [UIScreen mainScreen].bounds.size.width;
    screen_height = [UIScreen mainScreen].bounds.size.height;
    control_pane_height = screen_width / 2;
    
    _imgView.frame = CGRectMake(0, top_margin,  screen_width, screen_height - control_pane_height - top_margin);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)setEditImage:(UIImage*)img {
    _edting_img = img;
    _imgView.image = img;

    if (tiltShiftFilter == nil) {
        tiltShiftFilter = [[GPUImageTiltShiftFilter alloc] init];
        [tiltShiftFilter setTopFocusLevel:1.f];
        [tiltShiftFilter setBottomFocusLevel:1.f];
        [tiltShiftFilter setFocusFallOffRate:0.2];
    }
  
    if (sketchFilter == nil) {
        sketchFilter = [[GPUImageSketchFilter alloc] init];
    }
    
    if (colorInvertFilter == nil) {
        colorInvertFilter  = [[GPUImageColorInvertFilter alloc] init];
    }
    
    if (smoothToonFilter == nil) {
        smoothToonFilter = [[GPUImageSmoothToonFilter alloc] init];
    }
    
    if (ip == nil) {
        ip = [[GPUImagePicture alloc]initWithImage:_edting_img];
    }
}

#pragma mark -- segue
- (void)didSelectBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didSelectNextBtn:(id)sender {
    [self performSegueWithIdentifier:@"tagsSegue" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"tagsSegue"]) {
        ((PhotoTagsController*)segue.destinationViewController).taging_img = [self mergePasteAndEffect:_imgView.image];
    }
}

- (UIImage*)mergePasteAndEffect:(UIImage*)baseImg {
    CGImageRef baseImageRef = CGImageCreateWithImageInRect(baseImg.CGImage, CGRectMake(0, 0, baseImg.size.width, baseImg.size.height));
    CGRect baseBounds = CGRectMake(0, 0, CGImageGetWidth(baseImageRef), CGImageGetHeight(baseImageRef));
    
    CGFloat scale_x = _imgView.image.size.width / _imgView.frame.size.width;
    CGFloat scale_y = _imgView.image.size.height / _imgView.frame.size.height;
    
    UIGraphicsBeginImageContext(baseBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextTranslateCTM(context, 0.0, baseBounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, baseBounds, baseImageRef);
    
    for (UIImageView* view in _imgView.subviews) {
        
        CGImageRef subImgRef = CGImageCreateWithImageInRect(view.image.CGImage, CGRectMake(0, 0, view.image.size.width, view.image.size.height));
        CGRect rect = view.frame;
        
        CGFloat offset_x = rect.origin.x;
        CGFloat offset_y = _imgView.frame.size.height - (rect.origin.y + rect.size.height);
        
        CGRect smallBounds = CGRectMake(offset_x * scale_x, offset_y * scale_y, rect.size.width * scale_x, rect.size.height * scale_y);
        CGContextDrawImage(context, smallBounds, subImgRef);
    }
    
   
    CGImageRef newImageRef = CGBitmapContextCreateImage(context);
    UIImage* newImage = [UIImage imageWithCGImage:newImageRef];
    UIGraphicsEndImageContext();
//   
    return newImage;
}

#pragma mark -- paste image
- (void)didSelectOneEffectBtn:(struct effect_protocol)effect {
    NSString* str = [NSString stringWithUTF8String:effect.name];
    switch (effect.type) {
        case EffectTypePaste: {
            UIImage* paste_img = [UIImage imageWithCGImage:effect.img];
            if (paste_img) {
                UIImageView* tmp = [[UIImageView alloc]initWithImage:paste_img];
                tmp.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.f];
                tmp.userInteractionEnabled = YES;
                UIPanGestureRecognizer* pin = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePasteImagePin:)];
                [tmp addGestureRecognizer:pin];
                UILongPressGestureRecognizer* lg = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)];
                [tmp addGestureRecognizer:lg];
                [_imgView addSubview:tmp];
                tmp.center = _imgView.center;
            }}
            break;
        case EffectTypePhoto: {
            if ([str isEqualToString:@"tilt"]) {
                [ip removeAllTargets];
                [ip addTarget:tiltShiftFilter];
                [tiltShiftFilter useNextFrameForImageCapture];
                [ip processImage];
                UIImage *newImg = [tiltShiftFilter imageFromCurrentFramebuffer];
                _imgView.image = newImg;
            
            } else if ([str isEqualToString:@"sketch"]) {
                [ip removeAllTargets];
                [ip addTarget:sketchFilter];
                [sketchFilter useNextFrameForImageCapture];
                [ip processImage];
                UIImage *newImg = [sketchFilter imageFromCurrentFramebuffer];
                _imgView.image = newImg;
            
            } else if ([str isEqualToString:@"color"]) {
                [ip removeAllTargets];
                [ip addTarget:colorInvertFilter];
                [colorInvertFilter useNextFrameForImageCapture];
                [ip processImage];
                UIImage *newImg = [colorInvertFilter imageFromCurrentFramebuffer];
                _imgView.image = newImg;
            
            } else if ([str isEqualToString:@"smooth"]) {
                [ip removeAllTargets];
                [ip addTarget:smoothToonFilter];
                [smoothToonFilter useNextFrameForImageCapture];
                [ip processImage];
                UIImage *newImg = [smoothToonFilter imageFromCurrentFramebuffer];
                _imgView.image = newImg;
            }}
            break;
        default:
            break;
    }
}

- (void)handleLongPress:(UILongPressGestureRecognizer*)gesture {
    NSLog(@"long gesture");
    if (gesture.state == UIGestureRecognizerStateBegan) {
        NSLog(@"begin");
        
        cur_long_press = gesture.view;
        UIAlertView* view = [[UIAlertView alloc]initWithTitle:@"delect" message:@"remove paste image" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"yes", nil];
        [view show];
        
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        NSLog(@"changeed");
        
    }
}

- (void)handlePasteImagePin:(UIPanGestureRecognizer*)gesture {
    NSLog(@"pan gesture");
    UIView* tmp = gesture.view;
    if (gesture.state == UIGestureRecognizerStateBegan) {
        NSLog(@"begin");
        point = [gesture translationInView:_imgView];
        [_imgView bringSubviewToFront:tmp];
        
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        NSLog(@"end");
        point = CGPointMake(-1, -1);
        CGFloat move_x = [self distanceMoveHerWithView:tmp];
        CGFloat move_y = [self distanceMoveVerWithView:tmp];
        [self moveView:move_x and:move_y withView:tmp];
        
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        NSLog(@"changeed");
        CGPoint newPoint = [gesture translationInView:_imgView];
        
        tmp.center = CGPointMake(tmp.center.x + (newPoint.x - point.x), tmp.center.y + (newPoint.y - point.y));
        point = newPoint;
    }
}

- (void)moveView:(float)move_x and:(float)move_y withView:(UIView*)view {
    static const CGFloat kAnimationDuration = 0.30; // in seconds
    CGPoint center = view.center;
    CGPoint newCenter = CGPointMake(view.center.x + move_x, view.center.y + move_y);
    [INTUAnimationEngine animateWithDuration:kAnimationDuration
                                       delay:0.0
                                      easing:INTUEaseInOutQuadratic
                                     options:INTUAnimationOptionNone
                                  animations:^(CGFloat progress) {
                                      view.center = INTUInterpolateCGPoint(center, newCenter, progress);
                                      
                                      // NSLog(@"Progress: %.2f", progress);
                                  }
                                  completion:^(BOOL finished) {
                                      // NOTE: When passing INTUAnimationOptionRepeat, this completion block is NOT executed at the end of each cycle. It will only run if the animation is canceled.
                                      NSLog(@"%@", finished ? @"Animation Completed" : @"Animation Canceled");
                                      //                                                         self.animationID = NSNotFound;
                                  }];
}

- (CGFloat)distanceMoveVerWithView:(UIView*)view {
    if (view.frame.origin.y < 0)
        return -view.frame.origin.y;
    else if (view.frame.origin.y + view.frame.size.height > _imgView.frame.size.height)
        return -(view.frame.origin.y + view.frame.size.height - _imgView.frame.size.height);
    else return 0;
}

- (CGFloat)distanceMoveHerWithView:(UIView*)view {
    
    if (view.frame.origin.x < 0)
        return -view.frame.origin.x;
    else if (view.frame.origin.x + view.frame.size.width > _imgView.frame.size.width)
        return -(view.frame.origin.x + view.frame.size.width - _imgView.frame.size.width);
    else return 0;
}


#pragma mark -- alert view delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"index at %ld", (long)buttonIndex);
    if (buttonIndex == 1) {
        [cur_long_press removeFromSuperview];
    }
    cur_long_press = nil;
}
@end
