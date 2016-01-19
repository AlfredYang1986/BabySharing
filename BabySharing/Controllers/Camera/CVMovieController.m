//
//  CVMovieControllerViewController.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 26/05/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "CVMovieController.h"
#import "GPUImage.h"
#import "TmpFileStorageModel.h"
#import <AssetsLibrary/AssetsLibrary.h>
//#import "PostPreViewController.h"
#import "AlbumModule.h"
#import "INTUAnimationEngine.h"
#import "AlbumViewController2.h"
#import "PostPreViewEffectController.h"
#import "OBShapedButton.h"
#import "SearchSegView2.h"

#define MOVIE_MAX_SECONDS       15
#define MOVIE_CALL_BACK_STEP    (1.0 / 12.0)
//#define FAKE_NAVIGATION_BAR_HEIGHT 49
#define FAKE_NAVIGATION_BAR_HEIGHT 64

@interface CVMovieController () <SearchSegViewDelegate> {

    // recording
    GPUImageOutput<GPUImageInput> *filter;
    GPUImageMovieWriter *movieWriter;
    GPUImageView* filterView;
    GPUImageVideoCamera *videoCamera;
   
    // for screen size
    CGFloat aspectRatio;
    // currently recording
    BOOL isRecording;
    
    // for temp movies
    NSURL* dis;
    NSMutableArray* movie_list;
    
    // merge traits
    MoviePlayTrait* trait;
    
    // button
    UIButton* take_btn;
    CALayer* inner_take_btn_layer;
    
    // progress layer
    CALayer* progress_layer;
    CALayer* progress_using_layer;
    
    // timer for progress
    NSTimer* timer;
    CGFloat seconds;
    
    // menu bar
    SearchSegView2* seg;
    
    // delect btn
    UIButton* delete_current_movie_btn;
}

@end

@implementation CVMovieController


@synthesize delegate = _delegate;

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];  // for < ios 7.0

    trait = [[MoviePlayTrait alloc]init];
    trait.delegate = self;
    movie_list = [[NSMutableArray alloc]init];
    isRecording = NO;
    self.view.backgroundColor = UIColor.blackColor;
    
    videoCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
    videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    
    filter = [[GPUImageFilter alloc]init];
    
    [videoCamera addTarget:filter];
    
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
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    NSString* filepath = [resourceBundle pathForResource:@"camera-cancel" ofType:@"png"];
    //    [barBtn setBackgroundImage:[UIImage imageNamed:filepath] forState:UIControlStateNormal];
    CALayer* cancel_layer = [CALayer layer];
    cancel_layer.contents = (id)[UIImage imageNamed:filepath].CGImage;
    
#define CANCEL_ICON_WIDTH            22
#define CANCEL_ICON_HEIGHT           CANCEL_ICON_WIDTH
    
    cancel_layer.frame = CGRectMake(0, 0, CANCEL_ICON_WIDTH, CANCEL_ICON_HEIGHT);
    cancel_layer.position = CGPointMake(CANCEL_ICON_WIDTH / 2, CANCEL_BTN_HEIGHT / 2);
    [barBtn.layer addSublayer:cancel_layer];
    [barBtn addTarget:self action:@selector(dismissCVViewController) forControlEvents:UIControlEventTouchDown];
    [bar addSubview:barBtn];
    
    UILabel* titleView = [[UILabel alloc]init];
    titleView.text = @"视频";
    titleView.textColor = [UIColor whiteColor];
    [titleView sizeToFit];
    titleView.center = CGPointMake(width / 2, FAKE_NAVIGATION_BAR_HEIGHT / 2);
    [bar addSubview:titleView];
    
    UIButton* bar_right_btn = [[UIButton alloc]initWithFrame:CGRectMake(width - 13 - 41, 25, 25, 25)];
    [bar_right_btn setTitleColor:[UIColor colorWithRed:0.3126 green:0.7529 blue:0.6941 alpha:1.f] forState:UIControlStateNormal];
    [bar_right_btn setTitle:@"下一步" forState:UIControlStateNormal];
    [bar_right_btn sizeToFit];
    [bar_right_btn addTarget:self action:@selector(didSelectMergeBtn) forControlEvents:UIControlEventTouchDown];
    bar_right_btn.center = CGPointMake(width - 8 - bar_right_btn.frame.size.width / 2, FAKE_NAVIGATION_BAR_HEIGHT / 2);
    [bar addSubview:bar_right_btn];
    
    /**
     * funciton bar
     */
#define FUNCTION_BAR_HEIGHT         44
    CGFloat height = width * aspectRatio - FUNCTION_BAR_HEIGHT;
    UIView* f_bar = [[UIView alloc]initWithFrame:CGRectMake(0, height, width, FUNCTION_BAR_HEIGHT)];
//    f_bar.backgroundColor = [UIColor clearColor];
    f_bar.backgroundColor = [UIColor darkGrayColor];
    
    //    CAGradientLayer* bl = [CAGradientLayer layer];
    //    [bl setStartPoint:CGPointMake(0.0, 0.0)];
    //    [bl setEndPoint:CGPointMake(0.0, 1.0)];
    //    bl.colors = [NSArray arrayWithObjects:
    //                    (id)[UIColor colorWithRed:0.2549 green:0.2510 blue:0.2588 alpha:1.f].CGColor,
    //                    (id)[UIColor blackColor].CGColor, nil];
    //
    //    bl.frame = CGRectMake(0, 0, width, 44);
    //    [f_bar.layer addSublayer:bl];
    
    [self.view addSubview:f_bar];
    [self.view bringSubviewToFront:f_bar];
    
//    UIButton* f_btn_0 = [[UIButton alloc]initWithFrame:CGRectMake(8, 8, 25, 25)];
//    [f_btn_0 setBackgroundImage:[UIImage imageNamed:[resourceBundle pathForResource:@"Grid" ofType:@"png"]] forState:UIControlStateNormal];
//    [f_btn_0 addTarget:self action:@selector(didLayoutHelpSelected) forControlEvents:UIControlEventTouchDown];
//    [f_bar addSubview:f_btn_0];
//    f_btn_0.center = CGPointMake(width / 2 - width / 3, 22);
//    isLayoutHelp = NO;
//    layout_help_layers = [[NSMutableArray alloc]initWithCapacity:4];
//    f_btn_0.hidden = YES;
   
#define FUNCTION_BAR_BTN_WIDTH      25
#define FUNCTION_BAR_BTN_HEIGHT     25
#define FUNCTION_BAR_BTN_MARGIN     8
    
    UIButton* f_btn_1 = [[UIButton alloc]initWithFrame:CGRectMake(FUNCTION_BAR_BTN_MARGIN, FUNCTION_BAR_BTN_MARGIN, FUNCTION_BAR_BTN_WIDTH, FUNCTION_BAR_BTN_HEIGHT)];
    //    [f_btn_1 setBackgroundImage:[UIImage imageNamed:[resourceBundle pathForResource:@"CameraRefresh" ofType:@"png"]] forState:UIControlStateNormal];
    [f_btn_1 setBackgroundImage:[UIImage imageNamed:[resourceBundle pathForResource:@"camera-change" ofType:@"png"]] forState:UIControlStateNormal];
    [f_btn_1 addTarget:self action:@selector(didChangeCameraBtn) forControlEvents:UIControlEventTouchDown];
    [f_bar addSubview:f_btn_1];
    f_btn_1.center = CGPointMake(FUNCTION_BAR_BTN_MARGIN + FUNCTION_BAR_BTN_WIDTH / 2, FUNCTION_BAR_HEIGHT / 2);
    
//    f_btn_2 = [[UIButton alloc]initWithFrame:CGRectMake(8, 8, 30, 25)];
//    [f_btn_2 setBackgroundImage:[UIImage imageNamed:[resourceBundle pathForResource:@"Lighting_off" ofType:@"png"]] forState:UIControlStateNormal];
//    [f_btn_2 addTarget:self action:@selector(didChangeFreshLight) forControlEvents:UIControlEventTouchDown];
//    [f_bar addSubview:f_btn_2];
//    f_btn_2.center = CGPointMake(width - 8 - 30 / 2, 22);
//    isFlash = NO;
    
    /**
     * action buttons
     */
    CGFloat last_height = [UIScreen mainScreen].bounds.size.height - height;
//    take_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, last_height * 0.8, last_height * 0.8)];
//    take_btn.layer.cornerRadius = last_height * 0.4;
//    take_btn.layer.borderColor = [UIColor whiteColor].CGColor;
//    take_btn.layer.borderWidth = 5.f;
//    take_btn.clipsToBounds = YES;
    take_btn = [[OBShapedButton alloc]init];
    [take_btn setBackgroundImage:[UIImage imageNamed:[resourceBundle pathForResource:@"camera-movie" ofType:@"png"]] forState:UIControlStateNormal];
    [self.view addSubview:take_btn];
    [take_btn addTarget:self action:@selector(didSelectTakePicBtn) forControlEvents:UIControlEventTouchDown];
    take_btn.frame = CGRectMake(0, 0, 92, 92);
    take_btn.center = CGPointMake(width / 2, height + last_height / 2);
    
//    inner_take_btn_layer = [CALayer layer];
//    inner_take_btn_layer.frame = CGRectMake(7, 7, last_height * 0.8 - 14, last_height * 0.8 - 14);
//    inner_take_btn_layer.cornerRadius = inner_take_btn_layer.frame.size.width / 2;
//    inner_take_btn_layer.backgroundColor = [UIColor redColor].CGColor;
//    inner_take_btn_layer.masksToBounds = YES;
//    [take_btn.layer addSublayer:inner_take_btn_layer];
//    inner_take_btn_layer.position = CGPointMake(take_btn.frame.size.width / 2, take_btn.frame.size.height / 2);
//    
//    UIButton* album_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, last_height * 0.5, last_height * 0.5)];
//    [album_btn addTarget:self action:@selector(didSelectAlbumBtn) forControlEvents:UIControlEventTouchDown];
//    [self.view addSubview:album_btn];
//    album_btn.center = CGPointMake(width / 2 + width / 3, height + 44 + last_height / 2);
//    
//    AlbumModule* am = [[AlbumModule alloc]init];
//    [am enumFirstAssetWithProprty:ALAssetTypeVideo finishBlock:^(NSArray *result) {
//        ALAsset* al = result.firstObject;
//        UIImage* img = [UIImage imageWithCGImage:al.thumbnail];
//        if (img != nil) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [album_btn setBackgroundImage:img forState:UIControlStateNormal];
//            });
//        }
//    }];
    
    //    UIButton* movie_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, last_height * 0.5, last_height * 0.5)];
//    UIButton* movie_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
//    [movie_btn addTarget:self action:@selector(didSelectCameraBtn) forControlEvents:UIControlEventTouchDown];
//    [self.view addSubview:movie_btn];
//    movie_btn.center = CGPointMake(width / 2 - width / 3, height + 44 + last_height / 2);
////    NSString* movie_img_file = [resourceBundle pathForResource:@"Camera_blue" ofType:@"png"];
//    NSString* movie_img_file = [resourceBundle pathForResource:@"Camera_change" ofType:@"png"];
//    [movie_btn setBackgroundImage:[UIImage imageNamed:movie_img_file] forState:UIControlStateNormal];
   
    /**
     * menu bar
     */
    CGFloat screen_height = [UIScreen mainScreen].bounds.size.height;
    seg = [[SearchSegView2 alloc]initWithFrame:CGRectMake(0, screen_height - 44, width, 44)];
    seg.backgroundColor = [UIColor blackColor];
    
    [seg addItemWithTitle:@"相册"];
    [seg addItemWithTitle:@"拍照"];
    [seg addItemWithTitle:@"视频"];
    
    seg.selectedIndex = 2;
    seg.delegate = self;
    seg.margin_between_items = 30;
    
    [self.view addSubview:seg];
    
    /**
     * delete btn
     */
    delete_current_movie_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, screen_height - 44, width, 44)];
    delete_current_movie_btn.backgroundColor = [UIColor blackColor];
    [delete_current_movie_btn setTitle:@"删除" forState:UIControlStateNormal];
    [delete_current_movie_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [delete_current_movie_btn addTarget:self action:@selector(didSelectDeleteBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:delete_current_movie_btn];
    delete_current_movie_btn.hidden = YES;
    
    /**
     * progress bar for movie
     */
    progress_layer = [CALayer layer];
//    progress_layer.borderColor = [UIColor whiteColor].CGColor;
    progress_layer.borderColor = [UIColor blackColor].CGColor;
    progress_layer.borderWidth = 2.f;
    progress_layer.frame = CGRectMake(0, height + 44, width, 2);
    [self.view.layer addSublayer:progress_layer];
    
    progress_using_layer = [CALayer layer];
//    progress_using_layer.borderColor = [UIColor greenColor].CGColor;
    progress_using_layer.borderColor = [UIColor whiteColor].CGColor;
    progress_using_layer.borderWidth = 4.f;
    progress_using_layer.frame = CGRectMake(0, height + 44, 0, 4);
    [self.view.layer addSublayer:progress_using_layer];
    
    timer = [NSTimer scheduledTimerWithTimeInterval: MOVIE_CALL_BACK_STEP //1.0 / 12.0
                                             target: self
                                           selector: @selector(handleTimer:)
                                           userInfo: nil
                                            repeats: YES];
    [timer setFireDate:[NSDate distantFuture]]; // stop
}

//    [timer setFireDate:[NSDate distantPast]]; // start

- (void)handleTimer:(NSTimer*)sender {
    seconds += MOVIE_CALL_BACK_STEP;
    
    CGFloat presentage = seconds / MOVIE_MAX_SECONDS > 1.0 ? 1.0 : seconds / MOVIE_MAX_SECONDS;
    CGFloat width = [UIScreen mainScreen].bounds.size.width * presentage;

    progress_using_layer.frame = CGRectMake(progress_using_layer.frame.origin.x, progress_using_layer.frame.origin.y, width, progress_using_layer.frame.size.height);
    
    if (seconds > MOVIE_MAX_SECONDS) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self didSelectTakePicBtn];
        });
        [timer setFireDate:[NSDate distantFuture]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.width * aspectRatio;
    
    filterView.frame = CGRectMake(0, 0, width, height);
    
    [videoCamera startCameraCapture];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [videoCamera stopCameraCapture];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
    //UIStatusBarStyleDefault = 0 黑色文字，浅色背景时使用
    //UIStatusBarStyleLightContent = 1 白色文字，深色背景时使用
}

- (BOOL)prefersStatusBarHidden {
    return YES; //返回NO表示要显示，返回YES将hiden
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -- button action
- (void)didSelectCameraBtn {
    [_delegate didSelectCameraBtn2:self];
}

- (void)didChangeCameraBtn {
    [videoCamera rotateCamera];
}

- (void)startRecordingAnimation {
    
    static const CGFloat kAnimationDuration = 0.15; // in seconds
    CGRect outer = take_btn.frame;
    CGRect rc_start = CGRectMake(7, 7, outer.size.width - 14, outer.size.height - 14);
    CGFloat radius_start = (outer.size.width - 14) / 2;
    CGRect rc_end = CGRectMake(outer.size.width / 2 - 14, outer.size.height / 2 - 14, 28, 28);
    CGFloat radius_end = 2;
    [INTUAnimationEngine animateWithDuration:kAnimationDuration
                                       delay:0.0
                                      easing:INTUEaseInOutQuadratic
                                     options:INTUAnimationOptionAutoreverse
                                  animations:^(CGFloat progress) {
                                      inner_take_btn_layer.frame = INTUInterpolateCGRect(rc_start, rc_end, progress);
                                      inner_take_btn_layer.cornerRadius = INTUInterpolateCGFloat(radius_start, radius_end, progress);
                                      // NSLog(@"Progress: %.2f", progress);
                                  }
                                  completion:^(BOOL finished) {
                                      // NOTE: When passing INTUAnimationOptionRepeat, this completion block is NOT executed at the end of each cycle. It will only run if the animation is canceled.
                                      NSLog(@"%@", finished ? @"Animation Completed" : @"Animation Canceled");
                                      // self.animationID = NSNotFound;
                                      [timer setFireDate:[NSDate distantPast]]; // start
                                      
                                  }];
}

- (void)endRecordingAnimation {
    static const CGFloat kAnimationDuration = 0.15; // in seconds
    CGRect outer = take_btn.frame;
    CGRect rc_start = CGRectMake(7, 7, outer.size.width - 14, outer.size.height - 14);
    CGFloat radius_start = (outer.size.width - 14) / 2;
    CGRect rc_end = CGRectMake(outer.size.width / 2 - 14, outer.size.height / 2 - 14, 28, 28);
    CGFloat radius_end = 2;
    [INTUAnimationEngine animateWithDuration:kAnimationDuration
                                       delay:0.0
                                      easing:INTUEaseInOutQuadratic
                                     options:INTUAnimationOptionAutoreverse
                                  animations:^(CGFloat progress) {
                                      inner_take_btn_layer.frame = INTUInterpolateCGRect(rc_end, rc_start, progress);
                                      inner_take_btn_layer.cornerRadius = INTUInterpolateCGFloat(radius_end, radius_start, progress);
                                      // NSLog(@"Progress: %.2f", progress);
                                  }
                                  completion:^(BOOL finished) {
                                      // NOTE: When passing INTUAnimationOptionRepeat, this completion block is NOT executed at the end of each cycle. It will only run if the animation is canceled.
                                      NSLog(@"%@", finished ? @"Animation Completed" : @"Animation Canceled");
                                      // self.animationID = NSNotFound;
                                      [timer setFireDate:[NSDate distantFuture]];
                                  }];
}

- (void)didSelectTakePicBtn {
    if (!isRecording) {
        
        if (seconds > MOVIE_MAX_SECONDS) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Moive is too long" message:@"No movie should over 15 seconds" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        NSString* strDir = [TmpFileStorageModel BMTmpMovieDir];
        NSString *testfile = [strDir stringByAppendingPathComponent:[TmpFileStorageModel generateFileName]];
        NSString* path = [testfile stringByAppendingPathExtension:@"mp4"];
        
        dis = [NSURL fileURLWithPath:path];
        
        movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:dis size:CGSizeMake(480.0, 640.0)];
        movieWriter.encodingLiveVideo = YES;
        
        [filter addTarget:movieWriter];
        videoCamera.audioEncodingTarget = movieWriter;
        isRecording = true;
//        [_takeBtn setTitle:@"stop" forState:UIControlStateNormal];
        
        [self startRecordingAnimation];
        [movieWriter startRecording];
        
        delete_current_movie_btn.hidden = NO;
        
    } else {
        take_btn.enabled = NO;
        [filter removeTarget:movieWriter];
        videoCamera.audioEncodingTarget = nil;
        
        [self endRecordingAnimation];
        
        [movieWriter finishRecordingWithCompletionHandler:^{
            // save to photo Album
            ALAssetsLibrary* assetsLibrary = [[ALAssetsLibrary alloc] init];
            [assetsLibrary writeVideoAtPathToSavedPhotosAlbum:dis completionBlock:^(NSURL *assetURL, NSError *error) {
                if (!error) {
                    NSLog(@"captured video saved with no error.");
                } else {
                    NSLog(@"error occured while saving the video:%@", error);
                }
            }];
            dispatch_async(dispatch_get_main_queue(), ^{
                [movie_list addObject:dis];
                dis = nil;
//                [_takeBtn setTitle:@"start" forState:UIControlStateNormal];
                take_btn.enabled = YES;
                isRecording = false;
            });
        }];
        NSLog(@"Movie completed");
    }
}

- (void)didSelectMergeBtn {
    if (movie_list.count > 0) {
        [trait mergeMultipleAssertWithURLs:movie_list andAudio:nil];
    } else {
        [self MergeMovieSuccessfulWithFinalURL:[movie_list firstObject]];
    }
}

- (void)didSelectAlbumBtn {
//    [_delegate didSelectAlbumBtn:self andCurrentType:AlbumControllerTypeMovie];
    AlbumViewController2* distination = [[AlbumViewController2 alloc]init];
    distination.type = AlbumControllerTypeMovie;
    [self.navigationController pushViewController:distination animated:YES];
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
    
    for (NSURL* iter in movie_list) {
        [TmpFileStorageModel deleteOneMovieFileWithUrl:iter];
    }
    
    [self dismissViewControllerAnimated:YES completion:^(void){
        NSLog(@"dismiss CV controller");
    }];
}

#pragma mark -- MovieActionProtocol
- (void)MergeMovieSuccessfulWithFinalURL:(NSURL *)url {
    NSLog(@"Merge Movie Successful");
//    [self dismissCVViewController:nil];

    PostPreViewEffectController * distination = [[PostPreViewEffectController alloc]init];
    distination.editing_movie = url;
    distination.type = PostPreViewMovie;
    [self.navigationController pushViewController:distination animated:YES];
    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PostPreView" bundle:nil];
//    PostPreViewController* postNav = [storyboard instantiateViewControllerWithIdentifier:@"PostPreView"];
//    postNav.type = PostPreViewMovie;
//    postNav.movieURL = url;
//    [self.navigationController pushViewController:postNav animated:YES];
}

#pragma mark -- search delegate
- (void)segValueChanged2:(SearchSegView2*)s {
    if (seg.selectedIndex == 0) {
        [_delegate didSelectAlbumBtn:self andCurrentType:AlbumControllerTypePhoto];
        
    } else if (seg.selectedIndex == 1) {
        [_delegate didSelectCameraBtn2:self];
        
    } else {
        
    }
}

#pragma mark -- delete current 
- (void)didSelectDeleteBtn {
    if (isRecording) {
        UIAlertView* view = [[UIAlertView alloc]initWithTitle:@"error" message:@"cannot delete while recording" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:nil];
        [view show];
        return;
    }
   
    progress_using_layer.frame = CGRectMake(progress_using_layer.frame.origin.x, progress_using_layer.frame.origin.y, 0, progress_using_layer.frame.size.height);
//    [timer setFireDate:[NSDate distantFuture]]; // stop
    seconds = 0.f;
    [movie_list removeAllObjects];
    
    delete_current_movie_btn.hidden = YES;
}
@end
