//
//  MoviePlayTrait.m
//  MergeMovieFiles
//
//  Created by Alfred Yang on 26/05/2015.
//  Copyright (c) 2015 BS. All rights reserved.
//

#import "MoviePlayTrait.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "TmpFileStorageModel.h"

@interface MoviePlayTrait ()
@property (nonatomic, strong) NSMutableArray* players;
@end

@implementation MoviePlayTrait

@synthesize players = _players;
@synthesize delegate = _delegate;
- (id)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
    return self;
}

#pragma mark -- play movie full screen or in on controller
- (void)playMovieInURL:(NSURL*)url InParent:(UIViewController*)controller {
    MPMoviePlayerViewController *moviePlayer =[[MPMoviePlayerViewController alloc] initWithContentURL:url];
    
    [moviePlayer.moviePlayer prepareToPlay];
    
    [controller presentMoviePlayerViewControllerAnimated:moviePlayer]; // 这里是presentMoviePlayerViewControllerAnimated
    
    [moviePlayer.moviePlayer setControlStyle:MPMovieControlStyleFullscreen];
    
    [moviePlayer.view setBackgroundColor:[UIColor clearColor]];
    
    [moviePlayer.view setFrame:controller.view.bounds];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                            selector:@selector(finish:)
                                            name:MPMoviePlayerPlaybackDidFinishNotification
                                            object:moviePlayer];
    
    [moviePlayer.moviePlayer play];
    
}

- (void)finish:(NSNotification*)notify {
    MPMoviePlayerViewController* theMovie = [notify object];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                   name:MPMoviePlayerPlaybackDidFinishNotification
                                                    object:theMovie];
    
    [_delegate playFinished];
    [theMovie dismissMoviePlayerViewControllerAnimated];
}

#pragma mark -- merge movies
- (void)MergeAndSave:(NSURL*)url1 and:(NSURL*)url2 withAudio:(NSURL*)url3 {
    
    // 0 - load asset
    AVAsset* firstAsset = [AVAsset assetWithURL:url1];
    AVAsset* secondAsset = [AVAsset assetWithURL:url2];
    AVAsset* audioAsset = nil;
    if (url3 != nil) {
        audioAsset = [AVAsset assetWithURL:url3];
    }

    // 1 - Create AVMutableComposition object. This object will hold your AVMutableCompositionTrack instances.
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    // 2 - Video track
    AVMutableCompositionTrack *firstTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                        preferredTrackID:kCMPersistentTrackID_Invalid];
    [firstTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, firstAsset.duration)
                        ofTrack:[[firstAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];
    [firstTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, secondAsset.duration)
                        ofTrack:[[secondAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:firstAsset.duration error:nil];
    // 3 - Audio track
    if (audioAsset!=nil){
        AVMutableCompositionTrack *AudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                            preferredTrackID:kCMPersistentTrackID_Invalid];
        [AudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, CMTimeAdd(firstAsset.duration, secondAsset.duration))
                            ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:nil];
    }
    // 4 - Get path
    NSString* strDir = [TmpFileStorageModel BMTmpMovieDir];
    NSString *testfile = [strDir stringByAppendingPathComponent:[TmpFileStorageModel generateFileName]];
    NSString *path = [testfile stringByAppendingPathExtension:@"mp4"];
    
    NSURL *url = [NSURL fileURLWithPath:path];
    // 5 - Create exporter
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition
                                                                      presetName:AVAssetExportPresetHighestQuality];
    exporter.outputURL=url;
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    exporter.shouldOptimizeForNetworkUse = YES;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self exportDidFinish:exporter];
        });
    }];
}

- (void)mergeMultipleAssertWithURLs:(NSArray*)arr andAudio:(NSURL*)audioUrl {
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    CMTime time = kCMTimeZero;
    
    for (int index = 0; index < arr.count; ++index) {
        AVAsset* tmp  = [AVAsset assetWithURL:[arr objectAtIndex:index]];
        if (index == 0) {
            time = tmp.duration;
            time.value = 0;
        }
        [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, tmp.duration)
                            ofTrack:[[tmp tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:time error:nil];
        
        // only works when this is no 加速 减速
        if (index == 0) {
            time = tmp.duration;
        } else {
            time.value += tmp.duration.value;
        }
    }
   
    if (audioUrl != nil) {
        AVAsset* audioAsset = [AVAsset assetWithURL:audioUrl];
        AVMutableCompositionTrack *AudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                            preferredTrackID:kCMPersistentTrackID_Invalid];
        [AudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, CMTimeAdd(kCMTimeZero, time))
                            ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:nil];
    }
    
    NSString* strDir = [TmpFileStorageModel BMTmpMovieDir];
    NSString *testfile = [strDir stringByAppendingPathComponent:[TmpFileStorageModel generateFileName]];
    NSString *path = [testfile stringByAppendingPathExtension:@"mp4"];
    
    NSURL *url = [NSURL fileURLWithPath:path];
    // 5 - Create exporter
//    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetMediumQuality];
//    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetLowQuality];

    exporter.outputURL=url;
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    exporter.shouldOptimizeForNetworkUse = YES;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self exportDidFinish:exporter];
        });
    }];
}

- (void)exportDidFinish:(AVAssetExportSession*)session {
    if (session.status == AVAssetExportSessionStatusCompleted) {
        NSURL *outputURL = session.outputURL;
        [_delegate MergeMovieSuccessfulWithFinalURL:outputURL];
 
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:outputURL]) {
            [library writeVideoAtPathToSavedPhotosAlbum:outputURL completionBlock:^(NSURL *assetURL, NSError *error){
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error) {
//                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Video Saving Failed"
//                                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                        [alert show];
                        NSLog(@"Video Saving Failed");
                    } else {
//                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Video Saved" message:@"Saved To Photo Album"
//                                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                        [alert show];
                        NSLog(@"Video Saving success");
                    }
                });
            }];
        }
    }
}

#pragma mark -- compress photos and movies
- (UIImage*)compressPhoto:(UIImage*)sourceImage withSize:(CGSize)size {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)compressMovieFromURL:(NSURL*)sourceURL {
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:sourceURL options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    if ([compatiblePresets containsObject:AVAssetExportPresetMediumQuality] || [compatiblePresets containsObject:AVAssetExportPresetHighestQuality]) {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetLowQuality];
        
        NSString* strDir = [TmpFileStorageModel BMTmpMovieDir];
        NSString *testfile = [strDir stringByAppendingPathComponent:[TmpFileStorageModel generateFileName]];
        NSString* path = [testfile stringByAppendingPathExtension:@"mp4"];
        
        exportSession.outputURL = [NSURL fileURLWithPath:path];
        exportSession.outputFileType = AVFileTypeMPEG4;
        [exportSession exportAsynchronouslyWithCompletionHandler:^(void)
         {
             switch (exportSession.status) {
                 case AVAssetExportSessionStatusUnknown:
                     NSLog(@"AVAssetExportSessionStatusUnknown");
                     break;
                 case AVAssetExportSessionStatusWaiting:
                     NSLog(@"AVAssetExportSessionStatusWaiting");
                     break;
                 case AVAssetExportSessionStatusExporting:
                     NSLog(@"AVAssetExportSessionStatusExporting");
                     [_delegate compressMovieProcess:100];
                     break;
                 case AVAssetExportSessionStatusCompleted:
                     NSLog(@"AVAssetExportSessionStatusCompleted");
                     [_delegate compressMovieSuccess:exportSession.outputURL];
                     break;
                 case AVAssetExportSessionStatusFailed:
                     NSLog(@"AVAssetExportSessionStatusFailed");
                     break;
                 case AVAssetExportSessionStatusCancelled:
                     NSLog(@"AVAssetExportSessionStatusCancelled");
                     break;
             }
         }];
    }
}

#pragma mark -- get avasst size
- (CGFloat)fileSizeFromPath:(NSString*)path {
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    float filesize = -1.0;
    if ([fileManager fileExistsAtPath:path]) {
        NSDictionary *fileDic = [fileManager attributesOfItemAtPath:path error:nil];//获取文件的属性
        unsigned long long size = [[fileDic objectForKey:NSFileSize] longLongValue];
        filesize = 1.0*size/1024;
    }
    return filesize;   // KB
}

- (CGFloat)photoSize:(UIImage*)img {
    return img.size.width * img.size.height;
}

#pragma mark -- movie play
+ (MPMoviePlayerController*)createPlayerControllerInRect:(CGRect)rc andParentView:(UIView*)view andContentUrl:(NSURL*)url {
    MPMoviePlayerController* re = [[MPMoviePlayerController alloc] initWithContentURL:url];
    re.controlStyle = MPMovieControlStyleNone;
    re.scalingMode = MPMovieScalingModeFill;
    re.repeatMode = MPMovieRepeatModeOne;
    re.initialPlaybackTime = -1;
    [view addSubview:re.view];
    re.view.frame = rc;
    return re;
}

#pragma mark -- multiple play in the same controller
- (AVPlayer*)getFreePlayerWithURL:(NSURL*)url {
    if (_players == nil) {
        _players = [[NSMutableArray alloc]init];
    }

    AVPlayer* p = nil;
    // any player with the same url
    for (NSDictionary* iter in _players) {
        if ([[[iter objectForKey:@"url"] absoluteString]isEqualToString:[url absoluteString]]) {
            p = [iter objectForKey:@"player"];
            return p;
        }
    }
   
    // any player is available
    for (NSDictionary* iter in _players) {
        if (((NSNumber*)[iter objectForKey:@"available"]).boolValue) {
            p = [iter objectForKey:@"player"];
            AVPlayerItem* newItem = [[AVPlayerItem alloc]initWithURL:url];
            [p.currentItem removeObserver:self forKeyPath:@"status"];
            [p replaceCurrentItemWithPlayerItem:newItem];
//            [p.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];// 监听status属性
            [iter setValue:url forKey:@"url"];
            [iter setValue:[NSNumber numberWithBool:NO]  forKey:@"available"];
            return p;
        }
    }
   
    // new player
    p = [[AVPlayer alloc]initWithURL:url];
//    [p.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];// 监听status属性
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:url forKey:@"url"];
    [dic setValue:[NSNumber numberWithBool:NO]  forKey:@"available"];
    [dic setValue:p forKey:@"player"];
    [_players addObject:dic];
    
    return p;
}

- (void)moviePlayDidEnd:(NSNotification*)notify {
    for (NSDictionary* iter in _players) {
        AVPlayer* p = [iter objectForKey:@"player"];
        if ([p.currentItem currentTime].value != 0) {
            [p play];
        }
    }
}

- (void)AvailableForPlayer:(AVPlayer*)p {
    for (NSDictionary* iter in _players) {
        if ([iter objectForKey:@"player"] == p) {
            [p pause];
//            [p.currentItem removeObserver:self forKeyPath:@"status"];
            [p replaceCurrentItemWithPlayerItem:nil];
            [iter setValue:[NSNumber numberWithBool:YES] forKey:@"available"];
            [iter setValue:[NSURL URLWithString:@"unset"] forKey:@"url"];
        }
    }
}
@end
