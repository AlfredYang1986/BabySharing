//
//  CVViewController2.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 26/05/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "CVViewController2.h"
#import "GPUImage.h"
#import "TmpFileStorageModel.h"
//#import "PostPreViewController.h"
#import "AlbumModule.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "INTUAnimationEngine.h"
#import "AlbumViewController2.h"
//#import "PhotoPreViewController.h"
#import "PostPreViewEffectController.h"
#import "OBShapedButton.h"
#import "SearchSegView2.h"

//#define FAKE_NAVIGATION_BAR_HEIGHT 49
#define FAKE_NAVIGATION_BAR_HEIGHT 64

@interface CVViewController2 () <SearchSegViewDelegate> {
    GPUImageOutput<GPUImageInput> *filter;
    GPUImageView* filterView;
    CGFloat aspectRatio;
    GPUImageStillCamera *stillCamera;
    
    BOOL isFlash;
    BOOL isLayoutHelp;
    NSMutableArray* layout_help_layers;
    
    UIButton* f_btn_2;
    
    // take animation
    OBShapedButton* take_btn;
    CALayer* inner_take_btn_layer;
    
    SearchSegView2* seg;
}

@end

@implementation CVViewController2

@synthesize delegate = _delegate;

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];  // for < ios 7.0
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.1098 alpha:1.f];
   
    stillCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
    stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    
    filter = [[GPUImageFilter alloc]init];
   
    [stillCamera addTarget:filter];
    
    filterView = [[GPUImageView alloc]initWithFrame:CGRectMake(0, 0, 1024, 1024)];
    [filter addTarget:filterView];
   
    [self.view addSubview:filterView];
    
    aspectRatio = 4.0 / 3.0;
    
    /**
     * fake navigation bar
     */
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    UIView * bar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, FAKE_NAVIGATION_BAR_HEIGHT)];
    bar.backgroundColor = [UIColor colorWithRed:0.1373 green:0.1216 blue:0.1255 alpha:1.f];
    [self.view addSubview:bar];
    [self.view bringSubviewToFront:bar];
   
#define CANCEL_BTN_WIDTH            30
#define CANCEL_BTN_HEIGHT           CANCEL_BTN_WIDTH
#define CANCEL_BTN_LEFT_MARGIN      10.5
    
    UIButton* barBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, CANCEL_BTN_WIDTH, CANCEL_BTN_HEIGHT)];
    barBtn.center = CGPointMake(CANCEL_BTN_WIDTH / 2 + CANCEL_BTN_LEFT_MARGIN, FAKE_NAVIGATION_BAR_HEIGHT / 2);
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];

    NSString* filepath = [resourceBundle pathForResource:@"post_cancel" ofType:@"png"];
    
#define CANCEL_ICON_WIDTH            20
#define CANCEL_ICON_HEIGHT           CANCEL_ICON_WIDTH
    
    CALayer* cancel_layer = [CALayer layer];
    cancel_layer.contents = (id)[UIImage imageNamed:filepath].CGImage;
    cancel_layer.frame = CGRectMake(0, 0, CANCEL_ICON_WIDTH, CANCEL_ICON_HEIGHT);
    cancel_layer.position = CGPointMake(CANCEL_ICON_WIDTH / 2, CANCEL_BTN_HEIGHT / 2);
    [barBtn.layer addSublayer:cancel_layer];
    [barBtn addTarget:self action:@selector(dismissCVViewController) forControlEvents:UIControlEventTouchDown];
    [bar addSubview:barBtn];
    
    UILabel* titleView = [[UILabel alloc]init];
    titleView.text = @"拍照";
    titleView.font = [UIFont systemFontOfSize:18.f];
    titleView.textColor = [UIColor whiteColor];
    [titleView sizeToFit];
    titleView.center = CGPointMake(width / 2, FAKE_NAVIGATION_BAR_HEIGHT / 2);
    [bar addSubview:titleView];
    
    /**
     * funciton bar
     */
#define FUNCTION_BAR_HEIGHT         44
//    CGFloat height = width * aspectRatio - FUNCTION_BAR_HEIGHT;
    CGFloat height = FAKE_NAVIGATION_BAR_HEIGHT + width;
    UIView* f_bar = [[UIView alloc]initWithFrame:CGRectMake(0, height, width, FUNCTION_BAR_HEIGHT)];
    f_bar.backgroundColor = [UIColor colorWithWhite:0.1098 alpha:1.f];
    
    [self.view addSubview:f_bar];
    [self.view bringSubviewToFront:f_bar];
   
#define FUNCTION_BAR_BTN_WIDTH      25
#define FUNCTION_BAR_BTN_HEIGHT     25
#define FUNCTION_BAR_BTN_MARGIN     8
    
    UIButton* f_btn_1 = [[UIButton alloc]initWithFrame:CGRectMake(FUNCTION_BAR_BTN_MARGIN, FUNCTION_BAR_BTN_MARGIN, FUNCTION_BAR_BTN_WIDTH + 5, FUNCTION_BAR_BTN_HEIGHT + 5)];
    [f_btn_1 setBackgroundImage:[UIImage imageNamed:[resourceBundle pathForResource:@"post_change_camera" ofType:@"png"]] forState:UIControlStateNormal];
    [f_btn_1 addTarget:self action:@selector(didChangeCameraBtn) forControlEvents:UIControlEventTouchDown];
    [f_bar addSubview:f_btn_1];
    f_btn_1.center = CGPointMake(width - FUNCTION_BAR_BTN_MARGIN - FUNCTION_BAR_BTN_WIDTH / 2, FUNCTION_BAR_HEIGHT / 2);

    f_btn_2 = [[UIButton alloc]initWithFrame:CGRectMake(FUNCTION_BAR_BTN_MARGIN, FUNCTION_BAR_BTN_MARGIN, FUNCTION_BAR_BTN_WIDTH, FUNCTION_BAR_BTN_HEIGHT)];
    [f_btn_2 setBackgroundImage:[UIImage imageNamed:[resourceBundle pathForResource:@"post_flash_off" ofType:@"png"]] forState:UIControlStateNormal];
    [f_btn_2 addTarget:self action:@selector(didChangeFreshLight) forControlEvents:UIControlEventTouchDown];
    [f_bar addSubview:f_btn_2];
    f_btn_2.center = CGPointMake(FUNCTION_BAR_BTN_MARGIN + FUNCTION_BAR_BTN_WIDTH / 2, FUNCTION_BAR_HEIGHT / 2);
    isFlash = NO;
    
    /**
     * action buttons
     */
    CGFloat last_height = [UIScreen mainScreen].bounds.size.height - height;
    take_btn = [[OBShapedButton alloc]init];
    [take_btn setBackgroundImage:[UIImage imageNamed:[resourceBundle pathForResource:@"post_take_btn" ofType:@"png"]] forState:UIControlStateNormal];
    [take_btn setBackgroundImage:[UIImage imageNamed:[resourceBundle pathForResource:@"post_take_btn_down" ofType:@"png"]] forState:UIControlStateHighlighted];
    [self.view addSubview:take_btn];
    [take_btn addTarget:self action:@selector(didSelectTakePicBtn) forControlEvents:UIControlEventTouchUpInside];
    
#define PHOTO_TAKEN_BTN_WIDTH                   92
#define PHOTO_TAKEN_BTN_HEIGHT                  PHOTO_TAKEN_BTN_WIDTH
#define PHOTO_TAKEN_BTN_MODIFY_MARGIN           -15
    
    take_btn.frame = CGRectMake(0, 0, PHOTO_TAKEN_BTN_WIDTH, PHOTO_TAKEN_BTN_HEIGHT);
    take_btn.center = CGPointMake(width / 2, height + last_height / 2 + PHOTO_TAKEN_BTN_MODIFY_MARGIN);
    
    CGFloat screen_height = [UIScreen mainScreen].bounds.size.height;
    seg = [[SearchSegView2 alloc]initWithFrame:CGRectMake(0, screen_height - 44, width, 44)];
    seg.backgroundColor = [UIColor colorWithWhite:0.1098 alpha:1.f];
   
    [seg addItemWithTitle:@"相册"];
    [seg addItemWithTitle:@"拍照"];
    [seg addItemWithTitle:@"视频"];
    
#define SEG_BTN_MARGIN_BETWEEN          45

    seg.selectedIndex = 1;
    seg.delegate = self;
    seg.margin_between_items = SEG_BTN_MARGIN_BETWEEN;
    
    [self.view addSubview:seg];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.width * aspectRatio;
    
//    filterView.frame = CGRectMake(0, 0, width, width);
    filterView.frame = CGRectMake(0, width - height + FAKE_NAVIGATION_BAR_HEIGHT, width, height);

    [stillCamera startCameraCapture];
    
    seg.selectedIndex = 1;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    [stillCamera stopCameraCapture];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
    //UIStatusBarStyleDefault = 0 黑色文字，浅色背景时使用
    //UIStatusBarStyleLightContent = 1 白色文字，深色背景时使用
}

- (BOOL)prefersStatusBarHidden {
    return YES; //返回NO表示要显示，返回YES将hiden
}

#pragma mark -- seg delegate
- (void)segValueChanged2:(SearchSegView2*)s {
    if (seg.selectedIndex == 0) {
        [_delegate didSelectAlbumBtn:self andCurrentType:AlbumControllerTypePhoto];
        
    } else if (seg.selectedIndex == 2) {
        [_delegate didSelectMovieBtn2:self];
        
    } else {
        
    }
}

#pragma mark -- button action
- (void)didLayoutHelpSelected {
    if (isLayoutHelp) {
        for (CALayer* al in layout_help_layers) {
            [al removeFromSuperlayer];
        }
        [layout_help_layers removeAllObjects];
        isLayoutHelp = NO;
    } else {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat height = width * aspectRatio;
        
        CALayer* l_0 = [CALayer layer];
        l_0.borderWidth = 1.f;
        l_0.borderColor = [UIColor blueColor].CGColor;
        l_0.frame = CGRectMake(0, height / 3, width, 1);
        [layout_help_layers addObject:l_0];
       
        CALayer* l_1 = [CALayer layer];
        l_1.borderWidth = 1.f;
        l_1.borderColor = [UIColor blueColor].CGColor;
        l_1.frame = CGRectMake(0, height * 2 / 3, width, 1);
        [layout_help_layers addObject:l_1];
        
        CALayer* l_2 = [CALayer layer];
        l_2.borderWidth = 1.f;
        l_2.borderColor = [UIColor blueColor].CGColor;
        l_2.frame = CGRectMake(width / 3, 0, 1, height);
        [layout_help_layers addObject:l_2];
        
        CALayer* l_3 = [CALayer layer];
        l_3.borderWidth = 1.f;
        l_3.borderColor = [UIColor blueColor].CGColor;
        l_3.frame = CGRectMake(width * 2 / 3, 0, 1, height);
        [layout_help_layers addObject:l_3];
        
        for (CALayer* al in layout_help_layers) {
            [filterView.layer addSublayer:al];
        }
       
        isLayoutHelp = YES;
    }
}

- (void)didChangeCameraBtn {
    [stillCamera rotateCamera];
}

- (void)didChangeFreshLight {
    AVCaptureSession* session = [stillCamera captureSession];
    AVCaptureDevice* device = [stillCamera inputCamera];
    
    [session beginConfiguration];
    [device lockForConfiguration:nil];
    
//    [device setTorchMode:AVCaptureTorchModeOn];
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    if (isFlash) {
        [device setFlashMode:AVCaptureFlashModeOff];
        [f_btn_2 setBackgroundImage:[UIImage imageNamed:[resourceBundle pathForResource:@"post_flash_off" ofType:@"png"]] forState:UIControlStateNormal];
        isFlash = NO;
    } else {
        [device setFlashMode:AVCaptureFlashModeOn];
        [f_btn_2 setBackgroundImage:[UIImage imageNamed:[resourceBundle pathForResource:@"post_flash_on" ofType:@"png"]] forState:UIControlStateNormal];
        isFlash = YES;
    }
    
    [device unlockForConfiguration];
    [session commitConfiguration];
}

- (void)didSelectAlbumBtn {
//    [_delegate didSelectAlbumBtn:self andCurrentType:AlbumControllerTypePhoto];
//    AlbumViewController2* distination = [[AlbumViewController2 alloc]init];
//    [self.navigationController pushViewController:distination animated:YES];
    [_delegate didSelectAlbumBtn:self andCurrentType:AlbumControllerTypePhoto];
}

- (void)didSelectMovieBtn {
    [_delegate didSelectMovieBtn2:self];
}

- (void)takePicAnimation1 {

    static const CGFloat kAnimationDuration = 0.15; // in seconds
    CGRect outer = take_btn.frame;
    CGRect rc_start = CGRectMake(7, 7, outer.size.width - 14, outer.size.height - 14);
    CGRect rc_end = CGRectMake(outer.size.width / 2, outer.size.height / 2, 1, 1);
    [INTUAnimationEngine animateWithDuration:kAnimationDuration
                                       delay:0.0
                                      easing:INTUEaseInOutQuadratic
                                     options:INTUAnimationOptionAutoreverse
                                  animations:^(CGFloat progress) {
                                      inner_take_btn_layer.frame = INTUInterpolateCGRect(rc_start, rc_end, progress);
                                      inner_take_btn_layer.cornerRadius = inner_take_btn_layer.frame.size.width / 2;
                                      // NSLog(@"Progress: %.2f", progress);
                                  }
                                  completion:^(BOOL finished) {
                                      // NOTE: When passing INTUAnimationOptionRepeat, this completion block is NOT executed at the end of each cycle. It will only run if the animation is canceled.
                                      NSLog(@"%@", finished ? @"Animation Completed" : @"Animation Canceled");
                                      // self.animationID = NSNotFound;
                                      [self takePicAnimation2];
                                      
                                  }];
}

- (void)takePicAnimation2 {

    static const CGFloat kAnimationDuration = 0.15; // in seconds
    CGRect outer = take_btn.frame;
    CGRect rc_start = CGRectMake(7, 7, outer.size.width - 14, outer.size.height - 14);
    CGRect rc_end = CGRectMake(outer.size.width / 2, outer.size.height / 2, 1, 1);
//    CGRect rc_end = CGRectMake(outer.size.width / 2 - 7, outer.size.height / 2 - 7, 14, 14);
    [INTUAnimationEngine animateWithDuration:kAnimationDuration
                                       delay:0.0
                                      easing:INTUEaseInOutQuadratic
                                     options:INTUAnimationOptionNone
                                  animations:^(CGFloat progress) {
                                      inner_take_btn_layer.frame = INTUInterpolateCGRect(rc_end, rc_start, progress);
                                      inner_take_btn_layer.cornerRadius = inner_take_btn_layer.frame.size.width / 2;
                                      // NSLog(@"Progress: %.2f", progress);
                                  }
                                  completion:^(BOOL finished) {
                                      // NOTE: When passing INTUAnimationOptionRepeat, this completion block is NOT executed at the end of each cycle. It will only run if the animation is canceled.
                                      NSLog(@"%@", finished ? @"Animation Completed" : @"Animation Canceled");
                                      // self.animationID = NSNotFound;
                                      dispatch_queue_t queue = dispatch_queue_create("capture pic", NULL);
                                      dispatch_async(queue, ^{
                                          
                                          [stillCamera capturePhotoAsImageProcessedUpToFilter:filter withCompletionHandler:^(UIImage *processedImage, NSError *error) {
                                              
                                              // TODO: save image to local sandbox
                                              UIImageWriteToSavedPhotosAlbum(processedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
                                              
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  PostPreViewEffectController * distination = [[PostPreViewEffectController alloc]init];
                                                  distination.cutted_img = processedImage;
                                                  distination.type = PostPreViewPhote;
                                                  sleep(0.5);
                                                  [self.navigationController pushViewController:distination animated:YES];
                                                  
                                              });
                                          }];
                                      });
                                  }];
}

- (void)didSelectTakePicBtn {
    
//    [self takePicAnimation1];
   
    dispatch_queue_t queue = dispatch_queue_create("capture pic", NULL);
    dispatch_async(queue, ^{
        
        [stillCamera capturePhotoAsImageProcessedUpToFilter:filter withCompletionHandler:^(UIImage *processedImage, NSError *error) {
            
            // TODO: save image to local sandbox
            UIImageWriteToSavedPhotosAlbum(processedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                PostPreViewEffectController * distination = [[PostPreViewEffectController alloc]init];
                CGFloat width = [UIScreen mainScreen].bounds.size.width;
                distination.cutted_img = [self clipImage:processedImage withRect:CGRectMake(0, processedImage.size.height - processedImage.size.width, processedImage.size.width, processedImage.size.width)];
                distination.type = PostPreViewPhote;
                sleep(0.5);
                [self.navigationController pushViewController:distination animated:YES];
                
            });
        }];
    });
}

- (UIImage*)clipImage:(UIImage*)image withRect:(CGRect)rect {
   
    CGImageRef subImageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    //    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    //    UIGraphicsBeginImageContext(smallBounds.size);
    //    CGContextRef context = UIGraphicsGetCurrentContext();
    //    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    //    UIGraphicsEndImageContext();
    
    return smallImage;
}

#pragma mark -- save image callback
- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo{
    if (!error) {
        NSLog(@"picture saved with no error.");
    } else {
        NSLog(@"error occured while saving the picture%@", error);
    }
}

#pragma mark -- dismiss camera controller
- (void)dismissCVViewController {
    [self dismissViewControllerAnimated:YES completion:^(void){
        NSLog(@"dismiss CV controller");
    }];
}
@end
