//
//  MoviePlayTrait.h
//  MergeMovieFiles
//
//  Created by Alfred Yang on 26/05/2015.
//  Copyright (c) 2015 BS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class MPMoviePlayerController;
@class AVPlayer;

@protocol MovieActionProtocol <NSObject>

#pragma mark -- merge
- (void)MergeMovieSuccessfulWithFinalURL:(NSURL*)url;
@optional
- (void)MergeMovieWithError:(NSError*)error;

#pragma mark -- play movie
@optional
- (void)playStatedChanged:(NSNotification*)notify;
- (void)playFinished;

#pragma mark -- compress movie and photo
@optional
- (void)compressMovieSuccess:(NSURL*)url;
- (void)compressMovieFailed;
- (void)compressMovieProcess:(CGFloat)progress;
@end

@interface MoviePlayTrait : NSObject
@property (nonatomic, weak) id<MovieActionProtocol> delegate;

#pragma mark -- play movie full screen or in on controller
- (void)playMovieInURL:(NSURL*)url InParent:(UIViewController*)controller;

#pragma mark -- merge movies
- (void)MergeAndSave:(NSURL*)url1 and:(NSURL*)url2 withAudio:(NSURL*)url3;
- (void)mergeMultipleAssertWithURLs:(NSArray*)arr andAudio:(NSURL*)audioUrl;

#pragma mark -- compress photos and movies
- (UIImage*)compressPhoto:(UIImage*)img withSize:(CGSize)size;
- (void)compressMovieFromURL:(NSURL*)url;

#pragma mark -- get avasst size
- (CGFloat)fileSizeFromPath:(NSString*)path;
- (CGFloat)photoSize:(UIImage*)img;

#pragma mark -- movie play 
+ (MPMoviePlayerController*)createPlayerControllerInRect:(CGRect)rc andParentView:(UIView*)view andContentUrl:(NSURL*)url;

#pragma mark -- multiple play in the same controller
- (AVPlayer*)getFreePlayerWithURL:(NSURL*)url;
- (void)AvailableForPlayer:(AVPlayer*)p;
@end
