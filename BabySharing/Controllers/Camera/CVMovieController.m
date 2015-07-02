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
#import "PostPreViewController.h"

@interface CVMovieController ()  {

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
}
@property (weak, nonatomic) IBOutlet UIButton *camPosBtn;
@property (weak, nonatomic) IBOutlet UIButton *takeBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@end

@implementation CVMovieController

@synthesize camPosBtn = _camPosBtn;
@synthesize takeBtn = _takeBtn;
@synthesize cancelBtn = _cancelBtn;

@synthesize delegate = _delegate;

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    trait = [[MoviePlayTrait alloc]init];
    trait.delegate = self;
    movie_list = [[NSMutableArray alloc]init];
    isRecording = NO;
    self.view.backgroundColor = UIColor.blackColor;
    
    videoCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
    videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    
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
    
    [videoCamera addTarget:filter];
    
    filterView = [[GPUImageView alloc]initWithFrame:CGRectMake(0, 0, 1024, 1024)];
    [filter addTarget:filterView];
    
    [self.view addSubview:filterView];
    
    aspectRatio = 4.0 / 3.0;
    
    [self.view bringSubviewToFront:_camPosBtn];
    [self.view bringSubviewToFront:_cancelBtn];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -- button action
- (IBAction)didChangeCameraBtn {
    [videoCamera rotateCamera];
}

- (IBAction)didSelectTakePicBtn {
    if (!isRecording) {
        NSString* strDir = [TmpFileStorageModel BMTmpMovieDir];
        NSString *testfile = [strDir stringByAppendingPathComponent:[TmpFileStorageModel generateFileName]];
        NSString* path = [testfile stringByAppendingPathExtension:@"mp4"];
        
        dis = [NSURL fileURLWithPath:path];
        
        movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:dis size:CGSizeMake(480.0, 640.0)];
        movieWriter.encodingLiveVideo = YES;
        
        [filter addTarget:movieWriter];
        videoCamera.audioEncodingTarget = movieWriter;
        isRecording = true;
        [_takeBtn setTitle:@"stop" forState:UIControlStateNormal];
        [movieWriter startRecording];
    } else {
        _takeBtn.enabled = NO;
        [filter removeTarget:movieWriter];
        videoCamera.audioEncodingTarget = nil;
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
                [_takeBtn setTitle:@"start" forState:UIControlStateNormal];
                _takeBtn.enabled = YES;
                isRecording = false;
            });
        }];
        NSLog(@"Movie completed");
    }
}

- (IBAction)didSelectMergeBtn {
    if (movie_list.count > 0) {
        [trait mergeMultipleAssertWithURLs:movie_list andAudio:nil];
    } else {
        [self MergeMovieSuccessfulWithFinalURL:[movie_list firstObject]];
    }
}

- (IBAction)didSelectAlbumBtn {
    [_delegate didSelectAlbumBtn:self andCurrentType:AlbumControllerTypeMovie];
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
- (IBAction)dismissCVViewController: (id)sender {
    
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

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PostPreView" bundle:nil];
    PostPreViewController* postNav = [storyboard instantiateViewControllerWithIdentifier:@"PostPreView"];
    postNav.type = PostPreViewMovie;
    postNav.movieURL = url;
    [self.navigationController pushViewController:postNav animated:YES];
}
@end
