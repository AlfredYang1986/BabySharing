//
//  AlbumViewController2.m
//  BabySharing
//
//  Created by Alfred Yang on 11/07/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "AlbumViewController2.h"
#import "AlbumModule.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "INTUAnimationEngine.h"
#import "AlbumGridCell.h"
#import "PostPreViewEffectController.h"

#define PHOTO_PER_LINE  3

@interface AlbumViewController2 () 

@end

@implementation AlbumViewController2 {
    UIView* mainContentView;
    UIView* f_bar;
    UIView* bar;
    UITableView* albumView;
    
    CGFloat aspectRatio;
    
    AlbumModule* am;
    NSArray* images_arr;
    NSArray* album_name_arr;
    NSMutableArray * images_select_arr;
    BOOL isAllowMutiSelection;
    BOOL bLoadData;
   
    BOOL isMainContentViewShown;
    CALayer * mainContentPhotoLayer;
    
    AVPlayer* player;
    AVPlayerLayer *avPlayerLayer;
    
    CGPoint point;
    CGFloat last_scale;
    UIImage* img;
    NSURL* cur_movie_url;
}

@synthesize type = _type;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = UIColor.blackColor;

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
    
    if (_type == AlbumControllerTypePhoto) {
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [mainContentView addGestureRecognizer:pan];
        
        UIPinchGestureRecognizer* pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(handlePinch:)];
        [mainContentView addGestureRecognizer:pinch];
    }
   
    /***************************************************************************************/
    /**
     * fake navigation bar
     */
    bar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 49)];
    bar.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.3];
    [self.view addSubview:bar];
    [self.view bringSubviewToFront:bar];
    
    UIButton* barBtn = [[UIButton alloc]initWithFrame:CGRectMake(13, 15, 25, 25)];
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    NSString* filepath = [resourceBundle pathForResource:@"Previous_blue" ofType:@"png"];
    [barBtn setBackgroundImage:[UIImage imageNamed:filepath] forState:UIControlStateNormal];
    [barBtn addTarget:self action:@selector(didPopControllerSelected) forControlEvents:UIControlEventTouchDown];
    [bar addSubview:barBtn];

    UIButton* bar_right_btn = [[UIButton alloc]initWithFrame:CGRectMake(width - 13 - 25, 15, 25, 25)];
    NSString* filepath_right = [resourceBundle pathForResource:@"Next_blue" ofType:@"png"];
    [bar_right_btn setBackgroundImage:[UIImage imageNamed:filepath_right] forState:UIControlStateNormal];
    [bar_right_btn addTarget:self action:@selector(didNextBtnSelected) forControlEvents:UIControlEventTouchDown];
    [bar addSubview:bar_right_btn];
    /***************************************************************************************/
    
    /***************************************************************************************/
    /**
     * funciton bar
     */
    CGFloat height = width * aspectRatio;
    f_bar = [[UIView alloc]initWithFrame:CGRectMake(0, height - 44, width, 44)];
    f_bar.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.6];
    [self.view addSubview:f_bar];
    [self.view bringSubviewToFront:f_bar];

    /**
     * gradient layer for gradient background,
     */
    CAGradientLayer* gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0, 0, f_bar.frame.size.width, f_bar.frame.size.height);
    gl.colors = [NSArray arrayWithObjects:
                             (id)[[UIColor clearColor] CGColor],
                             (id)[[UIColor darkGrayColor] CGColor], nil];
    gl.startPoint = CGPointMake(0.5, 0.5);
    gl.endPoint = CGPointMake(0.5, 1.0);
    [f_bar.layer addSublayer:gl];
    
    /**
     * button layer for function bar
     */
    CALayer* round_bottom = [CALayer layer];
    round_bottom.frame = CGRectMake(0, 0, width * 0.1, 6);
    round_bottom.cornerRadius = 3.f;
    round_bottom.masksToBounds = YES;
    round_bottom.borderWidth = 1.f;
    round_bottom.borderColor = [UIColor blackColor].CGColor;
    round_bottom.backgroundColor = [UIColor blackColor].CGColor;
    round_bottom.position = CGPointMake(f_bar.frame.size.width / 2, f_bar.frame.size.height * 3 / 4);
    [f_bar.layer addSublayer:round_bottom];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapFunctionBar:)];
    [f_bar addGestureRecognizer:tap];
    /***************************************************************************************/
    
    CGFloat tab_bar_height_offset = [UIScreen mainScreen].bounds.size.height - 44;
    /***************************************************************************************/
    /**
     * grid photos
     */
    albumView = [[UITableView alloc]initWithFrame:CGRectMake(0, height, width, tab_bar_height_offset - height)];
    albumView.dataSource = self;
    albumView.delegate = self;
    [self.view addSubview:albumView];
    
    /***************************************************************************************/
    
    /***************************************************************************************/
    /**
     * bottom function area
     */
    UIView* tab_bar = [[UIView alloc]initWithFrame:CGRectMake(0, tab_bar_height_offset, width, 44)];
    tab_bar.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.6];
    [self.view addSubview:tab_bar];
   
    if (_type == AlbumControllerTypePhoto) {
        [self createButtonsForView:tab_bar inRect:CGRectMake(0, 0, width / 3, 44) andTitle:@"相机胶卷"];
        [self createButtonsForView:tab_bar inRect:CGRectMake(width / 3, 0, width / 3, 44) andTitle:@"面孔"];
        [self createButtonsForView:tab_bar inRect:CGRectMake(width * 2 / 3, 0, width / 3, 44) andTitle:@"地点"];
    } else {
        [self createButtonsForView:tab_bar inRect:CGRectMake(0, 0, width, 44) andTitle:@"视频"];
        
        if (player == nil) {
            player = [[AVPlayer alloc]init];
            avPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
        }
    }
    /***************************************************************************************/
    
    am = [[AlbumModule alloc]init];
    if (_type == AlbumControllerTypePhoto) {
        [self enumAllAssetWithProprty:ALAssetTypePhoto];
    } else if (_type == AlbumControllerTypeMovie) {
        [self enumAllAssetWithProprty:ALAssetTypeVideo];
    } else {
        // error
    }
    [albumView registerClass:[AlbumTableCell class] forCellReuseIdentifier:@"AlbumTableViewCell"];
    
    isMainContentViewShown = YES;
    isAllowMutiSelection = NO;
    images_select_arr = [[NSMutableArray alloc]init];
    last_scale = 1.f;
}

//- (void)dealloc {
//    [player.currentItem removeObserver:self forKeyPath:@"status"];
//}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    if (_type == AlbumControllerTypeMovie) {
        if (![mainContentView.layer.sublayers containsObject:avPlayerLayer]) {
            avPlayerLayer.frame = mainContentView.bounds;
            avPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
            [mainContentView.layer addSublayer:avPlayerLayer];
        }
        
        if (player.currentItem) {
            [player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];// 监听status属性
            [player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
                [player play];
            }];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_type == AlbumControllerTypeMovie) {
        if (player.currentItem) {
            [player.currentItem removeObserver:self forKeyPath:@"status"];
            [player pause];
        }
        if ([mainContentView.layer.sublayers containsObject:avPlayerLayer]) {
            [avPlayerLayer removeFromSuperlayer];
        }
    }
}

- (void)createButtonsForView:(UIView*)tab_bar inRect:(CGRect)rc andTitle:(NSString*)title{
    UIButton* btn = [[UIButton alloc]initWithFrame:rc];
//    btn.layer.borderColor = [UIColor blueColor].CGColor;
//    btn.layer.borderWidth = 1.f;
    btn.layer.cornerRadius = 4.f;
    btn.clipsToBounds = YES;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(didSelectTabBtn:) forControlEvents:UIControlEventTouchDown];
    [tab_bar addSubview:btn];   
}

- (void)changeMainContentWithAsset:(ALAsset*)asset {
    NSString* cur_type = [asset valueForProperty:ALAssetPropertyType];
    if ([cur_type isEqualToString:ALAssetTypePhoto]) {
        if (mainContentPhotoLayer == nil) {
            mainContentPhotoLayer = [CALayer layer];
        }
       
        img = [UIImage imageWithCGImage:asset.defaultRepresentation.fullResolutionImage];
        [mainContentPhotoLayer removeFromSuperlayer];
        
        last_scale = MAX(mainContentView.frame.size.width /  img.size.width, mainContentView.frame.size.height / img.size.height);
        
        mainContentPhotoLayer.frame = CGRectMake(0, 0, img.size.width * last_scale, img.size.height * last_scale);
        mainContentPhotoLayer.contents = (id)asset.defaultRepresentation.fullResolutionImage;
        [mainContentView.layer addSublayer:mainContentPhotoLayer];
        
    } else if ([cur_type isEqualToString:ALAssetTypeVideo]) {
        
        if (![mainContentView.layer.sublayers containsObject:avPlayerLayer]) {
            avPlayerLayer.frame = mainContentView.bounds;
            avPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
            [mainContentView.layer addSublayer:avPlayerLayer];
        }
       
        [player.currentItem removeObserver:self forKeyPath:@"status"];
        
        cur_movie_url = asset.defaultRepresentation.url;
        AVPlayerItem* tmp = [AVPlayerItem playerItemWithURL:asset.defaultRepresentation.url];
        [tmp addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];// 监听status属性
//        [tmp addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];// 监听loadedTimeRanges属性
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:tmp];
        [player replaceCurrentItemWithPlayerItem:tmp];
        
        player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
//        [player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
//            [player play];
//        }];
//        
    } else {
        // error asset type
    }
    
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

#pragma mark -- button actions
- (void)didPopControllerSelected {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didNextBtnSelected {
    PostPreViewEffectController * distination = [[PostPreViewEffectController alloc]init];
    
    if (_type == AlbumControllerTypePhoto) {
        CGFloat width = mainContentView.frame.size.width;
        CGFloat height = mainContentView.frame.size.height;

        CGFloat scale_x = img.size.width / mainContentPhotoLayer.frame.size.width;
        CGFloat scale_y = img.size.height / mainContentPhotoLayer.frame.size.height;
       
        CGFloat top_margin = 0;
        CGFloat offset_x = fabs(mainContentPhotoLayer.frame.origin.x);
        CGFloat offset_y = fabs(mainContentPhotoLayer.frame.origin.y - top_margin);
        
        distination.cutted_img = [self clipImage:img withRect:CGRectMake(offset_x * scale_x, offset_y * scale_y, width * scale_x, height * scale_y)];
        distination.type = (int)_type;

    } else if (_type == AlbumControllerTypeMovie) {
        distination.editing_movie = cur_movie_url;
        
    } else {
        // error
    }
    

    distination.type = (NSInteger)_type;
    [self.navigationController pushViewController:distination animated:YES];
}

- (void)didTapFunctionBar:(UITapGestureRecognizer*)gesture {
    
    static const CGFloat kAnimationDuration = 0.15; // in seconds
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = width * aspectRatio;
    CGRect f_bar_start = CGRectMake(0, height - 44, width, 44);
    CGRect f_bar_end = CGRectMake(0, 5, width, 44);

    CGFloat tab_bar_height_offset = [UIScreen mainScreen].bounds.size.height - 44;
    CGRect table_view_start = CGRectMake(0, height, width, tab_bar_height_offset - height);
    CGRect table_view_end = CGRectMake(0, 49, width, tab_bar_height_offset - 49);
    
    if (isMainContentViewShown) {

        [INTUAnimationEngine animateWithDuration:kAnimationDuration
                                           delay:0.0
                                          easing:INTUEaseInOutQuadratic
                                         options:INTUAnimationOptionAutoreverse
                                      animations:^(CGFloat progress) {
                                          f_bar.frame = INTUInterpolateCGRect(f_bar_start, f_bar_end, progress);
                                          albumView.frame = INTUInterpolateCGRect(table_view_start, table_view_end, progress);
                                          // NSLog(@"Progress: %.2f", progress);
                                      }
                                      completion:^(BOOL finished) {
                                          // NOTE: When passing INTUAnimationOptionRepeat, this completion block is NOT executed at the end of each cycle. It will only run if the animation is canceled.
                                          NSLog(@"%@", finished ? @"Animation Completed" : @"Animation Canceled");
                                          // self.animationID = NSNotFound;
                                          bar.hidden = YES;
                                          
                                      }];
        
        isMainContentViewShown = NO;
    } else {
        
        [INTUAnimationEngine animateWithDuration:kAnimationDuration
                                           delay:0.0
                                          easing:INTUEaseInOutQuadratic
                                         options:INTUAnimationOptionAutoreverse
                                      animations:^(CGFloat progress) {
                                          f_bar.frame = INTUInterpolateCGRect(f_bar_end, f_bar_start, progress);
                                          albumView.frame = INTUInterpolateCGRect(table_view_end, table_view_start, progress);
                                          // NSLog(@"Progress: %.2f", progress);
                                      }
                                      completion:^(BOOL finished) {
                                          // NOTE: When passing INTUAnimationOptionRepeat, this completion block is NOT executed at the end of each cycle. It will only run if the animation is canceled.
                                          NSLog(@"%@", finished ? @"Animation Completed" : @"Animation Canceled");
                                          // self.animationID = NSNotFound;
                                          bar.hidden = NO;
                                          
                                      }];
        
        isMainContentViewShown = YES;
    }
    
}

- (void)didSelectTabBtn:(UIButton*)sender {
    
}

#pragma mark -- table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"selet row");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
    //    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    return width / 3;
}

#pragma mark -- table view datasource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AlbumTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlbumTableViewCell"];
    
    if (cell == nil) {
        cell = [[AlbumTableCell alloc]init];
    }
    
    cell.delegate = self;
    NSInteger row = indexPath.row;
    NSArray* arr_content = [images_arr objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(row * PHOTO_PER_LINE, PHOTO_PER_LINE)]];     // there is a bug
    [cell setUpContentViewWithImageURLs2:arr_content atLine:row andType:_type];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (bLoadData) return ((images_arr.count) / PHOTO_PER_LINE) + 1;
    else return 0;
}

#pragma mark -- photo ablum access
- (void)enumAllAssetWithProprty:(NSString*)type {
    bLoadData = NO;
    [am enumAllAssetWithProprty:type finishBlock:^(NSArray *result) {
        bLoadData = YES;
        images_arr = result;
        [albumView reloadData];
        
        [self changeMainContentWithAsset:images_arr.firstObject];
    }];
}

#pragma mark -- PostTableCellDelegate

- (void)didSelectOneImageAtIndex:(NSInteger)index {
    NSLog(@"select index %ld", (long)index);
    
    if (!isAllowMutiSelection) {
        for (NSNumber* index in images_select_arr) {
            AlbumGridCell* tmp = [self queryCellByIndex:index.integerValue];
            [tmp setCellViewSelected:NO];
            [self didUnSelectOneImageAtIndex:index.integerValue];
        }
    }
    [images_select_arr addObject:[NSNumber numberWithInteger:index]];
    [self changeMainContentWithAsset:[images_arr objectAtIndex:index]];
}

- (void)didUnSelectOneImageAtIndex:(NSInteger)index {
    NSLog(@"unselect index %ld", (long)index);
    for (int i = 0; i < images_select_arr.count; ++i) {
        if (((NSNumber*)[images_select_arr objectAtIndex:i]).integerValue == index)
            [images_select_arr removeObjectAtIndex:i];
    }
}

- (AlbumGridCell*)queryCellByIndex:(NSInteger)index {
    NSIndexPath* i = [NSIndexPath indexPathForRow:index / 3 inSection:0];
    AlbumTableCell* cell = (AlbumTableCell*)[albumView cellForRowAtIndexPath:i];
    
    return [cell queryGridCellByIndex:(index) % 3];
}

- (NSInteger)indexByRow:(NSInteger)row andCol:(NSInteger)col {
    return row * PHOTO_PER_LINE + col;
}

- (NSInteger)getViewsCount {
    return PHOTO_PER_LINE;
}

- (BOOL)isSelectedAtIndex:(NSInteger)index {
    return [images_select_arr containsObject:[NSNumber numberWithInteger:index]];
}

#pragma mark -- handle gesture
- (void)handlePan:(UIPanGestureRecognizer*)gesture {
    NSLog(@"pan gesture");
    if (gesture.state == UIGestureRecognizerStateBegan) {
        NSLog(@"begin");
        point = [gesture translationInView:albumView];
        
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        NSLog(@"end");
        point = CGPointMake(-1, -1);
        CGFloat move_x = [self distanceMoveHer];
        CGFloat move_y = [self distanceMoveVer];
        [self moveView:move_x and:move_y];
        
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        NSLog(@"changeed");
        CGPoint newPoint = [gesture translationInView:mainContentView];
        
        mainContentPhotoLayer.position = CGPointMake(mainContentPhotoLayer.position.x + (newPoint.x - point.x), mainContentPhotoLayer.position.y + (newPoint.y - point.y));
        point = newPoint;
    }
}

- (CGFloat)distanceMoveVer {
    CGFloat top_margin = 0;
    if (mainContentPhotoLayer.frame.origin.y > top_margin)
        return -mainContentPhotoLayer.frame.origin.y + top_margin;
    else if (mainContentPhotoLayer.frame.origin.y + mainContentPhotoLayer.frame.size.height < mainContentView.frame.size.height)
        return mainContentView.frame.size.height - (mainContentPhotoLayer.frame.origin.y + mainContentPhotoLayer.frame.size.height);
    else return 0;
}

- (CGFloat)distanceMoveHer {
    
    if (mainContentPhotoLayer.frame.origin.x > 0)
        return -mainContentPhotoLayer.frame.origin.x;
    else if (mainContentPhotoLayer.frame.origin.x + mainContentPhotoLayer.frame.size.width < mainContentView.frame.size.width)
        return mainContentView.frame.size.width - (mainContentPhotoLayer.frame.origin.x + mainContentPhotoLayer.frame.size.width);
    else return 0;
}

- (void)moveView:(float)move_x and:(float)move_y {
    static const CGFloat kAnimationDuration = 0.30; // in seconds
    CGPoint center = mainContentPhotoLayer.position;
    CGPoint newCenter = CGPointMake(mainContentPhotoLayer.position.x + move_x, mainContentPhotoLayer.position.y + move_y);
    [INTUAnimationEngine animateWithDuration:kAnimationDuration
                                       delay:0.0
                                      easing:INTUEaseInOutQuadratic
                                     options:INTUAnimationOptionNone
                                  animations:^(CGFloat progress) {
                                      mainContentPhotoLayer.position = INTUInterpolateCGPoint(center, newCenter, progress);
                                      
                                      // NSLog(@"Progress: %.2f", progress);
                                  }
                                  completion:^(BOOL finished) {
                                      // NOTE: When passing INTUAnimationOptionRepeat, this completion block is NOT executed at the end of each cycle. It will only run if the animation is canceled.
                                      NSLog(@"%@", finished ? @"Animation Completed" : @"Animation Canceled");
                                      //                                                         self.animationID = NSNotFound;
                                  }];
}

- (void)scaleView:(CGRect)frame_old and:(CGRect)frame_new {
    static const CGFloat kAnimationDuration = 0.30; // in seconds
    [INTUAnimationEngine animateWithDuration:kAnimationDuration
                                       delay:0.0
                                      easing:INTUEaseInOutQuadratic
                                     options:INTUAnimationOptionNone
                                  animations:^(CGFloat progress) {
                                      mainContentPhotoLayer.frame = INTUInterpolateCGRect(frame_old, frame_new, progress);
                                      
                                      // NSLog(@"Progress: %.2f", progress);
                                  }
                                  completion:^(BOOL finished) {
                                      // NOTE: When passing INTUAnimationOptionRepeat, this completion block is NOT executed at the end of each cycle. It will only run if the animation is canceled.
                                      NSLog(@"%@", finished ? @"Animation Completed" : @"Animation Canceled");
                                      //                                                         self.animationID = NSNotFound;
                                      CGFloat move_x = [self distanceMoveHer];
                                      CGFloat move_y = [self distanceMoveVer];
                                      [self moveView:move_x and:move_y];
                                  }];
}

#pragma mark -- scale the pic
- (void)handlePinch:(UIPinchGestureRecognizer*)gesture {
    NSLog(@"pinch gesture");
    if (gesture.state == UIGestureRecognizerStateBegan) {
        NSLog(@"begin");
        
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        [self checkScale];
        
        
        last_scale = MAX(mainContentView.frame.size.width /  img.size.width, mainContentView.frame.size.height / img.size.height);
        
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        NSLog(@"changeed");
        //        mainContentPhotoLayer.transform = CGAffineTransformScale(mainContentPhotoLayer.transform, gesture.scale,gesture.scale);
        CGPoint cp = mainContentPhotoLayer.position;
        CGFloat scale = 1 + (gesture.scale - 1) * 0.1;
        mainContentPhotoLayer.frame = CGRectMake(mainContentPhotoLayer.frame.origin.x, mainContentPhotoLayer.frame.origin.y, mainContentPhotoLayer.frame.size.width * scale, mainContentPhotoLayer.frame.size.height * scale);
        mainContentPhotoLayer.position = cp;
    }
}

- (void)checkScale {
    CGFloat top_margin = 0;
    if (mainContentPhotoLayer.bounds.size.width > mainContentPhotoLayer.bounds.size.height) {
        if (mainContentPhotoLayer.frame.size.height < mainContentView.frame.size.height) {
            CGFloat width = (mainContentView.frame.size.height - top_margin) / mainContentPhotoLayer.frame.size.height * mainContentPhotoLayer.frame.size.width;
            [self scaleView:mainContentPhotoLayer.frame and:CGRectMake(0, top_margin, width, mainContentView.frame.size.height)];
        }
    } else {
        if (mainContentPhotoLayer.frame.size.width < mainContentView.frame.size.width) {
            CGFloat height = mainContentView.frame.size.width / mainContentPhotoLayer.frame.size.width * mainContentPhotoLayer.frame.size.height;
            [self scaleView:mainContentPhotoLayer.frame and:CGRectMake(0, top_margin, mainContentView.frame.size.width, height - top_margin)];
        }
    }
}

#pragma mark -- cut img
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier isEqualToString:@"editSegue"]) {
//        CGFloat width = screen_width;
//        CGFloat height = screen_height - control_pane_height - top_margin;
//        CGFloat scale_x = _preImgView.image.size.width / _preImgView.frame.size.width;
//        CGFloat scale_y = _preImgView.image.size.height / _preImgView.frame.size.height;
//        
//        CGFloat offset_x = fabs(_preImgView.frame.origin.x);
//        CGFloat offset_y = fabs(_preImgView.frame.origin.y - top_margin);
//        
//        UIImage* cutted_img = [self clipImage:_preImgView.image withRect:CGRectMake(offset_x * scale_x, offset_y * scale_y, width * scale_x, height * scale_y)];
//        ((PhotoPreViewEffectController*)segue.destinationViewController).edting_img = cutted_img;
//    }
//}

- (UIImage*)clipImage:(UIImage*)image withRect:(CGRect)rect {
    
    CGImageRef subImageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    //    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    //    UIGraphicsBeginImageContext(smallBounds.size);
    //    CGContextRef context = UIGraphicsGetCurrentContext();
    //    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    //    UIGraphicsEndImageContext();
    
    return smallImage;
}
@end
