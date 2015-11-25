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
#import "INTUAnimationEngine.h"
#import "OBShapedButton.h"

#define HER_MARGIN  8
#define VER_MARGIN  1

#define IMG_HEIGHT  226

#define IMG_OFFSET  100

#define HEADER_MARGIN_TO_SCREEN 8

@implementation QueryCell {
//    MPMoviePlayerController* movie;
    AVPlayerLayer *avPlayerLayer;
    
    UITextView* descriptionView;
    UIView* funcView;
}

@synthesize imgView = _imgView;

@synthesize tagsLabelView = _tagsLabelView;
@synthesize timeLabel = _timeLabel;
@synthesize bkgView = _bkgView;
@synthesize funcBtn = _funcBtn;

@synthesize delegate = _delegate;
@synthesize content = _content;

@synthesize type = _type;
@synthesize movieURL = _movieURL;
@synthesize player = _player;

#pragma mark -- constractor

#pragma mark -- layout
+ (CGFloat)preferredHeightWithDescription:(NSString*)description {
  
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat img_height = [UIScreen mainScreen].bounds.size.height - width / 2 - IMG_OFFSET;
//    if ([description isEqualToString:@""]) {
////        return 340;
//        return img_height + 60
//    }
 
    CGFloat tmp = width / 7.5;
//    CGFloat tmp = width / 3.75;
//    if (width > 350) {
//        tmp = 100;
//    } else {
//        tmp = 80;
//    }
    
    return img_height
         + tmp
         + HER_MARGIN
         + [self getSizeBaseOnDescription:description].height;
}

+ (CGSize)getSizeBaseOnDescription:(NSString*)description {
    UIFont* font = [UIFont systemFontOfSize:14.f];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
   
    /**
     * show all the description
     */
//    return [description sizeWithFont:font constrainedToSize:CGSizeMake(width - HER_MARGIN * 2, FLT_MAX)];

    CGSize size = [description sizeWithFont:font constrainedToSize:CGSizeMake(width - HER_MARGIN * 2 - 134, FLT_MAX)];
    CGSize s = [@"我靠" sizeWithFont:font constrainedToSize:CGSizeMake(width - HER_MARGIN * 2 - 134, FLT_MAX)];
    return CGSizeMake(size.width, s.height);
}

- (void)awakeFromNib {
    // Initialization code
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat img_height = [UIScreen mainScreen].bounds.size.height - width / 2 - IMG_OFFSET;
    _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, img_height)];
    _imgView.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:_imgView];
    
    _imgView.userInteractionEnabled = YES;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didClickImage:)];
    [_imgView addGestureRecognizer:tap];

    _bkgView = [[UIView alloc]initWithFrame:CGRectMake(0, img_height, width, self.frame.size.height - img_height)];
    [self addSubview:_bkgView];
    
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    NSString * filePath = [resourceBundle pathForResource:[NSString stringWithFormat:@"Plus"] ofType:@"png"];
    
    _funcBtn = [[UIButton alloc]initWithFrame:CGRectMake(width - 38, 8, 30, 30)];
    [_funcBtn addTarget:self action:@selector(didSelectFuncBtn) forControlEvents:UIControlEventTouchUpInside];
    [_bkgView addSubview:_funcBtn];
    [_funcBtn setImage:[UIImage imageNamed:filePath] forState:UIControlStateNormal];
    
//    _timeLabel= [[UILabel alloc]initWithFrame:CGRectMake(16, 30, width, 30)];
//    _timeLabel.font = [UIFont systemFontOfSize:11.f];
//    [_bkgView addSubview:_timeLabel];
//    
//    UIImageView* tagIcon = [[UIImageView alloc]initWithFrame:CGRectMake(16, 39 + 30, 30, 30)];
//    tagIcon.contentMode = UIViewContentModeCenter;
//    NSString * filePathIcon = [resourceBundle pathForResource:[NSString stringWithFormat:@"TagSearchSelected"] ofType:@"png"];
//    tagIcon.image = [UIImage imageNamed:filePathIcon];
//    [_bkgView addSubview:tagIcon];
//    
//    _tagsLabelView = [[UILabel alloc]initWithFrame:CGRectMake(16 + 30 + 8, 34 + 30, width, 30)];
//    _tagsLabelView.font = [UIFont systemFontOfSize:13.f];
//    [_bkgView addSubview:_tagsLabelView];
}

- (void)layoutSubviews {
//    [super layoutSubviews];
    
//    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat width = self.bounds.size.width;
    CGFloat img_height = [UIScreen mainScreen].bounds.size.height - width / 2 - IMG_OFFSET;
    _imgView.frame = CGRectMake(0, 0, width, img_height);
    _bkgView.frame = CGRectMake(0, img_height, width, self.frame.size.height - img_height);
    _funcBtn.frame = CGRectMake(width - 38, 8, 30, 30);
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
    } else {
//        [self commentsBtnSelected];
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
- (void)didClickImage:(UITapGestureRecognizer*)gesture {
    [self playMovie];
}

#pragma mark -- set values
- (void)setTime:(NSDate*)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.formatterBehavior = NSDateFormatterBehavior10_4;
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    NSString *result = [formatter stringForObjectValue:date];
    _timeLabel.text = result;
}

- (void)setTags:(NSString*)tags {
    _tagsLabelView.text = tags;
}

- (void)setDescription:(NSString*)description {
    if (descriptionView == nil) {
        descriptionView = [[UITextView alloc]init];
        [_bkgView addSubview:descriptionView];
        descriptionView.editable = NO;
        descriptionView.scrollEnabled = NO;
    }
   
    /**
     * show all text
     */
//    CGSize size = [QueryCell getSizeBaseOnDescription:description];
//    descriptionView.frame = CGRectMake(HER_MARGIN, HER_MARGIN, [UIScreen mainScreen].bounds.size.width - HER_MARGIN * 2, size.height);
//    descriptionView.text = description;
  
    /**
     * only show first line
     */
    UIFont* font = [UIFont boldSystemFontOfSize:14.f];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGSize size = [description sizeWithFont:font constrainedToSize:CGSizeMake(width - HER_MARGIN * 2 - 134, FLT_MAX)];
    CGSize s = [@"我靠" sizeWithFont:font constrainedToSize:CGSizeMake(width - HER_MARGIN * 2 - 134, FLT_MAX)];
    
    descriptionView.font = font;
    descriptionView.frame = CGRectMake(HER_MARGIN, HER_MARGIN, [UIScreen mainScreen].bounds.size.width - HER_MARGIN * 2 - 134, s.height);
    if (s.height == size.height) {
        descriptionView.text = description;
    } else {
        descriptionView.text = [[description substringToIndex:10] stringByAppendingString:@"..."];
    }
    [descriptionView sizeToFit];
}

- (IBAction)didSelectFuncBtn {
    
    static const CGFloat kAnimationDuration = 0.5; // in seconds
    
    if (funcView == nil) {
        funcView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 100)];

        /**
         * option:1 shaped Btn
         */
//        OBShapedButton* btn = [[OBShapedButton alloc]initWithFrame:CGRectMake(5, 0, 60, 50)];
//        
//        NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
//        NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
//        [btn setBackgroundImage:[UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"Funcleaf"] ofType:@"png"]] forState:UIControlStateNormal];
//        [btn setImage:[UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"Cycle"] ofType:@"png"]] forState:UIControlStateNormal];
//       
//        btn.transform = CGAffineTransformMakeRotation(M_PI + M_PI_4 / 2);
//        [funcView addSubview:btn];
//        
//        OBShapedButton* btn2 = [[OBShapedButton alloc]initWithFrame:CGRectMake(20, -20, 60, 50)];
//        
//        [btn2 setBackgroundImage:[UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"Funcleaf"] ofType:@"png"]] forState:UIControlStateNormal];
//        [btn2 setImage:[UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"Push"] ofType:@"png"]] forState:UIControlStateNormal];
//        
//        btn2.transform = CGAffineTransformMakeRotation(M_PI + M_PI_4 / 2 * 3);
//        [funcView addSubview:btn2];


        /**
         * option:2 paneal
         */
        funcView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 32 * 3, 32)];

        NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
        NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
        
        UIButton* didnotlikeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 32, 32)];
        [didnotlikeBtn addTarget:self action:@selector(notLikeBtnSelected) forControlEvents:UIControlEventTouchDown];
        [didnotlikeBtn setImage:[UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"Cross"] ofType:@"png"]] forState:UIControlStateNormal];
        UIButton* collectBtn = [[UIButton alloc]initWithFrame:CGRectMake(32, 0, 32, 32)];
        [collectBtn setImage:[UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"Star"] ofType:@"png"]] forState:UIControlStateNormal];
        [collectBtn addTarget:self action:@selector(collectBtnSelected) forControlEvents:UIControlEventTouchDown];
        UIButton* commentsBtn = [[UIButton alloc]initWithFrame:CGRectMake(32 * 2, 0, 32, 32)];
        [commentsBtn setImage:[UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"Comments"] ofType:@"png"]] forState:UIControlStateNormal];
        [commentsBtn addTarget:self action:@selector(commentsBtnSelected) forControlEvents:UIControlEventTouchDown];
        
        [funcView addSubview:didnotlikeBtn];
        [funcView addSubview:collectBtn];
        [funcView addSubview:commentsBtn];
//
        [_bkgView addSubview:funcView];
        funcView.frame = CGRectMake(_funcBtn.frame.origin.x - 32 * 3 - 8, _funcBtn.frame.origin.y, 32 * 3, 32);
//        funcView.frame = CGRectMake(_funcBtn.frame.origin.x - 45, _funcBtn.frame.origin.y - 20, 60, 50);
//
        funcView.hidden = YES;
        [_bkgView bringSubviewToFront:funcView];
        [_bkgView bringSubviewToFront:_funcBtn];
    }
    
    if ([funcView isHidden]) {
        funcView.hidden = NO;
        [INTUAnimationEngine animateWithDuration:kAnimationDuration
                                           delay:0.0
                                          easing:INTUEaseInOutQuadratic
                                         options:INTUAnimationOptionNone
                                      animations:^(CGFloat progress) {
                                          CGFloat rotationAngle = INTUInterpolateCGFloat(0, M_PI_4, progress);
                                          _funcBtn.transform = CGAffineTransformMakeRotation(rotationAngle);
                                      }
                                      completion:^(BOOL finished) {
                                          NSLog(@"%@", finished ? @"Animation Completed" : @"Animation Canceled");
                                      }];
    } else {
        funcView.hidden = YES;
        [INTUAnimationEngine animateWithDuration:kAnimationDuration
                                           delay:0.0
                                          easing:INTUEaseInOutQuadratic
                                         options:INTUAnimationOptionNone
                                      animations:^(CGFloat progress) {
                                          CGFloat rotationAngle = INTUInterpolateCGFloat(M_PI_4, 0, progress);
                                          _funcBtn.transform = CGAffineTransformMakeRotation(rotationAngle);
                                      }
                                      completion:^(BOOL finished) {
                                          NSLog(@"%@", finished ? @"Animation Completed" : @"Animation Canceled");
                                      }];
    }
}

- (void)notLikeBtnSelected {
    [_delegate didSelectNotLikeBtn:_content];
}

- (void)collectBtnSelected {
    [_delegate didSelectCollectionBtn:_content];
}

- (void)commentsBtnSelected {
//    [_delegate didSelectCommentsBtn:self];
}

- (void)disappearFuncView {
    funcView.hidden = YES;
//    CGFloat rotationAngle = INTUInterpolateCGFloat(M_PI_4, 0, progress);
    _funcBtn.transform = CGAffineTransformMakeRotation(0);
    _funcBtn.hidden = NO;
}
@end
