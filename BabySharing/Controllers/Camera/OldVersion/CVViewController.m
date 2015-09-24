//
//  CVViewController.m
//  CameraDemo
//
//  Created by Alfred Yang on 18/12/2014.
//  Copyright (c) 2014 YY. All rights reserved.
//

#import "CVViewController.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import "TmpFileStorageModel.h"

#define _FPS_INTERVAL 2

#include <stdlib.h>
#include <stdio.h>
#include <sys/time.h>

#import "CVViewController+ImageOpt.h"

static struct timeval _start, _end;

void _tic() {
    gettimeofday(&_start, NULL);
}

double _toc() {
    gettimeofday(&_end, NULL);
    long int e_sec = _end.tv_sec * 1000000 + _end.tv_usec;
    long int s_sec = _start.tv_sec * 1000000 + _start.tv_usec;
    return (double)((e_sec - s_sec) / 1000.0);
}

double _tocp() {
    gettimeofday(&_end, NULL);
    long int e_sec = _end.tv_sec * 1000000 + _end.tv_usec;
    long int s_sec = _start.tv_sec * 1000000 + _start.tv_usec;
    double t = (double)((e_sec - s_sec) / 1000.0);
    printf("%6.3f\n", t);
    return t;
}

@interface CVViewController ()
//@property (weak, nonatomic) IBOutlet UIView *mainView;

@end

@implementation CVViewController

@synthesize delegate    = _delegate;
@synthesize bufferSize  = _bufferSize;
@synthesize actions     = _actions;
//@synthesize mainView = _mainView;
@synthesize takeBtn = _takeBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self prepareWithCameraViewControllerType:BufferGrayColor|BufferSize640x480];
    // Do any additional setup after loading the view.
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:(UIBarButtonSystemItem)UIBarButtonSystemItemCancel target:self action:@selector(dismissCVViewController:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:(UIBarButtonSystemItem)UIBarButtonSystemItemCamera target:self action:@selector(resetCVControllerInput:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark --- public
- (void)startToMeasureFPS {
    fpsTimer = [NSTimer scheduledTimerWithTimeInterval:_FPS_INTERVAL target:self selector:@selector(updateFPS:) userInfo:nil repeats:YES];
}

# pragma mark --- private
- (void)updateFPS:(NSTimer*)timer {
    struct timeval fpsTime;
    gettimeofday(&fpsTime, NULL);
    long int sec = fpsTime.tv_sec * 1000000 + fpsTime.tv_usec;
    double t = (double)((sec) / 1000.0);
    printf("%3.1f FPS\n", (float)frameCounter/(t - fpsTimeStamp)*1000);
    frameCounter = 0;
    fpsTimeStamp = t;
}

- (void)prepareWithCameraViewControllerType:(CameraViewControllerType)value {
    //
    type = value;

    position = CameraViewControllerFront;
//    outputType = CameraViewControllerPicture;
    outputType = CameraViewControllerMovie;
    currentInput = nil;
    
    NSString *sessionPreset = nil;
    int pixelFormat = 0;
    
    // decide camera type
    switch (type & BufferSizeMask) {
        case BufferSize1280x720:
            sessionPreset = AVCaptureSessionPreset1280x720;
            bufferSize = CGSizeMake(1280, 720);
            break;
        case BufferSize640x480:
            sessionPreset = AVCaptureSessionPreset640x480;
            bufferSize = CGSizeMake(640, 480);
            break;
        case BufferSize480x360:
            sessionPreset = AVCaptureSessionPresetMedium;
            bufferSize = CGSizeMake(480, 360);
            break;
        case BufferSize192x144:
            sessionPreset = AVCaptureSessionPresetLow;
            bufferSize = CGSizeMake(192, 144);
            break;
        default:
            sessionPreset = AVCaptureSessionPreset640x480;
            break;
    }
    
    // decide camera pixel type
    switch (type & BufferTypeMask) {
        case BufferGrayColor:
            pixelFormat = kCVPixelFormatType_420YpCbCr8BiPlanarFullRange;
            break;
        case BufferRGBColor:
            pixelFormat = kCVPixelFormatType_32BGRA;
            break;
        default:
            pixelFormat = kCVPixelFormatType_420YpCbCr8BiPlanarFullRange;
            break;
    }
    
    // set background color
//    [self.view setBackgroundColor:[UIColor blackColor]];
    
    NSError *error = nil;
    
    // make capture session
    session = [[AVCaptureSession alloc] init];
   
    // get audio input device
    AVCaptureDevice * audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    AVCaptureDeviceInput * audioInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:&error];
    
    // get default video device
    AVCaptureDevice * videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if ([videoDevice lockForConfiguration:&error]) {
        if ([videoDevice isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus])
            videoDevice.focusMode = AVCaptureFocusModeContinuousAutoFocus;
        if ([videoDevice isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure])
            videoDevice.exposureMode = AVCaptureExposureModeContinuousAutoExposure;
        if ([videoDevice isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance])
            videoDevice.whiteBalanceMode = AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance;
    }
    
    // setup video input
//    AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
    [self resetCVControllerInput:nil];
    
    // setup video output
    NSDictionary *settingInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:pixelFormat] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    
    AVCaptureVideoDataOutput * videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
    [videoDataOutput setAlwaysDiscardsLateVideoFrames:YES];
    [videoDataOutput setVideoSettings:settingInfo];
    
    // support multi-threading
    if ((type & MultiThreadingMask) == SupportMultiThreading) {
        dispatch_queue_t queue = dispatch_queue_create("captureQueue", NULL);
        [videoDataOutput setSampleBufferDelegate:self queue:queue];
    }
    else {
        [videoDataOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    }
    
    // still image capture
    NSDictionary *outputSettings = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    [stillImageOutput setOutputSettings:outputSettings];
    
    // movie capture
    movieOutput = [[AVCaptureMovieFileOutput alloc]init];
    CMTime maxDuration = CMTimeMake(120, 15);
    movieOutput.maxRecordedDuration = maxDuration;
    
    // attach video to session
    [session beginConfiguration];
//    [session addInput:videoInput];
    [session addInput:currentInput];
    [session addInput:audioInput];
    [session addOutput:videoDataOutput];
    [session addOutput:stillImageOutput];
    [session addOutput:movieOutput];
    [session setSessionPreset:sessionPreset];
    [session commitConfiguration];
   
    if ([session.sessionPreset isEqualToString:AVCaptureSessionPreset1280x720]) {
        aspectRatio = 16.0 / 9.0;
    }
    else {
        aspectRatio = 4.0 / 3.0;
    }
    
    // setting preview layer
    previewView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 1024)];
    [previewView setAutoresizingMask:UIViewAutoresizingNone];
    
    previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:session];
//    [self.mainView setBackgroundColor:[UIColor blackColor]];
}

- (id)initWithCameraViewControllerType:(CameraViewControllerType)value {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        [self prepareWithCameraViewControllerType:value];
    }
    return self;
}

- (void)adjustCameraPreviewLayerOrientaion:(UIInterfaceOrientation)orientation {
    switch(orientation) {
        case UIInterfaceOrientationLandscapeLeft:
            previewView.transform = CGAffineTransformMakeRotation(M_PI_2);
            break;
        case UIInterfaceOrientationLandscapeRight:
            previewView.transform = CGAffineTransformMakeRotation(M_PI_2);
            break;
        case UIInterfaceOrientationPortrait:
            previewView.transform = CGAffineTransformMakeRotation(0);
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            previewView.transform = CGAffineTransformMakeRotation(0);
            break;
        default:
            break;
    }
}

- (void)waitForSessionStopRunning {
    // this is magical code
    // if you want to remove session object and preview layer, you have to wait some minitunes like following code.
    // maybe, this is bug.
    while ([session isRunning]) {
        NSLog(@"waiting...");
        [session stopRunning];
        [NSThread sleepForTimeInterval:0.1];
    }
    [previewLayer removeFromSuperlayer];
}

#pragma mark - Override

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        [self prepareWithCameraViewControllerType:BufferGrayColor|BufferSize640x480];
        [self prepareWithCameraViewControllerType:BufferRGBColor|BufferSize640x480];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self prepareWithCameraViewControllerType:BufferRGBColor|BufferSize640x480];
//        [self prepareWithCameraViewControllerType:BufferGrayColor|BufferSize640x480];
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.width * aspectRatio;
    
//    previewLayer.frame = CGRectMake(0, -44, width, height);
    previewLayer.frame = CGRectMake(0, 0, width - 44 / aspectRatio, height - 44);
    [previewView.layer addSublayer:previewLayer];
    previewView.frame = CGRectMake(0, 44, width, height);
    [self.view addSubview:previewView];
    [session startRunning];
    
//    [self adjustCameraPreviewLayerOrientaion:self.interfaceOrientation];
    
    canRotate = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self waitForSessionStopRunning];
    [fpsTimer invalidate];
}

#pragma mark - To support orientaion

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self adjustCameraPreviewLayerOrientaion:toInterfaceOrientation];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // I can't understand the orienation behavior of view controllers.....
    // Recommend that you don't overide this method... or please help me.
    if (canRotate)
        return YES;
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    frameCounter++;
}

- (IBAction)didSelectAblum {
    [self.actions didSelectPhotoAblum:self];

}

- (IBAction)didSelectTake {
  
    if (outputType == CameraViewControllerPicture) {
        /**
         * take pic
         */
        AVCaptureConnection *videoConnection = nil;
   
        for (AVCaptureConnection *connection in stillImageOutput.connections) {
            for (AVCaptureInputPort *port in [connection inputPorts]) {
                if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                    videoConnection = connection;
                    break;
                }
            }
            if (videoConnection) { break; }
        }
    
        [stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
            UIImage* image = [self imageFromSampleBuffer: imageSampleBuffer];
            float width = image.size.width;
            float height = width * aspectRatio;
            float width_2 = self.view.frame.size.width;
            float ig = 66 / width_2 * width;
            CGRect rect = CGRectMake(ig, 0, height - ig, width);
            UIImage* img = [CVViewController CVViewController:self clipImage:image withRect:rect];
            if (img.size.width > img.size.height) {
                img = [CVViewController CVViewController:self rotateImage:img oritation:UIImageOrientationRight];
            }
            UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        }];
        
    } else {

        if (movieOutput.isRecording) {
            /**
             * take stop vedio
             */
            [movieOutput stopRecording];
            NSLog(@"end recording");
            
        } else {
            /**
             * take stop vedio
             */
            NSString* strDir = [TmpFileStorageModel BMTmpMovieDir];
            NSString *testfile = [strDir stringByAppendingPathComponent:[TmpFileStorageModel generateFileName]];
            NSString *path = [testfile stringByAppendingPathExtension:@"mp4"];
            
            NSURL* dis = [NSURL fileURLWithPath:path];
           
            [movieOutput startRecordingToOutputFileURL:dis recordingDelegate:self];
            NSLog(@"start recording");
        }
    }

}

#pragma mark - tack picture

- (UIImage *)imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer
{
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer,0);
    
    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    if (!colorSpace)
    {
        NSLog(@"CGColorSpaceCreateDeviceRGB failure");
        return nil;
    }
    
    // Get the base address of the pixel buffer
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    // Get the data size for contiguous planes of the pixel buffer.
    CGContextRef cgContext = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGImageRef cgImage = CGBitmapContextCreateImage(cgContext);
    
    CGColorSpaceRelease(colorSpace);
    
    // Create and return an image object representing the specified Quartz image
    UIImage* image = [UIImage imageWithCGImage:cgImage scale:1 orientation:UIImageOrientationRight];
    
    CGImageRelease(cgImage);
    
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    
    return image;
}

- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo{
    if (!error) {
        NSLog(@"picture saved with no error.");
    }
    else
    {
        NSLog(@"error occured while saving the picture%@", error);
    }
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error {
    NSLog(@"Save file callback");
    NSLog(@"%@", error);
    
    ALAssetsLibrary* assetsLibrary = [[ALAssetsLibrary alloc] init];
    [assetsLibrary writeVideoAtPathToSavedPhotosAlbum:outputFileURL completionBlock:^(NSURL *assetURL, NSError *error) {
        if (!error) {
            NSLog(@"captured video saved with no error.");
        } else {
            NSLog(@"error occured while saving the video:%@", error);
        }
    }];
}

#pragma mark - get Capture Device

- (AVCaptureDeviceInput*)frontDeviceInput {
    AVCaptureDevice* device = [self deviceWithCaptureDivcePostion:AVCaptureDevicePositionFront];
    
    return [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
}

- (AVCaptureDeviceInput*)backDeviceInput {
     AVCaptureDevice* device = [self deviceWithCaptureDivcePostion:AVCaptureDevicePositionBack];
    
    return [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];   
}

#pragma mark - dismiss CV view

- (void)dismissCVViewController: (id)sender {
    [self dismissViewControllerAnimated:YES completion:^(void){
        NSLog(@"dismiss CV controller");
    }];
}

- (AVCaptureDevice*)deviceWithCaptureDivcePostion: (AVCaptureDevicePosition) p {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
        for ( AVCaptureDevice *device in devices )
            if ( device.position == p)
                return device;
    
    return nil;
    
}

- (void)resetCVControllerInput: (id)sender {
    AVCaptureDeviceInput *videoInput = nil;

    if (position == CameraViewControllerBack) {
        position = CameraViewControllerFront;
        
        AVCaptureDevice* device = [self deviceWithCaptureDivcePostion:AVCaptureDevicePositionFront];

        NSError* error = nil;
        videoInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
        
    } else {
        position = CameraViewControllerBack;

        AVCaptureDevice* device = [self deviceWithCaptureDivcePostion:AVCaptureDevicePositionBack];

        NSError* error = nil;
        videoInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    }

    if (currentInput != nil) {
        [session beginConfiguration];
        [session removeInput:currentInput];
        [session addInput:videoInput];
        [session commitConfiguration];
    }
    
    currentInput = videoInput;
}

- (IBAction)didSwitchInputType:(UISwitch *)sender {
    if (outputType == CameraViewControllerMovie) {
        outputType = CameraViewControllerPicture;
        [_takeBtn setTitle:@"pic" forState:UIControlStateNormal];
    } else {
        outputType = CameraViewControllerMovie;
        [_takeBtn setTitle:@"movie" forState:UIControlStateNormal];
    }
}

@end
