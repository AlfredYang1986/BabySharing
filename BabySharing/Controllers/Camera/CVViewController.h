//
//  CVViewController.h
//  CameraDemo
//
//  Created by Alfred Yang on 18/12/2014.
//  Copyright (c) 2014 YY. All rights reserved.
//

/*
 * Real time image processing framework for iOS
 * CameraViewController.h
 *
 * Copyright (c) Yuichi YOSHIDA, 11/04/20
 * All rights reserved.
 *
 * BSD License
 *
 * Redistribution and use in source and binary forms, with or without modification, are
 * permitted provided that the following conditions are met:
 * - Redistributions of source code must retain the above copyright notice, this list of
 *  conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright notice, this list
 *  of conditions and the following disclaimer in the documentation and/or other materia
 * ls provided with the distribution.
 * - Neither the name of the "Yuichi Yoshida" nor the names of its contributors may be u
 * sed to endorse or promote products derived from this software without specific prior
 * written permission.
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY E
 * XPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES O
 * F MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SH
 * ALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENT
 * AL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROC
 * UREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS I
 * NTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRI
 * CT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF T
 * HE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import <UIKit/UIKit.h>

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreGraphics/CoreGraphics.h>

#ifdef __cplusplus
extern "C" {
#endif
    
    void _tic(void);				// not thread safe
    double _toc(void);
    double _tocp(void);				// with printf
    
    typedef enum _CameraViewControllerType{
        BufferTypeMask				= 0x0f,
        BufferGrayColor				= 0,
        BufferRGBColor				= 1,
    }CameraViewControllerType;
    
    typedef enum _CameraViewControllerSize{
        BufferSizeMask				= 0xf0,
        BufferSize1280x720			= 0 << 4,
        BufferSize640x480			= 1 << 4,
        BufferSize480x360			= 2 << 4,
        BufferSize192x144			= 3 << 4,
    }CameraViewControllerSize;
    
    typedef enum _CameraViewControllerMultiThreading{
        MultiThreadingMask			= 0x100,
        NotSupportMultiThreading	= 0 << 8,
        SupportMultiThreading		= 1 << 8,
    }CameraViewControllerMultiThreading;
   
    typedef enum _CameraViewControllerAction {
        CameraViewControllerPicture         = 0x301,
        CameraViewControllerMovie           = 0x302,
        
    } CameraViewControllerAction;

    
    typedef enum _CameraViewControllerPosition {
        CameraViewControllerFront           = 0x401,
        CameraViewControllerBack            = 0x402,
        
    } CameraViewControllerPosition;
    
#ifdef __cplusplus
}
#endif

@class CVViewController;

@protocol CameraViewControllerDelegate <NSObject>
- (void)didUpdateBufferCameraViewController:(CVViewController*)CameraViewController;
@end

@protocol CameraActionDelegate <NSObject>
- (void)didSelectPhotoAblum: (CVViewController*)cv;
- (void)didCapturePicture: (CVViewController*)cv;
- (void)didStartTakeVedio: (CVViewController*)cv;
- (void)didStopTakeVedio: (CVViewController*)cv;
@end

@interface CVViewController : UIViewController<AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureFileOutputRecordingDelegate> {
    CGSize							bufferSize;
    unsigned char					*buffer;
    AVCaptureSession				*session;
    AVCaptureVideoPreviewLayer		*previewLayer;
    UIView							*previewView;
    float							aspectRatio;
    CameraViewControllerType		type;
    id<CameraViewControllerDelegate>delegate;
    
    // for mesasure frame per second
    NSTimer							*fpsTimer;
    int								frameCounter;
    double							fpsTimeStamp;
    BOOL							canRotate;
    
    CameraViewControllerAction      outputType;
    CameraViewControllerPosition    position;

    AVCaptureStillImageOutput       *stillImageOutput;
    AVCaptureMovieFileOutput        *movieOutput;
    
    AVCaptureDeviceInput            *currentInput;
}

- (id)initWithCameraViewControllerType:(CameraViewControllerType)value;
- (void)startToMeasureFPS;
@property (nonatomic, readonly) CGSize bufferSize;
@property (nonatomic, assign) id <CameraViewControllerDelegate> delegate;

// for actions that take pics and videos
@property (nonatomic, weak) id <CameraActionDelegate> actions;
@property (weak, nonatomic) IBOutlet UIButton *takeBtn;

- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo;
- (void)dismissCVViewController: (id)sender;
- (void)resetCVControllerInput: (id)sender;
@end
