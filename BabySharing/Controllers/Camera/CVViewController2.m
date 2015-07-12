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
#import "PhotoPreViewController.h"

@interface CVViewController2 () {
    GPUImageOutput<GPUImageInput> *filter;
    GPUImageView* filterView;
    CGFloat aspectRatio;
    GPUImageStillCamera *stillCamera;
    
    BOOL isFlash;
    BOOL isLayoutHelp;
    NSMutableArray* layout_help_layers;
    
    UIButton* f_btn_2;
    
    // take animation
    UIButton* take_btn;
    CALayer* inner_take_btn_layer;
}

@end

@implementation CVViewController2

@synthesize delegate = _delegate;

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.blackColor;
   
    stillCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
    stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    
//    filter = [[GPUImageSepiaFilter alloc] init];
    filter = [[GPUImageFilter alloc]init];
    
    //    filter = [[GPUImageTiltShiftFilter alloc] init];
    //    [(GPUImageTiltShiftFilter *)filter setTopFocusLevel:0.65];
    //    [(GPUImageTiltShiftFilter *)filter setBottomFocusLevel:0.85];
    //    [(GPUImageTiltShiftFilter *)filter setBlurSize:1.5];
    //    [(GPUImageTiltShiftFilter *)filter setFocusFallOffRate:0.2];
    
    //    filter = [[GPUImageSketchFilter alloc] init];
    //    filter = [[GPUImageColorInvertFilter alloc] init];
    //    filter = [[GPUImageSmoothToonFilter alloc] init];
    //    GPUImageRotationFilter *rotationFilter = [[GPUImageRotationFilter alloc] initWithRotation:kGPUImageRotateRightFlipVertical];
    
    [stillCamera addTarget:filter];
    
    filterView = [[GPUImageView alloc]initWithFrame:CGRectMake(0, 0, 1024, 1024)];
    [filter addTarget:filterView];
   
    [self.view addSubview:filterView];
    
    aspectRatio = 4.0 / 3.0;
    
    /**
     * fake navigation bar
     */
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    UIView * bar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 49)];
    bar.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.3];
    [self.view addSubview:bar];
    [self.view bringSubviewToFront:bar];
    
    UIButton* barBtn = [[UIButton alloc]initWithFrame:CGRectMake(13, 15, 25, 25)];
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    NSString* filepath = [resourceBundle pathForResource:@"Cancel_blue" ofType:@"png"];
    [barBtn setBackgroundImage:[UIImage imageNamed:filepath] forState:UIControlStateNormal];
    [barBtn addTarget:self action:@selector(dismissCVViewController) forControlEvents:UIControlEventTouchDown];
    [bar addSubview:barBtn];
    
    /**
     * funciton bar
     */
    CGFloat height = width * aspectRatio;
    UIView* f_bar = [[UIView alloc]initWithFrame:CGRectMake(0, height, width, 44)];
    f_bar.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.6];
    [self.view addSubview:f_bar];
    [self.view bringSubviewToFront:f_bar];
    
    UIButton* f_btn_0 = [[UIButton alloc]initWithFrame:CGRectMake(8, 8, 25, 25)];
    [f_btn_0 setBackgroundImage:[UIImage imageNamed:[resourceBundle pathForResource:@"Grid" ofType:@"png"]] forState:UIControlStateNormal];
    [f_btn_0 addTarget:self action:@selector(didLayoutHelpSelected) forControlEvents:UIControlEventTouchDown];
    [f_bar addSubview:f_btn_0];
    f_btn_0.center = CGPointMake(width / 2 - width / 3, 22);
    isLayoutHelp = NO;
    layout_help_layers = [[NSMutableArray alloc]initWithCapacity:4];

    UIButton* f_btn_1 = [[UIButton alloc]initWithFrame:CGRectMake(8, 8, 25, 25)];
    [f_btn_1 setBackgroundImage:[UIImage imageNamed:[resourceBundle pathForResource:@"Refresh" ofType:@"png"]] forState:UIControlStateNormal];
    [f_btn_1 addTarget:self action:@selector(didChangeCameraBtn) forControlEvents:UIControlEventTouchDown];
    [f_bar addSubview:f_btn_1];
    f_btn_1.center = CGPointMake(width / 2, 22);

    f_btn_2 = [[UIButton alloc]initWithFrame:CGRectMake(8, 8, 25, 25)];
    [f_btn_2 setBackgroundImage:[UIImage imageNamed:[resourceBundle pathForResource:@"Lightning_off" ofType:@"png"]] forState:UIControlStateNormal];
    [f_btn_2 addTarget:self action:@selector(didChangeFreshLight) forControlEvents:UIControlEventTouchDown];
    [f_bar addSubview:f_btn_2];
    f_btn_2.center = CGPointMake(width / 2 + width / 3, 22);
    isFlash = NO;
    
    /**
     * action buttons
     */
    CGFloat last_height = [UIScreen mainScreen].bounds.size.height - height - 44;
    take_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, last_height * 0.8, last_height * 0.8)];
    take_btn.layer.cornerRadius = last_height * 0.4;
    take_btn.layer.borderColor = [UIColor whiteColor].CGColor;
    take_btn.layer.borderWidth = 5.f;
    take_btn.clipsToBounds = YES;
    [self.view addSubview:take_btn];
    [take_btn addTarget:self action:@selector(didSelectTakePicBtn) forControlEvents:UIControlEventTouchDown];
    take_btn.center = CGPointMake(width / 2, height + 44 + last_height / 2);
    
    inner_take_btn_layer = [CALayer layer];
    inner_take_btn_layer.frame = CGRectMake(7, 7, last_height * 0.8 - 14, last_height * 0.8 - 14);
    inner_take_btn_layer.cornerRadius = inner_take_btn_layer.frame.size.width / 2;
    inner_take_btn_layer.backgroundColor = [UIColor whiteColor].CGColor;
    inner_take_btn_layer.masksToBounds = YES;
    [take_btn.layer addSublayer:inner_take_btn_layer];
    inner_take_btn_layer.position = CGPointMake(take_btn.frame.size.width / 2, take_btn.frame.size.height / 2);
    
    UIButton* album_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, last_height * 0.5, last_height * 0.5)];
    [album_btn addTarget:self action:@selector(didSelectAlbumBtn) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:album_btn];
    album_btn.center = CGPointMake(width / 2 - width / 3, height + 44 + last_height / 2);
    
    AlbumModule* am = [[AlbumModule alloc]init];
    [am enumFirstAssetWithProprty:ALAssetTypePhoto finishBlock:^(NSArray *result) {
        ALAsset* al = result.firstObject;
        UIImage* img = [UIImage imageWithCGImage:al.thumbnail];
        if (img != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [album_btn setBackgroundImage:img forState:UIControlStateNormal];
            });
        }
    }];
    
//    UIButton* movie_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, last_height * 0.5, last_height * 0.5)];
    UIButton* movie_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [movie_btn addTarget:self action:@selector(didSelectMovieBtn) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:movie_btn];
    movie_btn.center = CGPointMake(width / 2 + width / 3, height + 44 + last_height / 2);
    NSString* movie_img_file = [resourceBundle pathForResource:@"Video" ofType:@"png"];
    [movie_btn setBackgroundImage:[UIImage imageNamed:movie_img_file] forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.width * aspectRatio;
    
    filterView.frame = CGRectMake(0, 0, width, height);

    [stillCamera startCameraCapture];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    [stillCamera stopCameraCapture];
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
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    if (isFlash) {
        [device setFlashMode:AVCaptureFlashModeOff];
        [f_btn_2 setBackgroundImage:[UIImage imageNamed:[resourceBundle pathForResource:@"Lightning_off" ofType:@"png"]] forState:UIControlStateNormal];
        isFlash = NO;
    } else {
        [device setFlashMode:AVCaptureFlashModeOn];
        [f_btn_2 setBackgroundImage:[UIImage imageNamed:[resourceBundle pathForResource:@"Lighting" ofType:@"png"]] forState:UIControlStateNormal];
        isFlash = YES;
    }
    
    [device unlockForConfiguration];
    [session commitConfiguration];
}

- (void)didSelectAlbumBtn {
//    [_delegate didSelectAlbumBtn:self andCurrentType:AlbumControllerTypePhoto];
    AlbumViewController2* distination = [[AlbumViewController2 alloc]init];
    [self.navigationController pushViewController:distination animated:YES];
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
                                                  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PhotoPreView" bundle:nil];
                                                  PhotoPreViewController* postNav = [storyboard instantiateViewControllerWithIdentifier:@"PhotoPreView"];
                                                  postNav.photoArray = @[processedImage];
//                                                  postNav.type = PostPreViewPhote;
                                                  sleep(0.5);
                                                  [self.navigationController pushViewController:postNav animated:YES];
                                              });
                                          }];
                                      });
                                  }];
}

- (void)didSelectTakePicBtn {
    
    [self takePicAnimation1];
   
//    dispatch_queue_t queue = dispatch_queue_create("capture pic", NULL);
//    dispatch_async(queue, ^{
//
//        [stillCamera capturePhotoAsImageProcessedUpToFilter:filter withCompletionHandler:^(UIImage *processedImage, NSError *error) {
//            
//            // TODO: save image to local sandbox
//            UIImageWriteToSavedPhotosAlbum(processedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
//          
//            dispatch_async(dispatch_get_main_queue(), ^{
//                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PostPreView" bundle:nil];
//                PostPreViewController* postNav = [storyboard instantiateViewControllerWithIdentifier:@"PostPreView"];
//                postNav.postArray = @[processedImage];
//                postNav.type = PostPreViewPhote;
//                sleep(0.5);
//                [self.navigationController pushViewController:postNav animated:YES];
//            });
//        }];
//    });
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
