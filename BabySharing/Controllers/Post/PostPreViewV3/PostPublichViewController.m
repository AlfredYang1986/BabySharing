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
#import "Tools.h"
#import "TmpFileStorageModel.h"

#define FAKE_NAVIGATION_BAR_HEIGHT  64
#define SNS_BUTTON_WIDTH            25
#define SNS_BUTTON_HEIGHT           SNS_BUTTON_WIDTH

#define WECHAT_BTN                  0
#define WEIBO_BTN                   1
#define QQ_BTN                      2

#define SNS_BTN_COUNT               3

#define BOTTON_BAR_HEIGHT           74

@interface PostPublichViewController () <UITextViewDelegate>
@property (nonatomic, strong) UITextView* descriptionView;
@property (nonatomic) BOOL isShareWeibo;
@property (nonatomic) BOOL isShareWechat;
@property (nonatomic) BOOL isShareQQ;
@end

@implementation PostPublichViewController {
    CGFloat aspectRatio;
   
    UIView* mainContentContainer;
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
    
    /***********************************************************************/
    // bar actions
    UIButton* bar_back_btn;
    UIButton* bar_publich_btn;
    UIButton* bar_cancel_btn;
    UIButton* bar_save_btn;
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
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.1098 alpha:1.f];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    aspectRatio = 4.0 / 3.0;
    
    CGFloat img_height = width - 10.5 * 2; //width * aspectRatio;
    
    /***************************************************************************************/
    /**
     * main content view
     */
    
#define CARD_CONTENG_MARGIN             10.5
    
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    mainContentContainer = [[UIView alloc]initWithFrame:CGRectMake(CARD_CONTENG_MARGIN, FAKE_NAVIGATION_BAR_HEIGHT, width - 2 * CARD_CONTENG_MARGIN, height - FAKE_NAVIGATION_BAR_HEIGHT - BOTTON_BAR_HEIGHT - CARD_CONTENG_MARGIN)];
    mainContentContainer.layer.cornerRadius = 5.f;
    mainContentContainer.clipsToBounds = YES;
    [self.view addSubview:mainContentContainer];
    
//    mainContentView = [[UIImageView alloc]initWithFrame:CGRectMake(CARD_CONTENG_MARGIN, FAKE_NAVIGATION_BAR_HEIGHT + CARD_CONTENG_MARGIN, width - 2 * CARD_CONTENG_MARGIN, img_height)];
    mainContentView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width - 2 * CARD_CONTENG_MARGIN, img_height)];
    mainContentView.backgroundColor = [UIColor clearColor];
    mainContentView.userInteractionEnabled = YES;
//    [self.view addSubview:mainContentView];
    img_layer = [CALayer layer];
    img_layer.frame = mainContentView.bounds;
    img_layer.contents = (id)_preViewImg.CGImage;
    [mainContentView.layer addSublayer:img_layer];
    [mainContentContainer addSubview:mainContentView];
    
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
//    bar.backgroundColor = [UIColor colorWithRed:0.1373 green:0.1216 blue:0.1255 alpha:1.f];
    bar.backgroundColor = [UIColor colorWithWhite:0.1098 alpha:1.f];
    [self.view addSubview:bar];
    [self.view bringSubviewToFront:bar];
    /***************************************************************************************/

#define CANCEL_BTN_WIDTH            30
#define CANCEL_BTN_HEIGHT           CANCEL_BTN_WIDTH
#define CANCEL_BTN_LEFT_MARGIN      10.5
 
    /***************************************************************************************/
    // back button
    bar_back_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, CANCEL_BTN_WIDTH, CANCEL_BTN_HEIGHT)];
    bar_back_btn.center = CGPointMake(CANCEL_BTN_WIDTH / 2 + CANCEL_BTN_LEFT_MARGIN, FAKE_NAVIGATION_BAR_HEIGHT / 2);
    
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    NSString* filepath = [resourceBundle pathForResource:@"dongda_back_light" ofType:@"png"];
    
#define CANCEL_ICON_WIDTH            22
#define CANCEL_ICON_HEIGHT           CANCEL_ICON_WIDTH
    
    CALayer * layer = [CALayer layer];
    layer.contents = (id)[UIImage imageNamed:filepath].CGImage;
    layer.frame = CGRectMake(0, 0, CANCEL_ICON_WIDTH, CANCEL_ICON_HEIGHT);
    layer.position = CGPointMake(CANCEL_ICON_WIDTH / 2, CANCEL_BTN_HEIGHT / 2);
    [bar_back_btn.layer addSublayer:layer];
//    [barBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [barBtn setTitle:@"取消" forState:UIControlStateNormal];
    
    [bar_back_btn addTarget:self action:@selector(didPopControllerSelected) forControlEvents:UIControlEventTouchDown];
    [bar addSubview:bar_back_btn];
    /***************************************************************************************/
    
    /***************************************************************************************/
    // title view
    UILabel* titleView = [[UILabel alloc]init];
    titleView.tag = -1;
    titleView.textAlignment = NSTextAlignmentCenter;
    titleView.font = [UIFont systemFontOfSize:18.f];
    titleView.text = @"编辑图片";
    titleView.textColor = [UIColor whiteColor];
    [titleView sizeToFit];
    titleView.center = CGPointMake(width / 2, FAKE_NAVIGATION_BAR_HEIGHT / 2);
    [bar addSubview:titleView];
    /***************************************************************************************/
    
    /***************************************************************************************/
    // public btn
    bar_publich_btn = [[UIButton alloc]initWithFrame:CGRectMake(width - 10.5 - 50, 25, 50, 30)];
    [bar_publich_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bar_publich_btn setTitle:@"发布" forState:UIControlStateNormal];
    bar_publich_btn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [bar_publich_btn setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:0.3126 green:0.7529 blue:0.6941 alpha:1.F] size:CGSizeMake(bar_publich_btn.bounds.size.width, bar_publich_btn.bounds.size.height)] forState:UIControlStateNormal];
    [bar_publich_btn setBackgroundImage:[self imageWithColor:[UIColor darkGrayColor] size:CGSizeMake(bar_publich_btn.bounds.size.width, bar_publich_btn.bounds.size.height)] forState:UIControlStateDisabled];
    bar_publich_btn.layer.cornerRadius = 4.f;
    bar_publich_btn.clipsToBounds = YES;
//    [bar_right_btn sizeToFit];
    [bar_publich_btn addTarget:self action:@selector(didSelectPostBtn) forControlEvents:UIControlEventTouchUpInside];
    bar_publich_btn.center = CGPointMake(width - 10 - bar_publich_btn.frame.size.width / 2, FAKE_NAVIGATION_BAR_HEIGHT / 2);
    [bar addSubview:bar_publich_btn];
//    bar_publich_btn.enabled = NO;
    /***************************************************************************************/

    /***************************************************************************************/
    // cancel btn
    bar_cancel_btn = [[UIButton alloc]init];
    [bar_cancel_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bar_cancel_btn setTitle:@"取消" forState:UIControlStateNormal];
    bar_cancel_btn.backgroundColor = [UIColor colorWithWhite:0.1098 alpha:1.f];
    [bar_cancel_btn sizeToFit];
    [bar_cancel_btn addTarget:self action:@selector(didSelectCancelBtn) forControlEvents:UIControlEventTouchUpInside];
    bar_cancel_btn.frame = CGRectMake(bar_back_btn.frame.origin.x, bar_back_btn.frame.origin.y, bar_cancel_btn.bounds.size.width, bar_cancel_btn.bounds.size.height);
    bar_cancel_btn.hidden = YES;
    [bar addSubview:bar_cancel_btn];
    /***************************************************************************************/
    
    /***************************************************************************************/
    // save btn
    bar_save_btn = [[UIButton alloc]initWithFrame:CGRectMake(width - 10.5 - 50, 25, 50, 30)];
    [bar_save_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bar_save_btn setTitle:@"保存" forState:UIControlStateNormal];
    bar_save_btn.titleLabel.font = [UIFont systemFontOfSize:17.f];
//    [bar_save_btn setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:0.3126 green:0.7529 blue:0.6941 alpha:1.F] size:CGSizeMake(bar_publich_btn.bounds.size.width, bar_save_btn.bounds.size.height)] forState:UIControlStateNormal];
//    bar_save_btn.layer.cornerRadius = 4.f;
//    bar_save_btn.clipsToBounds = YES;
//    [bar_right_btn sizeToFit];
    [bar_save_btn addTarget:self action:@selector(didSelectSaveBtn) forControlEvents:UIControlEventTouchUpInside];
    bar_save_btn.center = CGPointMake(width - 10 - bar_publich_btn.frame.size.width / 2, FAKE_NAVIGATION_BAR_HEIGHT / 2);
    bar_save_btn.hidden = YES;
    [bar addSubview:bar_save_btn];
    /***************************************************************************************/
    
    /***************************************************************************************/
    /**
     * description view
     */
//    _descriptionView = [[UITextView alloc]initWithFrame:CGRectMake(CARD_CONTENG_MARGIN, img_height + FAKE_NAVIGATION_BAR_HEIGHT + CARD_CONTENG_MARGIN, width - 2 * CARD_CONTENG_MARGIN, height - img_height - FAKE_NAVIGATION_BAR_HEIGHT - BOTTON_BAR_HEIGHT - 2 * CARD_CONTENG_MARGIN)];
    _descriptionView = [[UITextView alloc]initWithFrame:CGRectMake(0, img_height , width - 2 * CARD_CONTENG_MARGIN, height - img_height - FAKE_NAVIGATION_BAR_HEIGHT - BOTTON_BAR_HEIGHT - CARD_CONTENG_MARGIN)];
    _descriptionView.delegate = self;
    _descriptionView.editable = YES;
//    [self.view addSubview:_descriptionView];
    [mainContentContainer addSubview:_descriptionView];
  
    placeholder = [[UILabel alloc]init];
    placeholder.textColor = [UIColor darkGrayColor];
    placeholder.numberOfLines = 2;
    placeholder.text = @"4-18个字节，\n限中英文，数字，表情符号";
    placeholder.textAlignment = NSTextAlignmentCenter;
    [placeholder sizeToFit];
    placeholder.center = CGPointMake(_descriptionView.frame.size.width / 2, _descriptionView.frame.size.height / 2);
    [_descriptionView addSubview:placeholder];
    /***************************************************************************************/

    /***************************************************************************************/
    /**
     * SNS view
     */
    SNS_bar = [[UIView alloc]initWithFrame:CGRectMake(0, height - BOTTON_BAR_HEIGHT, width, BOTTON_BAR_HEIGHT)];
    SNS_bar.backgroundColor = [UIColor colorWithWhite:0.1098 alpha:1.f];
    
    UILabel* label = [[UILabel alloc]init];
    label.textColor = [UIColor whiteColor];
    label.text = @"同步到";
    [label sizeToFit];
    CGFloat margin = 45;
    label.center = CGPointMake(width / 2 - margin - label.frame.size.width, BOTTON_BAR_HEIGHT / 2);
    [SNS_bar addSubview:label];
    
    margin -= 20;
   
    UIButton* wechat_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SNS_BUTTON_WIDTH, SNS_BUTTON_HEIGHT)];
    NSString * wechat_file = [resourceBundle pathForResource:[NSString stringWithFormat:@"login_wechat"] ofType:@"png"];
    NSString * wechat_file_click = [resourceBundle pathForResource:[NSString stringWithFormat:@"login_wechat_clicked"] ofType:@"png"];
    UIImage * wechat_image = [UIImage imageNamed:wechat_file];
    UIImage * wechat_image_click = [UIImage imageNamed:wechat_file_click];
    [wechat_btn setBackgroundImage:wechat_image forState:UIControlStateNormal];
    [wechat_btn setBackgroundImage:wechat_image_click forState:UIControlStateSelected];
    [wechat_btn addTarget:self action:@selector(SNSBtnSelected:) forControlEvents:UIControlEventTouchDown];
    wechat_btn.backgroundColor = [UIColor clearColor];
    wechat_btn.center = CGPointMake(width / 2 - margin, BOTTON_BAR_HEIGHT / 2);
    [SNS_bar addSubview:wechat_btn];
    
    UIButton* qq_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SNS_BUTTON_WIDTH, SNS_BUTTON_HEIGHT)];
    NSString * qq_file = [resourceBundle pathForResource:[NSString stringWithFormat:@"login_qq"] ofType:@"png"];
    NSString * qq_file_click = [resourceBundle pathForResource:[NSString stringWithFormat:@"login_qq_clicked"] ofType:@"png"];
    UIImage * qq_image = [UIImage imageNamed:qq_file];
    UIImage * qq_image_click = [UIImage imageNamed:qq_file_click];
    [qq_btn setBackgroundImage:qq_image forState:UIControlStateNormal];
    [qq_btn setBackgroundImage:qq_image_click forState:UIControlStateSelected];
    [qq_btn addTarget:self action:@selector(SNSBtnSelected:) forControlEvents:UIControlEventTouchDown];
    qq_btn.backgroundColor = [UIColor clearColor];
    qq_btn.center = CGPointMake(width / 2 + 60 - margin, BOTTON_BAR_HEIGHT / 2);
    [SNS_bar addSubview:qq_btn];
    
    // 同步到微博
    UIButton* weibo_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SNS_BUTTON_WIDTH, SNS_BUTTON_HEIGHT)];
    NSString * weibo_file = [resourceBundle pathForResource:[NSString stringWithFormat:@"login_weibo"] ofType:@"png"];
    NSString * weibo_file_click = [resourceBundle pathForResource:[NSString stringWithFormat:@"login_weibo_clicked"] ofType:@"png"];
    UIImage * weibo_image = [UIImage imageNamed:weibo_file];
    UIImage * weibo_image_click = [UIImage imageNamed:weibo_file_click];
    [weibo_btn setBackgroundImage:weibo_image forState:UIControlStateNormal];
    [weibo_btn setBackgroundImage:weibo_image_click forState:UIControlStateSelected];
    [weibo_btn addTarget:self action:@selector(SNSBtnSelected:) forControlEvents:UIControlEventTouchDown];
    weibo_btn.backgroundColor = [UIColor clearColor];
    weibo_btn.center = CGPointMake(width / 2 + 120 - margin, BOTTON_BAR_HEIGHT / 2);
    [SNS_bar addSubview:weibo_btn];
   
    sns_buttons = @[wechat_btn, weibo_btn, qq_btn];
    [self.view addSubview:SNS_bar];
    /***************************************************************************************/

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissPostViewController) name:@"post success" object:nil];
}

- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
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

#define KEYBOARD_HEIGHT         180

- (void)handleTap:(UITapGestureRecognizer*)gueture {
    if ([_descriptionView isFirstResponder]) {
        [_descriptionView resignFirstResponder];
        bar_cancel_btn.hidden = YES;
        bar_save_btn.hidden = YES;
        bar_publich_btn.hidden = NO;
        [self moveView:KEYBOARD_HEIGHT];
    }
}

- (void)moveView:(float)move {
    static const CGFloat kAnimationDuration = 0.30; // in seconds
    CGPoint p_start = mainContentContainer.center;
    CGPoint p_end = CGPointMake(p_start.x, p_start.y + move);
    [INTUAnimationEngine animateWithDuration:kAnimationDuration
                                                          delay:0.0
                                                         easing:INTUEaseInOutQuadratic
                                                        options:INTUAnimationOptionNone
                                                     animations:^(CGFloat progress) {
//                                                         _descriptionView.center = INTUInterpolateCGPoint(p_start, p_end, progress);
                                                         mainContentContainer.center = INTUInterpolateCGPoint(p_start, p_end, progress);
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
        btn.selected = YES;
    } else {
        btn.selected = NO;
    }
}

#pragma mark -- post the content
- (void)didSelectPostBtn {
    NSLog(@"发布按钮点击");
    
    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if (_isShareWeibo) {
        
        [LoginModel requestUserInfo:^(NSDictionary *data) {
            UIImage* userImg = [TmpFileStorageModel enumImageWithName:[data valueForKey:@"screen_photo"] withDownLoadFinishBolck:^(BOOL success, UIImage *user_img) {
                if (success) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (self) {
                            UIImage *shareImage = [Tools addPortraitToImage:_share_img userHead:user_img userName:[data valueForKey:@"screen_name"]];
                            [delegate.lm postContentOnQQzoneWithText:_descriptionView.text andImage:shareImage type:ShareImage];
                        }
                    });
                } else {
                    [[[UIAlertView alloc] initWithTitle:@"通知" message:@"分享失败" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
                }
            }];
            if (userImg != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIImage *shareImage = [Tools addPortraitToImage:_share_img userHead:userImg userName:[data valueForKey:@"screen_name"]];
                    [delegate.lm postContentOnQQzoneWithText:_descriptionView.text andImage:shareImage type:ShareImage];
                });
            }
        }];
    }
    if (_isShareQQ) {
        [LoginModel requestUserInfo:^(NSDictionary *data) {
            UIImage* userImg = [TmpFileStorageModel enumImageWithName:[data valueForKey:@"screen_photo"] withDownLoadFinishBolck:^(BOOL success, UIImage *user_img) {
                if (success) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (self) {
                            UIImage *shareImage = [Tools addPortraitToImage:_share_img userHead:user_img userName:[data valueForKey:@"screen_name"]];
                            [delegate.lm postContentOnQQzoneWithText:_descriptionView.text andImage:shareImage type:ShareImage];
                        }
                    });
                } else {
                    [[[UIAlertView alloc] initWithTitle:@"通知" message:@"分享失败" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
                }
            }];
            if (userImg != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIImage *shareImage = [Tools addPortraitToImage:_share_img userHead:userImg userName:[data valueForKey:@"screen_name"]];
                    [delegate.lm postContentOnQQzoneWithText:_descriptionView.text andImage:shareImage type:ShareImage];
                });
            }
        }];
    }
    
    if (_isShareWechat) {
        [LoginModel requestUserInfo:^(NSDictionary *data) {
            UIImage* userImg = [TmpFileStorageModel enumImageWithName:[data valueForKey:@"screen_photo"] withDownLoadFinishBolck:^(BOOL success, UIImage *user_img) {
                if (success) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (self) {
                            UIImage *shareImage = [Tools addPortraitToImage:_share_img userHead:user_img userName:[data valueForKey:@"screen_name"]];
                            [delegate.lm postContentOnFriendShipWithText:_descriptionView.text andImage:shareImage];
                        }
                    });
                } else {
                    [[[UIAlertView alloc] initWithTitle:@"通知" message:@"分享失败" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
                }
            }];
            if (userImg != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIImage *shareImage = [Tools addPortraitToImage:_share_img userHead:userImg userName:[data valueForKey:@"screen_name"]];
                    [delegate.lm postContentOnFriendShipWithText:_descriptionView.text andImage:shareImage];
                });
            }
        }];
    }
    
    PostModel* pm = delegate.pm;
    
    if (_type == PostPreViewPhote) {
        /**
         * create tag dictionary
         */
        NSMutableArray* arr = [[NSMutableArray alloc]init];
        for (PhotoTagView* view in _already_taged) {
            NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
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
            [pm postJsonContentWithFileName:filename andThumb:self.preViewImg withMessage:_descriptionView.text];
        }
    }
}

- (void)didSelectCancelBtn {
    if ([_descriptionView isFirstResponder]) {
        [_descriptionView resignFirstResponder];
        _descriptionView.text = @"";
        placeholder.hidden = NO;
        bar_cancel_btn.hidden = YES;
        bar_save_btn.hidden = YES;
        [self moveView:KEYBOARD_HEIGHT];
    }
}

- (void)didSelectSaveBtn {
    if ([_descriptionView isFirstResponder]) {
        [_descriptionView resignFirstResponder];
        bar_cancel_btn.hidden = YES;
        bar_save_btn.hidden = YES;
        bar_publich_btn.hidden = NO;
        [self moveView:KEYBOARD_HEIGHT];
    }
}

#pragma mark -- text area delegate
- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length < 1) {
        placeholder.hidden = NO;
        bar_publich_btn.enabled = NO;
    } else {
        placeholder.hidden = YES;
        bar_publich_btn.enabled = YES;
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    bar_cancel_btn.hidden = NO;
    bar_save_btn.hidden = NO;
    bar_publich_btn.hidden = YES;
    [self moveView:-KEYBOARD_HEIGHT];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@""]) {
        return YES;
    }
    if ([Tools bityWithStr:textView.text] >= 18) {
        return NO;
    } else {
        return YES;
    }
}

@end
