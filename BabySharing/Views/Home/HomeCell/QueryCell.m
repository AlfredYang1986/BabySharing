//
//  QueryCell.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 9/01/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "QueryCell.h"
#import <MediaPlayer/MediaPlayer.h>
#import "MoviePlayTrait.h"
#import <AVFoundation/AVFoundation.h>

#define HER_MARGIN  16
#define VER_MARGIN  1

#define IMG_HEIGHT  226

@implementation QueryCell {
//    MPMoviePlayerController* movie;
    AVPlayerLayer *avPlayerLayer;
}

@synthesize imgView = _imgView;
@synthesize nameLabel = _nameLabel;
@synthesize likeBtn = _likeBtn;
@synthesize shareBtn = _shareBtn;
@synthesize sharingScoreLabel = _sharingScoreLabel;
@synthesize ownerImg = _ownerImg;
@synthesize timeNumber = _timeNumber;
@synthesize desLabel = _desLabel;
@synthesize tagsLabelView = _tagsLabelView;
@synthesize commentsBtn = _commentsBtn;

@synthesize delegate = _delegate;
@synthesize content = _content;

@synthesize type = _type;
@synthesize movieURL = _movieURL;
@synthesize player = _player;

#pragma mark -- constractor

#pragma mark -- layout
+ (CGFloat)preferredHeight {
//    return VER_MARGIN +
    return 368;
}

- (void)awakeFromNib {
    // Initialization code
    _imgView.contentMode = UIViewContentModeScaleToFill;
    _ownerImg.contentMode = UIViewContentModeScaleToFill;
    
    _imgView.userInteractionEnabled = YES;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didClickImage:)];
    [_imgView addGestureRecognizer:tap];
}

- (void)movieContentWithURL:(NSURL*)url withTriat:(MoviePlayTrait*)trait {
    self.type = PostPreViewMovie;
    self.movieURL = url;
//    self.player = [trait getFreePlayerWithURL:url];
    if (self.player == nil) {
        self.player = [[AVPlayer alloc]initWithURL:url];
    }
//    _type = PostPreViewMovie;
    //视频播放对象
//    CGFloat width = [UIScreen mainScreen].bounds.size.width - HER_MARGIN * 2;
//    CGFloat height = IMG_HEIGHT;
//    _movieURL = url;
//    movie = [MoviePlayTrait createPlayerControllerInRect:CGRectMake(0, 0, width, height) andParentView:_imgView andContentUrl:_movieURL];
//        // 注册一个播放结束的通知
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(movieFinishedCallback:)
//                                                 name:MPMoviePlayerPlaybackDidFinishNotification
//                                               object:movie];
//    
//    movie.view.hidden = YES;
}

- (void)movieFinishedCallback:(NSNotification*)notify {
//    NSLog(@"movie play finished");
//    NSNumber *reason = [notify.userInfo valueForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
//    if (reason != nil){
//        NSInteger reasonAsInteger = [reason integerValue];
//        switch (reasonAsInteger){
//            case MPMovieFinishReasonPlaybackEnded:{
//                /* The movie ended normally */
//                break;
//            }
//            case MPMovieFinishReasonPlaybackError:{
//                /* An error happened and the movie ended */
//                break;
//            }
//            case MPMovieFinishReasonUserExited:{
//                /* The user exited the player */
//                break;
//            }
//        }
//        NSLog(@"Finish Reason = %ld", (long)reasonAsInteger);
//    }
//    
//    //视频播放对象
//    MPMoviePlayerController* theMovie = [notify object];
//    //销毁播放通知
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:MPMoviePlayerPlaybackDidFinishNotification
//                                                  object:theMovie];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)playMovie {
    NSLog(@"play movie");
    if (_type == PostPreViewMovie) {
//        [movie play];
        
        if (avPlayerLayer == nil) {
            avPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
        }
       
        if (![self.layer.sublayers containsObject:avPlayerLayer]) {
            CGFloat width = [UIScreen mainScreen].bounds.size.width - HER_MARGIN * 2;
            CGFloat height = IMG_HEIGHT;
            avPlayerLayer.bounds = CGRectMake(0, 0, width, height);
            avPlayerLayer.frame = CGRectMake(_imgView.frame.origin.x, _imgView.frame.origin.y, width, height);
            avPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
            [self.layer addSublayer:avPlayerLayer];
        }
        _player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
        [_player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
            [_player play];
        }];
    }
}

- (void)stopMovie {
    if (_type == PostPreViewMovie) {
//        [movie stop];
        [_player pause];
        [avPlayerLayer removeFromSuperlayer];
//        avPlayerLayer = nil;
    }
}

#pragma mark -- handler
- (IBAction)didSelectLikeBtn {
    [_delegate didSelectLikeBtn:_content];
}

- (IBAction)didSelectShareBtn {
    [_delegate didSelectShareBtn:_content];
}

- (IBAction)didSelectCommentsBtn {
    [_delegate didSelectCommentsBtn:self];
}

- (void)didClickImage:(UITapGestureRecognizer*)gesture {
    [self playMovie];
}
@end
