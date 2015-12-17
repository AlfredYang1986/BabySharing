//
//  PostPreViewEffectController.m
//  BabySharing
//
//  Created by Alfred Yang on 12/07/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "PostPreViewEffectController.h"
#import "PostEffectAdapter.h"
#import "PhotoAddTagController.h"
#import "INTUAnimationEngine.h"
#import "PhotoPublishController.h"
#import <AVFoundation/AVFoundation.h>
#import "SearchSegView2.h"

#define FAKE_NAVIGATION_BAR_HEIGHT      49
#define FUNC_BAR_HEIGHT                 44

@interface PostPreViewEffectController () <PostEffectAdapterProtocol, addingTagsProtocol, UIAlertViewDelegate, SearchSegViewDelegate>

@end

@implementation PostPreViewEffectController {
    CGFloat aspectRatio;
    
    UIView* mainContentView;
    
    PostEffectAdapter* adapter;
    
    /***********************************************************************/
    // photo
    CALayer* img_layer;
    
    NSMutableDictionary* function_dic;
    
    NSMutableDictionary* tags;
    
    NSMutableArray* paste_img_arr;
    CGPoint point;
    UIView* cur_long_press;
    
    UIImage* result_img;
   
    /***********************************************************************/
    // movie
    AVPlayer* player;
    AVPlayerLayer *avPlayerLayer;
    /***********************************************************************/
    
    /***********************************************************************/
    // fake bar
    UIView* bar;
    /***********************************************************************/
}

@synthesize type = _type;
@synthesize cutted_img = _cutted_img;
@synthesize editing_movie = _editing_movie;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.3126 green:0.7529 blue:0.6941 alpha:1.f]];
    
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
    img_layer.contents = (id)_cutted_img.CGImage;
    [mainContentView.layer addSublayer:img_layer];
    
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
    
    UIButton* bar_right_btn = [[UIButton alloc]initWithFrame:CGRectMake(width - 13 - 41, 25, 25, 25)];
    [bar_right_btn setTitleColor:[UIColor colorWithRed:0.3126 green:0.7529 blue:0.6941 alpha:1.f] forState:UIControlStateNormal];
    [bar_right_btn setTitle:@"下一步" forState:UIControlStateNormal];
    [bar_right_btn sizeToFit];
    [bar_right_btn addTarget:self action:@selector(didNextBtnSelected) forControlEvents:UIControlEventTouchDown];
    bar_right_btn.center = CGPointMake(width - 8 - bar_right_btn.frame.size.width / 2, FAKE_NAVIGATION_BAR_HEIGHT / 2);
    [bar addSubview:bar_right_btn];
    /***************************************************************************************/
    
    /***************************************************************************************/
    /**
     * funciton bar
     */
    CGFloat height = width * aspectRatio;
//    UIView* f_bar = [[UIView alloc]initWithFrame:CGRectMake(0, height, width, FUNC_BAR_HEIGHT)];
    SearchSegView2* f_bar = [[SearchSegView2 alloc]initWithFrame:CGRectMake(0, height, width, FUNC_BAR_HEIGHT)];
    f_bar.backgroundColor = [UIColor blackColor];
    f_bar.delegate = self;
    [self.view addSubview:f_bar];
    [self.view bringSubviewToFront:f_bar];
   
    /**
     * function bar button
     */
    if (_type == PostPreViewPhote) {
        
        [f_bar addItemWithTitle:@"标签"];
        [f_bar addItemWithTitle:@"滤镜"];
        f_bar.margin_between_items = 80;
        f_bar.selectedIndex = 0;
     
//        NSInteger button_count = 4;
        
//        [f_bar addSubview:[self addFunctionBarBtnWithTitle:@"滤镜" andImage:[UIImage imageNamed:[resourceBundle pathForResource:@"Effect" ofType:@"png"]] andCallBack:@selector(didSelectFunctionBtn:) andRect:CGRectMake(0, 0, width / button_count, f_bar.frame.size.height) andCenter:CGPointMake(width * 1 / (2*button_count),f_bar.frame.size.height / 2)]];
//        [f_bar addSubview:[self addFunctionBarBtnWithTitle:@"标签" andImage:[UIImage imageNamed:[resourceBundle pathForResource:@"Tag" ofType:@"png"]] andCallBack:@selector(didSelectFunctionBtn:) andRect:CGRectMake(0, 0, width / button_count, f_bar.frame.size.height) andCenter:CGPointMake(width * 3 / (2*button_count),f_bar.frame.size.height / 2)]];
//        [f_bar addSubview:[self addFunctionBarBtnWithTitle:@"贴图" andImage:[UIImage imageNamed:[resourceBundle pathForResource:@"PasteEffect" ofType:@"png"]] andCallBack:@selector(didSelectFunctionBtn:) andRect:CGRectMake(0, 0, width / button_count, f_bar.frame.size.height) andCenter:CGPointMake(width * 5 / (2*button_count),f_bar.frame.size.height / 2)]];
//        [f_bar addSubview:[self addFunctionBarBtnWithTitle:@"工具" andImage:[UIImage imageNamed:[resourceBundle pathForResource:@"ToolEffect" ofType:@"png"]] andCallBack:@selector(didSelectFunctionBtn:) andRect:CGRectMake(0, 0, width / button_count, f_bar.frame.size.height) andCenter:CGPointMake(width * 7 / (2*button_count),f_bar.frame.size.height / 2)]];
        
    } else if (_type == PostPreViewMovie) {

        NSInteger button_count = 5;
        [f_bar addSubview:[self addFunctionBarBtnWithTitle:@"滤镜" andImage:nil andCallBack:@selector(didSelectFunctionBtn:) andRect:CGRectMake(0, 0, width / button_count, f_bar.frame.size.height) andCenter:CGPointMake(width * 1 / (2*button_count), f_bar.frame.size.height / 2)]];
        [f_bar addSubview:[self addFunctionBarBtnWithTitle:@"剪切" andImage:nil andCallBack:@selector(didSelectFunctionBtn:) andRect:CGRectMake(0, 0, width / button_count, f_bar.frame.size.height) andCenter:CGPointMake(width * 3 / (2*button_count), f_bar.frame.size.height / 2)]];
        [f_bar addSubview:[self addFunctionBarBtnWithTitle:@"变速" andImage:nil andCallBack:@selector(didSelectFunctionBtn:) andRect:CGRectMake(0, 0, width / button_count, f_bar.frame.size.height) andCenter:CGPointMake(width * 5 / (2*button_count), f_bar.frame.size.height / 2)]];
        [f_bar addSubview:[self addFunctionBarBtnWithTitle:@"封面" andImage:nil andCallBack:@selector(didSelectFunctionBtn:) andRect:CGRectMake(0, 0, width / button_count, f_bar.frame.size.height) andCenter:CGPointMake(width * 7 / (2*button_count), f_bar.frame.size.height / 2)]];
        [f_bar addSubview:[self addFunctionBarBtnWithTitle:@"声音" andImage:nil andCallBack:@selector(didSelectFunctionBtn:) andRect:CGRectMake(0, 0, width / button_count, f_bar.frame.size.height) andCenter:CGPointMake(width * 9 / (2*button_count), f_bar.frame.size.height / 2)]];
    } else {
        // error
    }   
    /***************************************************************************************/
    
    /***************************************************************************************/
    /**
     * function area
     */
    adapter = [[PostEffectAdapter alloc]init];
    adapter.delegate = self;
    CGFloat prefered_height = [UIScreen mainScreen].bounds.size.height - height - FUNC_BAR_HEIGHT;
  
    if (_type == PostPreViewPhote) {
        [self segValueChanged2:f_bar];

    } else if (_type == PostPreViewMovie) {
       
        UIView* tmp = [adapter getFunctionViewByTitle:@"滤镜" andType:_type andPreferedHeight:prefered_height];
        tmp.frame = CGRectMake(0, height + FUNC_BAR_HEIGHT, tmp.frame.size.width, tmp.frame.size.height);
        
        function_dic = [[NSMutableDictionary alloc]init];
        [function_dic setValue:tmp forKey:@"滤镜"];
        
        [self.view addSubview:tmp];
    } else {
        // error
    }
    /***************************************************************************************/
   
    /***************************************************************************************/
    // photo
    if (_type == PostPreViewPhote) {

        tags = [[NSMutableDictionary alloc]initWithCapacity:3];
        paste_img_arr = [[NSMutableArray alloc]init];
        result_img = _cutted_img;
    }
    /***************************************************************************************/
    // movie
    else if (_type == PostPreViewMovie) {
        
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
        
        AVPlayerItem* tmp = [AVPlayerItem playerItemWithURL:_editing_movie];
//        [tmp addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];// 监听status属性
        //        [tmp addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];// 监听loadedTimeRanges属性
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:tmp];
        [player replaceCurrentItemWithPlayerItem:tmp];
        
        player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    }
    
    /***************************************************************************************/
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

//- (UIButton*)addFunctionBarBtnWithTitle:(NSString*)title andCallBack:(SEL)callBack andRect:(CGRect)bounds andCenter:(CGPoint)center {
- (UIButton*)addFunctionBarBtnWithTitle:(NSString*)title andImage:(UIImage*)img andCallBack:(SEL)callBack andRect:(CGRect)bounds andCenter:(CGPoint)center {
    UIButton* f_btn = [[UIButton alloc]initWithFrame:bounds];
    
    if (img == nil) {
        [f_btn setTitle:title forState:UIControlStateNormal];
        [f_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    } else {
//        f_btn.backgroundColor = [UIColor redColor];
        CALayer* il = [CALayer layer];
//        il.frame = CGRectMake(0, 0, bounds.size.width / 3 * 2, bounds.size.height/ 3 * 2);
        il.frame = CGRectMake(0, 0, 25, 25);
//        il.position = CGPointMake(bounds.size.width / 2, il.frame.size.height / 2);
        il.position = CGPointMake(bounds.size.width / 2, bounds.size.height / 3);
    
        il.contents = (id)img.CGImage;
        [f_btn.layer addSublayer:il];
        
        CATextLayer* tl = [CATextLayer layer];
        tl.frame = CGRectMake(0, 0, bounds.size.width, bounds.size.height / 3);
        tl.position = CGPointMake(bounds.size.width / 2, bounds.size.height / 4 * 3);
        tl.string = title;
        tl.foregroundColor = [UIColor blackColor].CGColor;
        tl.fontSize = 13.f;
        tl.alignmentMode = @"center";
        [f_btn.layer addSublayer:tl];

        [f_btn setTitle:title forState:UIControlStateNormal];
        [f_btn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    }

    [f_btn addTarget:self action:callBack forControlEvents:UIControlEventTouchDown];
    f_btn.center = center;
    return f_btn;
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -- button actions
- (void)didPopControllerSelected {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didNextBtnSelected {

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PhotoPreView" bundle:nil];
    PhotoPublishController* publishController = [storyboard instantiateViewControllerWithIdentifier:@"publishController"];

    if (_type == PostPreViewPhote) {
    
        UIImage* final_img = [self mergePasteAndEffect:result_img];
       
        publishController.preViewImg = final_img;
       
        NSMutableArray* arr = [[NSMutableArray alloc]initWithCapacity:tags.count];
        for (int index = 0; index < tags.allValues.count; ++index) {
            PhotoTagView* view = [tags.allValues objectAtIndex:index];
            if (view) {
                PhotoTagView* tmp = [[PhotoTagView alloc]initWithTagName:view.content andType:view.type];
                tmp.offset_x = view.frame.origin.x;
                tmp.offset_y = view.frame.origin.y;
                [arr addObject:tmp];
            }
        }
        publishController.already_taged = [arr copy];
        
    } else if (_type == PostPreViewMovie) {
       
        publishController.movie_url = _editing_movie;
    }

    publishController.type = _type;
    [self.navigationController pushViewController:publishController animated:YES];
}

- (UIImage*)mergePasteAndEffect:(UIImage*)baseImg {
    CGImageRef baseImageRef = CGImageCreateWithImageInRect(baseImg.CGImage, CGRectMake(0, 0, baseImg.size.width, baseImg.size.height));
    CGRect baseBounds = CGRectMake(0, 0, CGImageGetWidth(baseImageRef), CGImageGetHeight(baseImageRef));
    
    CGFloat scale_x = _cutted_img.size.width / mainContentView.frame.size.width;
    CGFloat scale_y = _cutted_img.size.height / mainContentView.frame.size.height;
    
    UIGraphicsBeginImageContext(baseBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, 0.0, baseBounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, baseBounds, baseImageRef);
    
    for (UIImageView* view in paste_img_arr) {
        
        CGImageRef subImgRef = CGImageCreateWithImageInRect(view.image.CGImage, CGRectMake(0, 0, view.image.size.width, view.image.size.height));
        CGRect rect = view.frame;
        
        CGFloat offset_x = rect.origin.x;
        CGFloat offset_y = mainContentView.frame.size.height - (rect.origin.y + rect.size.height);
        
        CGRect smallBounds = CGRectMake(offset_x * scale_x, offset_y * scale_y, rect.size.width * scale_x, rect.size.height * scale_y);
        CGContextDrawImage(context, smallBounds, subImgRef);
    }
    
    
    CGImageRef newImageRef = CGBitmapContextCreateImage(context);
    UIImage* newImage = [UIImage imageWithCGImage:newImageRef];
    UIGraphicsEndImageContext();
    //
    return newImage;
}

- (void)didSelectFunctionBtn:(UIButton*)sender {
    NSString* title = sender.titleLabel.text;
    
    for (UIView* iter in function_dic.allValues) {
        [iter removeFromSuperview];
    }
    
    UILabel* label = (UILabel*)[bar viewWithTag:-1];
    label.text = [@"选择" stringByAppendingString:title];
    [label sizeToFit];
    
    UIView* tmp = [function_dic objectForKey:title];
    if (!tmp) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat height = width * aspectRatio;
        CGFloat prefered_height = [UIScreen mainScreen].bounds.size.height - height - FUNC_BAR_HEIGHT;
        tmp = [adapter getFunctionViewByTitle:title andType:_type andPreferedHeight:prefered_height];
        tmp.frame = CGRectMake(0, height + FUNC_BAR_HEIGHT, tmp.frame.size.width, tmp.frame.size.height);
    }
    [self.view addSubview:tmp];
    
}

#pragma mark -- adding tag protocol
- (void)didSelectTag:(NSString *)tag andType:(TagType)type {
    // TODO: adding tag
    NSLog(@"adding tags: %@, %d", tag, (int)type);
    
    if ([tags.allKeys containsObject:[NSNumber numberWithInteger:type]]) {
        UIView* last = [tags objectForKey:[NSNumber numberWithInteger:type]];
        [last removeFromSuperview];
        [tags removeObjectForKey:[NSNumber numberWithInteger:type]];
    }
    
    PhotoTagView* tmp = [[PhotoTagView alloc]initWithTagName:tag andType:type];
    CGFloat width = mainContentView.frame.size.width;
    CGFloat height = mainContentView.frame.size.height;
    CGPoint point_tmp;
    switch (type) {
        case TagTypeLocation:
            point_tmp = CGPointMake(width / 4 - tmp.bounds.size.width / 2, height / 2);
            break;
        case TagTypeTime:
            point_tmp = CGPointMake(width / 2 - tmp.bounds.size.width / 2, height * 3 / 4);
            break;
        case TagTypeTags:
            point_tmp = CGPointMake(width * 3 / 4 - tmp.bounds.size.width / 2, height / 2);
        default:
            break;
    }
    tmp.frame = CGRectMake(point_tmp.x, point_tmp.y, tmp.bounds.size.width, tmp.bounds.size.height);
    [mainContentView addSubview:tmp];
    [mainContentView bringSubviewToFront:tmp];
    
    [tags setObject:tmp forKey:[NSNumber numberWithInteger:type]];
//    [already_taged_views setObject:tmp forKey:[NSNumber numberWithInt:type]];
//    
//    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTagTapped:)];
//    [tmp addGestureRecognizer:tap];
//    
//    UILongPressGestureRecognizer* lg = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)];
//    [tmp addGestureRecognizer:lg];
//    
//    UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handleTagPan:)];
//    [tmp addGestureRecognizer:pan];
}

#pragma mark -- function button protocol
- (PostPreViewType)currentType {
    return _type;
}

- (UIImage*)originImage {
    return _cutted_img;
}

- (void)imageWithEffect:(UIImage *)img {
    result_img = img;
    img_layer.contents = (id)img.CGImage;
}

- (BOOL)canCreateNewTag:(TagType)tag_type {
//    return ![tags.allKeys containsObject:[NSNumber numberWithInteger:tag_type]];
    return YES;
}

- (void)tagView:(PhotoTagView*)view forTagType:(TagType)tag_type {
    [tags setObject:view forKey:[NSNumber numberWithInteger:tag_type]];
}

- (void)queryTagContetnWithTagType:(TagType)tag_type andImg:(UIImage*)tag_img {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PhotoPreView" bundle:nil];
    PhotoAddTagController* addTagController = [storyboard instantiateViewControllerWithIdentifier:@"AddTags"];
    addTagController.tagImg = tag_img;
    addTagController.type = tag_type;
    addTagController.delegate = self;
    
    [self.navigationController pushViewController:addTagController animated:YES];
}

- (void)pasteWithImage:(UIImage*)img {
    UIImageView* tmp = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, img.size.width, img.size.height)];
    tmp.center = CGPointMake(mainContentView.frame.size.width / 2, mainContentView.frame.size.height / 2);
    tmp.userInteractionEnabled = YES;
    tmp.contentMode = UIViewContentModeScaleToFill;
    tmp.image = img;
   
    UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePastePan:)];
    [tmp addGestureRecognizer:pan];
    UILongPressGestureRecognizer* lp = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)];
    [tmp addGestureRecognizer:lp];
    
    [mainContentView addSubview:tmp];
    [mainContentView bringSubviewToFront:tmp];
    
    [paste_img_arr addObject:tmp];
}

#pragma mark -- paste img pan handle
- (void)handlePastePan:(UIPanGestureRecognizer*)gesture {
    NSLog(@"pan gesture");
    UIView* tmp = gesture.view;
    if (gesture.state == UIGestureRecognizerStateBegan) {
        NSLog(@"begin");
        point = [gesture translationInView:mainContentView];
        [mainContentView bringSubviewToFront:tmp];
        
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        NSLog(@"end");
        point = CGPointMake(-1, -1);
        CGFloat move_x = [self distanceMoveHerWithView:tmp];
        CGFloat move_y = [self distanceMoveVerWithView:tmp];
        [self moveView:move_x and:move_y withView:tmp];
        
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        NSLog(@"changeed");
        CGPoint newPoint = [gesture translationInView:mainContentView];
        
        tmp.center = CGPointMake(tmp.center.x + (newPoint.x - point.x), tmp.center.y + (newPoint.y - point.y));
        point = newPoint;
    }
}

- (void)moveView:(float)move_x and:(float)move_y withView:(UIView*)view {
    static const CGFloat kAnimationDuration = 0.30; // in seconds
    CGPoint center = view.center;
    CGPoint newCenter = CGPointMake(view.center.x + move_x, view.center.y + move_y);
    [INTUAnimationEngine animateWithDuration:kAnimationDuration
                                       delay:0.0
                                      easing:INTUEaseInOutQuadratic
                                     options:INTUAnimationOptionNone
                                  animations:^(CGFloat progress) {
                                      view.center = INTUInterpolateCGPoint(center, newCenter, progress);
                                      
                                      // NSLog(@"Progress: %.2f", progress);
                                  }
                                  completion:^(BOOL finished) {
                                      // NOTE: When passing INTUAnimationOptionRepeat, this completion block is NOT executed at the end of each cycle. It will only run if the animation is canceled.
                                      NSLog(@"%@", finished ? @"Animation Completed" : @"Animation Canceled");
                                      //                                                         self.animationID = NSNotFound;
                                  }];
}

- (CGFloat)distanceMoveVerWithView:(UIView*)view {
    if (view.frame.origin.y < 0)
        return -view.frame.origin.y;
    else if (view.frame.origin.y + view.frame.size.height > mainContentView.frame.size.height)
        return -(view.frame.origin.y + view.frame.size.height - mainContentView.frame.size.height);
    else return 0;
}

- (CGFloat)distanceMoveHerWithView:(UIView*)view {
    
    if (view.frame.origin.x < 0)
        return -view.frame.origin.x;
    else if (view.frame.origin.x + view.frame.size.width > mainContentView.frame.size.width)
        return -(view.frame.origin.x + view.frame.size.width - mainContentView.frame.size.width);
    else return 0;
}

- (void)handleLongPress:(UILongPressGestureRecognizer*)gesture {
    NSLog(@"long gesture");
    if (gesture.state == UIGestureRecognizerStateBegan) {
        NSLog(@"begin");
        
        cur_long_press = gesture.view;
        UIAlertView* view = [[UIAlertView alloc]initWithTitle:@"delect" message:@"remove paste image" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"yes", nil];
        [view show];
        
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        NSLog(@"changeed");
        
    }
}

#pragma mark -- alert view delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"index at %ld", (long)buttonIndex);
    if (buttonIndex == 1) {
        [cur_long_press removeFromSuperview];
        [paste_img_arr removeObject:cur_long_press];
    }
    cur_long_press = nil;
}

#pragma mark -- search seg delegate
- (void)segValueChanged2:(SearchSegView2*)s {
   
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = width * aspectRatio;
    CGFloat prefered_height = [UIScreen mainScreen].bounds.size.height - height - FUNC_BAR_HEIGHT;
    
    UIView* tmp =[adapter getFunctionViewByTitle:[s queryItemTitleAtIndex:s.selectedIndex] andType:_type andPreferedHeight:prefered_height];
    tmp.frame = CGRectMake(0, height + FUNC_BAR_HEIGHT, tmp.frame.size.width, tmp.frame.size.height);
    
    [self.view addSubview:tmp];
}
@end
