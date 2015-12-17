//
//  PostPublichViewController.m
//  BabySharing
//
//  Created by Alfred Yang on 12/17/15.
//  Copyright © 2015 BM. All rights reserved.
//

#import "PostPublichViewController.h"
#import "AppDelegate.h"
#import "LoginModel.h"
#import "PostModel.h"
#import "PhotoTagView.h"
#import <AVFoundation/AVFoundation.h>
#import "SearchSegView2.h"
#import "INTUAnimationEngine.h"

#define FAKE_NAVIGATION_BAR_HEIGHT  44
#define SNS_BUTTON_WIDTH            25
#define SNS_BUTTON_HEIGHT           SNS_BUTTON_WIDTH

#define WECHAT_BTN                  0
#define WEIBO_BTN                   1
#define QQ_BTN                      2

#define SNS_BTN_COUNT               3

@interface PostPublichViewController () <UITextViewDelegate>
@property (nonatomic, strong) UITextView* descriptionView;
@property (nonatomic) BOOL isShareWeibo;
@property (nonatomic) BOOL isShareWechat;
@property (nonatomic) BOOL isShareQQ;
@end

@implementation PostPublichViewController {
    CGFloat aspectRatio;
    UIView* mainContentView;
    
    /***********************************************************************/
    // photo
    CALayer* img_layer;
    /***********************************************************************/
    // movie
    AVPlayer* player;
    AVPlayerLayer *avPlayerLayer;
    /***********************************************************************/
    
    /***********************************************************************/
    // fake bar
    UIView* bar;
    /***********************************************************************/
    
    /***********************************************************************/
    // last line bar
    UIView* SNS_bar;
    /***********************************************************************/
    
    /***********************************************************************/
    // sns share btn
    NSArray* sns_buttons;
    /***********************************************************************/

    /***********************************************************************/
    // place holder
    UILabel* placeholder;
    /***********************************************************************/
}

@synthesize descriptionView = _descriptionView;
@synthesize preViewImg = _preViewImg;
@synthesize already_taged = _already_taged;
@synthesize movie_url = _movie_url;
@synthesize type = _type;

@synthesize isShareQQ = _isShareQQ;
@synthesize isShareWechat = _isShareWechat;
@synthesize isShareWeibo = _isShareWeibo;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    aspectRatio = 4.0 / 3.0;
    
    CGFloat img_height = width * aspectRatio;
    
    /***************************************************************************************/
    /**
     * main content view
     */
    mainContentView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, img_height)];
    mainContentView.backgroundColor = [UIColor clearColor];
    mainContentView.userInteractionEnabled = YES;
    [self.view addSubview:mainContentView];
    img_layer = [CALayer layer];
    img_layer.frame = mainContentView.bounds;
    img_layer.contents = (id)_preViewImg.CGImage;
    [mainContentView.layer addSublayer:img_layer];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    [mainContentView addGestureRecognizer:tap];
    
    /***************************************************************************************/
    // movie
    if (_type == PostPreViewMovie) {
        
        if (player == nil) {
            player = [[AVPlayer alloc]init];
            avPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
        }
        
        if (![mainContentView.layer.sublayers containsObject:avPlayerLayer]) {
            avPlayerLayer.frame = mainContentView.bounds;
            avPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
            [mainContentView.layer addSublayer:avPlayerLayer];
        }
        
        //        [player.currentItem removeObserver:self forKeyPath:@"status"];
        
        AVPlayerItem* tmp = [AVPlayerItem playerItemWithURL:_movie_url];
        //        [tmp addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];// 监听status属性
        //        [tmp addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];// 监听loadedTimeRanges属性
        //        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:tmp];
        [player replaceCurrentItemWithPlayerItem:tmp];
        
        player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    }
    /***************************************************************************************/
    
    /***************************************************************************************/
    /**
     * fake navigation bar
     */
    bar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, FAKE_NAVIGATION_BAR_HEIGHT)];
    bar.backgroundColor = [UIColor colorWithRed:0.1373 green:0.1216 blue:0.1255 alpha:1.f];
    [self.view addSubview:bar];
    [self.view bringSubviewToFront:bar];
    
    UIButton* barBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    
    barBtn.center = CGPointMake(30 / 2 + 16, 49 / 2);
    
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    NSString* filepath = [resourceBundle pathForResource:@"Previous_simple" ofType:@"png"];
    
    CALayer * layer = [CALayer layer];
    layer.contents = (id)[UIImage imageNamed:filepath].CGImage;
    layer.frame = CGRectMake(0, 0, 15, 21);
    layer.position = CGPointMake(30 / 2, 30 / 2);
    [barBtn.layer addSublayer:layer];
    [barBtn addTarget:self action:@selector(didPopControllerSelected) forControlEvents:UIControlEventTouchDown];
    [bar addSubview:barBtn];
    
    UILabel* titleView = [[UILabel alloc]init];
    titleView.tag = -1;
    titleView.textAlignment = NSTextAlignmentCenter;
    titleView.text = @"编辑图片";
    titleView.textColor = [UIColor whiteColor];
    [titleView sizeToFit];
    titleView.center = CGPointMake(width / 2, 49 / 2);
    [bar addSubview:titleView];
    
    UIButton* bar_right_btn = [[UIButton alloc]initWithFrame:CGRectMake(width - 13 - 41, 25, 50, 30)];
    [bar_right_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bar_right_btn setTitle:@"发布" forState:UIControlStateNormal];
    bar_right_btn.backgroundColor = [UIColor colorWithRed:0.3126 green:0.7529 blue:0.6941 alpha:1.f];
    bar_right_btn.layer.cornerRadius = 4.f;
    bar_right_btn.clipsToBounds = YES;
//    [bar_right_btn sizeToFit];
    [bar_right_btn addTarget:self action:@selector(didSelectPostBtn) forControlEvents:UIControlEventTouchUpInside];
    bar_right_btn.center = CGPointMake(width - 8 - bar_right_btn.frame.size.width / 2, FAKE_NAVIGATION_BAR_HEIGHT / 2);
    [bar addSubview:bar_right_btn];
    /***************************************************************************************/
    
    /***************************************************************************************/
    /**
     * description view
     */
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    _descriptionView = [[UITextView alloc]initWithFrame:CGRectMake(0, img_height, width, height - img_height - 44)];
    _descriptionView.delegate = self;
    _descriptionView.editable = YES;
    [self.view addSubview:_descriptionView];
  
    placeholder = [[UILabel alloc]init];
    placeholder.textColor = [UIColor darkGrayColor];
    placeholder.text = @"添加照片说明";
    [placeholder sizeToFit];
    placeholder.center = CGPointMake(_descriptionView.frame.size.width / 2, _descriptionView.frame.size.height / 2);
    [_descriptionView addSubview:placeholder];
    /***************************************************************************************/

    /***************************************************************************************/
    /**
     * SNS view
     */
    SNS_bar = [[UIView alloc]initWithFrame:CGRectMake(0, height - 44, width, 44)];
    SNS_bar.backgroundColor = [UIColor blackColor];
    
    UILabel* label = [[UILabel alloc]init];
    label.textColor = [UIColor whiteColor];
    label.text = @"同步到";
    [label sizeToFit];
    CGFloat margin = 20;
    label.center = CGPointMake(width / 2 - margin - label.frame.size.width, 22);
    [SNS_bar addSubview:label];
   
    UIButton* wechat_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SNS_BUTTON_WIDTH, SNS_BUTTON_HEIGHT)];
    NSString * wechat_file = [resourceBundle pathForResource:[NSString stringWithFormat:@"wechat"] ofType:@"png"];
    UIImage * wechat_image = [UIImage imageNamed:wechat_file];
    [wechat_btn setBackgroundImage:wechat_image forState:UIControlStateNormal];
    [wechat_btn addTarget:self action:@selector(SNSBtnSelected:) forControlEvents:UIControlEventTouchDown];
    wechat_btn.backgroundColor = [UIColor clearColor];
    //    weibo_btn.layer.cornerRadius = SNS_BUTTON_WIDTH / 2;
    //    weibo_btn.clipsToBounds = YES;
    //    weibo_btn.contentMode = UIViewContentModeCenter;
    wechat_btn.center = CGPointMake(width / 2 + 40 - margin, 22);
    [SNS_bar addSubview:wechat_btn];
    
    UIButton* qq_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SNS_BUTTON_WIDTH, SNS_BUTTON_HEIGHT)];
    NSString * qq_file = [resourceBundle pathForResource:[NSString stringWithFormat:@"qq"] ofType:@"png"];
    UIImage * qq_image = [UIImage imageNamed:qq_file];
    [qq_btn setBackgroundImage:qq_image forState:UIControlStateNormal];
    [qq_btn addTarget:self action:@selector(SNSBtnSelected:) forControlEvents:UIControlEventTouchDown];
    qq_btn.backgroundColor = [UIColor clearColor];
//    weibo_btn.layer.cornerRadius = SNS_BUTTON_WIDTH / 2;
//    weibo_btn.clipsToBounds = YES;
//    weibo_btn.contentMode = UIViewContentModeCenter;
    qq_btn.center = CGPointMake(width / 2 - margin, 22);
    [SNS_bar addSubview:qq_btn];
    
    UIButton* weibo_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SNS_BUTTON_WIDTH, SNS_BUTTON_HEIGHT)];
    NSString * weibo_file = [resourceBundle pathForResource:[NSString stringWithFormat:@"weibo"] ofType:@"png"];
    UIImage * weibo_image = [UIImage imageNamed:weibo_file];
    [weibo_btn setBackgroundImage:weibo_image forState:UIControlStateNormal];
    [weibo_btn addTarget:self action:@selector(SNSBtnSelected:) forControlEvents:UIControlEventTouchDown];
    weibo_btn.backgroundColor = [UIColor clearColor];
    //    weibo_btn.layer.cornerRadius = SNS_BUTTON_WIDTH / 2;
    //    weibo_btn.clipsToBounds = YES;
    //    weibo_btn.contentMode = UIViewContentModeCenter;
    weibo_btn.center = CGPointMake(width / 2 + 80 - margin, 22);
    [SNS_bar addSubview:weibo_btn];
   
    sns_buttons = @[wechat_btn, weibo_btn, qq_btn];
    [self.view addSubview:SNS_bar];
    /***************************************************************************************/

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissPostViewController) name:@"post success" object:nil];
}

- (void)dismissPostViewController {
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Post Success");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    if (_type == PostPreViewMovie) {
        if (![mainContentView.layer.sublayers containsObject:avPlayerLayer]) {
            avPlayerLayer.frame = mainContentView.bounds;
            avPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
            [mainContentView.layer addSublayer:avPlayerLayer];
        }
        
        if (player.currentItem) {
            if (player.currentItem.status == AVPlayerStatusReadyToPlay) {
                [player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
                    [player play];
                }];
            }
            [player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];// 监听status属性
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:player.currentItem];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_type == PostPreViewMovie) {
        if (player.currentItem) {
            [player.currentItem removeObserver:self forKeyPath:@"status"];
            [player pause];
        }
        if ([mainContentView.layer.sublayers containsObject:avPlayerLayer]) {
            [avPlayerLayer removeFromSuperlayer];
        }
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
    //UIStatusBarStyleDefault = 0 黑色文字，浅色背景时使用
    //UIStatusBarStyleLightContent = 1 白色文字，深色背景时使用
}

- (BOOL)prefersStatusBarHidden {
    return YES; //返回NO表示要显示，返回YES将hiden
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItem* playerItem = player.currentItem;
        if (playerItem.status == AVPlayerStatusReadyToPlay) {
            NSLog(@"AVPlayerStatusReadyToPlay");
            //            CMTime duration = self.playerItem.duration;// 获取视频总长度
            //            CGFloat totalSecond = playerItem.duration.value / playerItem.duration.timescale;// 转换成秒
            //            _totalTime = [self convertTime:totalSecond];// 转换成播放时间
            //            [self customVideoSlider:duration];// 自定义UISlider外观
            //            NSLog(@"movie total duration:%f",CMTimeGetSeconds(duration));
            //            [self monitoringPlayback:self.playerItem];// 监听播放状态
            
            [player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
                [player play];
            }];
            
            
        } else if (playerItem.status == AVPlayerStatusFailed) {
            NSLog(@"AVPlayerStatusFailed");
        }
    }
}

-(void)moviePlayDidEnd:(AVPlayerItem*)item {
    [player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
        [player play];
    }];
}

- (void)didPopControllerSelected {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)handleTap:(UITapGestureRecognizer*)gueture {
    if ([_descriptionView isFirstResponder]) {
        [_descriptionView resignFirstResponder];
        [self moveView:210];
    }
}

- (void)moveView:(float)move {
    static const CGFloat kAnimationDuration = 0.30; // in seconds
    CGPoint p_start = _descriptionView.center;
    CGPoint p_end = CGPointMake(p_start.x, p_start.y + move);
    [INTUAnimationEngine animateWithDuration:kAnimationDuration
                                                          delay:0.0
                                                         easing:INTUEaseInOutQuadratic
                                                        options:INTUAnimationOptionNone
                                                     animations:^(CGFloat progress) {
                                                         _descriptionView.center = INTUInterpolateCGPoint(p_start, p_end, progress);
                                                     }
                                                     completion:^(BOOL finished) {
                                                         // NOTE: When passing INTUAnimationOptionRepeat, this completion block is NOT executed at the end of each cycle. It will only run if the animation is canceled.
                                                         NSLog(@"%@", finished ? @"Animation Completed" : @"Animation Canceled");
                                                     }];
}

- (void)SNSBtnSelected:(UIButton*)btn {

    BOOL tmp;
    if (btn == [sns_buttons objectAtIndex:WECHAT_BTN]) {
        _isShareWechat = !_isShareWechat;
        tmp = _isShareWechat;
    } else if (btn == [sns_buttons objectAtIndex:QQ_BTN]) {
        _isShareQQ = !_isShareQQ;
        tmp = _isShareQQ;
    } else if (btn == [sns_buttons objectAtIndex:WEIBO_BTN])  {
        _isShareWeibo = !_isShareWeibo;
        tmp = _isShareWeibo;
    }

    if (tmp) {
        btn.layer.borderWidth = 1.f;
        btn.layer.borderColor = [UIColor colorWithRed:0.3126 green:0.7529 blue:0.6941 alpha:1.f].CGColor;
    } else {
        btn.layer.borderWidth = 0.f;
    }
}

#pragma mark -- post the content
- (void)didSelectPostBtn {
    NSLog(@"Post Content");
    
    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if (_isShareWeibo) {
        [delegate.lm postContentOnWeiboWithText:_descriptionView.text andImage:_preViewImg];
    }

    PostModel* pm = delegate.pm;
    
    if (_type == PostPreViewPhote) {
        /**
         * create tag dictionary
         */
        NSMutableArray* arr = [[NSMutableArray alloc]init];
        for (PhotoTagView* view in _already_taged) {
            NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
            [dic setObject:[NSNumber numberWithInt:view.type] forKey:@"type"];
            [dic setObject:view.content forKey:@"content"];
            [dic setObject:[NSNumber numberWithFloat:view.offset_x] forKey:@"offsetX"];
            [dic setObject:[NSNumber numberWithFloat:view.offset_y] forKey:@"offsetY"];
            
            [arr addObject:[dic copy]];
        }
        [pm postJsonContentToServieWithTags:[arr copy] andDescription:_descriptionView.text andPhotos:[[NSArray alloc]initWithObjects:_preViewImg, nil]];
        
    } else if (_type == PostPreViewMovie) {
        
        NSString* filename = [_movie_url path];
        if ([filename containsString:@"assert"]) {
            [pm postJsonContentWithFileURL:_movie_url withMessage:_descriptionView.text];
        } else {
            [pm postJsonContentWithFileName:filename withMessage:_descriptionView.text];
        }
    }
}

#pragma mark -- text area delegate
- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length < 1) {
        placeholder.hidden = NO;
    } else {
        placeholder.hidden = YES;
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self moveView:-210];
}
@end
