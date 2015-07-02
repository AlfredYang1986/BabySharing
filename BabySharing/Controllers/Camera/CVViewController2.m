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
#import "PostPreViewController.h"

@interface CVViewController2 () {
    GPUImageOutput<GPUImageInput> *filter;
    GPUImageView* filterView;
    CGFloat aspectRatio;
    GPUImageStillCamera *stillCamera;
}
@property (weak, nonatomic) IBOutlet UIButton *camPosBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@end

@implementation CVViewController2

@synthesize camPosBtn = _camPosBtn;
@synthesize delegate = _delegate;
@synthesize cancelBtn = _cancelBtn;

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
    
    [self.view bringSubviewToFront:_camPosBtn];
    [self.view bringSubviewToFront:_cancelBtn];
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
- (IBAction)didChangeCameraBtn {
    [stillCamera rotateCamera];
}

- (IBAction)didSelectAlbumBtn {
    [_delegate didSelectAlbumBtn:self andCurrentType:AlbumControllerTypePhoto];
}

- (IBAction)didSelectTakePicBtn {
    
    [stillCamera capturePhotoAsImageProcessedUpToFilter:filter withCompletionHandler:^(UIImage *processedImage, NSError *error) {
        
        // TODO: save image to local sandbox
        UIImageWriteToSavedPhotosAlbum(processedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PostPreView" bundle:nil];
        PostPreViewController* postNav = [storyboard instantiateViewControllerWithIdentifier:@"PostPreView"];
        postNav.postArray = @[processedImage];
        postNav.type = PostPreViewPhote;
        [self.navigationController pushViewController:postNav animated:YES];
    }];
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
    [self dismissViewControllerAnimated:YES completion:^(void){
        NSLog(@"dismiss CV controller");
    }];
}
@end
