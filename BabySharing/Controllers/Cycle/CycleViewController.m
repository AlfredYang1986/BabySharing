//
//  CycleViewController.m
//  BabySharing
//
//  Created by Alfred Yang on 12/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "CycleViewController.h"
#import "AppDelegate.h"
#import "LoginModel.h"
#import "MessageModel.h"
#import "DropDownMenu.h"
#import "WEPopoverController.h"
#import "MyCycleCellHeader.h"

#import "CycleAddDescriptionViewController.h"
#import "CycleDetailController.h"

#import "Reachability.h"
#import "CycleOverCell.h"
#import "Targets.h"

#import "ChatGroupController.h"
#import "INTUAnimationEngine.h"
#import "HomeViewController.h"
#import "OBShapedButton.h"
#import "HomeViewController.h"

#define TABLE_VIEW_TOP_MARGIN   74

//<<<<<<< HEAD
///*DropDownMenuProcotol, WEPopoverControllerDelegate, UIPopoverControllerDelegate,*/
@interface CycleViewController () <UITableViewDataSource, UITableViewDelegate,  createUpdateDetailProtocol>
@property (strong, nonatomic) UITableView *cycleTableView;

@property (weak, nonatomic) LoginModel* lm;
@property (weak, nonatomic) MessageModel* mm;
@property (weak, nonatomic) Reachability* ry;

@property (weak, nonatomic) id<CycleSyncDataProtocol> notifyObject;
@end

@implementation CycleViewController {
//	WEPopoverController *popoverController;
    
    NSMutableDictionary* dic_description;
    BOOL isSync;
    
    BOOL isRecommmend;
    
    NSArray* chatGroupArray_mine;
    NSArray* chatGroupArray_recommend;
    UIView *bkView;
    UIButton* actionView;
    CAShapeLayer *circleLayer;
    UIView *animationView;
    CGFloat radius;
    CGPathRef startPath;
    
    CALayer *scaleMaskLayer;
}

//@synthesize descriptionView = _descriptionView;
@synthesize cycleTableView = _cycleTableView;

@synthesize lm = _lm;
@synthesize mm = _mm;
@synthesize ry = _ry;

@synthesize notifyObject = _notifyObject;

@synthesize baseController = _baseController;

- (void)viewDidLoad {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        [[UINavigationBar appearance] setShadowImage:[self imageWithColor:[UIColor colorWithWhite:0.5922 alpha:0.25] size:CGSizeMake(width, 1)]];
        [[UINavigationBar appearance] setBackgroundImage:[self imageWithColor:[UIColor whiteColor] size:CGSizeMake(width, 64)] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    }
    bkView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    bkView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bkView];
    [self createNavigationBar];
    [self createHomeContentLogo];
    [self createAnimateView];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
//    GotyeOCGroup* group = [GotyeOCGroup groupWithId:_current_session.group_id.longLongValue];

    CALayer* line_notify = [CALayer layer];
    line_notify.borderWidth = 1.f;
    line_notify.borderColor = [UIColor colorWithWhite:0.5922 alpha:0.10].CGColor;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    line_notify.frame = CGRectMake(0, 73, width, 1);
    [self.view.layer addSublayer:line_notify];

    _cycleTableView = [[UITableView alloc] init];
    [self.view addSubview:_cycleTableView];
    _cycleTableView.dataSource = self;
    _cycleTableView.delegate = self;
    [_cycleTableView registerNib:[UINib nibWithNibName:@"CycleOverCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cycle over cell"];
    [_cycleTableView registerClass:[MyCycleCellHeader class] forHeaderFooterViewReuseIdentifier:@"my cycle header"];
   
    self.preferredContentSize = CGSizeMake(100, 100);
    
    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    _lm = app.lm;
    _mm = app.mm;
    _ry = app.reachability;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];

    isRecommmend = NO;
    isSync = NO;
  
    if (_ry.isReachable) {
        [self resetDataForViews];
    }
    
    UILabel* label_t = [[UILabel alloc]init];
    label_t.text = @"圈聊";
    label_t.textColor = [UIColor colorWithRed:0.3059 green:0.3059 blue:0.3059 alpha:1.f];
    label_t.font = [UIFont systemFontOfSize:18.f];
    [label_t sizeToFit];
    self.navigationItem.titleView = label_t;
   
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    
    
    UIButton* barBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    NSString* filepath = [resourceBundle pathForResource:@"dongda_back" ofType:@"png"];
    CALayer * layer = [CALayer layer];
    layer.contents = (id)[UIImage imageNamed:filepath].CGImage;
    layer.frame = CGRectMake(-12, 0, 25, 25);
//    layer.position = CGPointMake(barBtn.frame.size.width / 2, barBtn.frame.size.height / 2);
    [barBtn.layer addSublayer:layer];
    [barBtn addTarget:self action:@selector(didPopViewController) forControlEvents:UIControlEventTouchDown];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:barBtn];
    self.view.backgroundColor = [UIColor colorWithRed:0.9529 green:0.9529 blue:0.9529 alpha:1.f];
    
    _cycleTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.hidesBottomBarWhenPushed = YES;
}

- (void)createNavigationBar {
    actionView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 65, 38)];
    
    [actionView addTarget:self action:@selector(popToHomeViewController) forControlEvents:UIControlEventTouchUpInside];
    actionView.tag = -99;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    actionView.center = CGPointMake(width - actionView.frame.size.width / 2 + 5, 21 + actionView.frame.size.height / 2);
    actionView.backgroundColor = [UIColor colorWithRed:78.0/255.0 green:219.0/255.0 blue:202.0/255.0 alpha:1.0];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:actionView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(20, 20)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = actionView.bounds;
    maskLayer.path = maskPath.CGPath;
    actionView.layer.mask = maskLayer;
    
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    NSString* filepath = [resourceBundle pathForResource:@"home_chat_back" ofType:@"png"];
    CALayer *layer = [[CALayer alloc] init];
    layer.frame = CGRectMake(0, 0, 30, 30);
    layer.position = CGPointMake(CGRectGetWidth(actionView.frame) / 2 - 4.5, CGRectGetHeight(actionView.frame) / 2);
    layer.contents = (__bridge id _Nullable)([UIImage imageNamed:filepath].CGImage);
    [actionView.layer addSublayer:layer];
    
    scaleMaskLayer = [[CALayer alloc] init];
    scaleMaskLayer.frame = CGRectMake(0, 0, 15, 15);
    scaleMaskLayer.transform = CATransform3DMakeScale(0, 0, 0);
    scaleMaskLayer.position = CGPointMake(15, 15);
    scaleMaskLayer.backgroundColor = [UIColor colorWithRed:78.0/255.0 green:219.0/255.0 blue:202.0/255.0 alpha:1.0].CGColor;
    [layer addSublayer:scaleMaskLayer];
    
    [bkView addSubview:actionView];
}

- (void)createHomeContentLogo {
    UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 70, 22)];
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    NSString* filepath = [resourceBundle pathForResource:@"home_title_logo" ofType:@"png"];
    imgView.image = [UIImage imageNamed:filepath];
    imgView.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2 + 2, 12 + 64 / 2);
    imgView.tag = -98;
    [bkView addSubview:imgView];
}

- (void)createAnimateView {
    // 动画的layer
    CGPoint animateCenter = [actionView convertPoint:CGPointMake(19, actionView.frame.size.height / 2) toView:bkView];
    
    // 半径
    radius = sqrt(pow(0 - animateCenter.x, 2) + pow(0 - animateCenter.y, 2));
    animationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, radius * 2, radius * 2)];
    animationView.backgroundColor = [UIColor colorWithRed:78.0/255.0 green:219.0/255.0 blue:202.0/255.0 alpha:1.0];
    animationView.center = animateCenter;
    
    UIBezierPath *startCircle = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, CGRectGetWidth(animationView.frame), CGRectGetHeight(animationView.frame))];
    circleLayer = [[CAShapeLayer alloc] init];
    circleLayer.path = startCircle.CGPath;
    animationView.layer.mask = circleLayer;
    [bkView addSubview:animationView];
    bkView.clipsToBounds = YES;
    [bkView bringSubviewToFront:actionView];
}

- (void)popToHomeViewController {
    // 获取倒数第二个ViewController
    actionView.enabled = NO;
    if ([[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2] isKindOfClass:[HomeViewController class]]) {
        HomeViewController *homeVC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            // handle completion here
            NSLog(@"pop结束");
            
            CABasicAnimation *maskLayerAnimation = [circleLayer animationForKey:@"path"] ? (CABasicAnimation *)[circleLayer animationForKey:@"path"] : [CABasicAnimation animationWithKeyPath:@"path"];
            //    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
            maskLayerAnimation.fromValue = (__bridge id)(circleLayer.path);
            maskLayerAnimation.toValue = (__bridge id)([UIBezierPath bezierPathWithOvalInRect:CGRectInset(CGRectMake(0, 0, CGRectGetWidth(animationView.frame), CGRectGetHeight(animationView.frame)), radius - 19, radius - 19)].CGPath);
            maskLayerAnimation.duration = 0.3;
            maskLayerAnimation.delegate = self;
            [circleLayer addAnimation:maskLayerAnimation forKey:@"path"];
            circleLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(CGRectMake(0, 0, CGRectGetWidth(animationView.frame), CGRectGetHeight(animationView.frame)), radius - 19, radius - 19)].CGPath;
            
            // 设定为缩放
            CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            
            // 动画选项设定
            scaleAnimation.duration = 0.4; // 动画持续时间
            scaleAnimation.repeatCount = 1; // 重复次数
            // 缩放倍数
            scaleAnimation.fromValue = [NSNumber numberWithFloat:0]; // 开始时的倍率
            scaleAnimation.toValue = [NSNumber numberWithFloat:1]; // 结束时的倍率
            // 添加动画
            [scaleMaskLayer addAnimation:scaleAnimation forKey:@"scale-layer"];
            
            // 设置各个view的frame
            homeVC.tabBarController.tabBar.hidden = NO;
            homeVC.tabBarController.tabBar.frame = CGRectMake(-CGRectGetWidth(homeVC.tabBarController.tabBar.frame), CGRectGetMinY(homeVC.tabBarController.tabBar.frame), CGRectGetWidth(homeVC.tabBarController.tabBar.frame), CGRectGetHeight(homeVC.tabBarController.tabBar.frame));
            homeVC.view.frame = CGRectMake(-CGRectGetWidth(homeVC.view.frame), 0, CGRectGetWidth(homeVC.view.frame), CGRectGetHeight(homeVC.view.frame));
            self.view.frame = CGRectMake(CGRectGetWidth(homeVC.view.frame), 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
            bkView.frame = CGRectMake(CGRectGetWidth(bkView.frame), 0, CGRectGetWidth(bkView.frame), CGRectGetHeight(bkView.frame));
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                homeVC.view.frame = CGRectMake(0, 0, CGRectGetWidth(homeVC.view.frame), CGRectGetHeight(homeVC.view.frame));
                bkView.frame = CGRectMake(0, 0, CGRectGetWidth(bkView.frame), CGRectGetHeight(bkView.frame));
                homeVC.tabBarController.tabBar.frame = CGRectMake(0, CGRectGetMinY(homeVC.tabBarController.tabBar.frame), CGRectGetWidth(homeVC.tabBarController.tabBar.frame), CGRectGetHeight(homeVC.tabBarController.tabBar.frame));
            } completion:^(BOOL finished) {
                [self.view removeFromSuperview];
                [bkView removeFromSuperview];
                actionView.enabled = YES;
            }];
        }];
        
        [self.navigationController popViewControllerAnimated:NO];
        homeVC.tabBarController.tabBar.hidden = YES;
        // 将当前view加到上一个VC.view
        self.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
        [homeVC.view addSubview:self.view];
        [homeVC.view bringSubviewToFront:self.view];
        [homeVC.view addSubview:bkView];
        [homeVC.view bringSubviewToFront:bkView];
        [CATransaction commit];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//取消searchbar背景色
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)didPopViewController {
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
//    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    dic_description = [[_lm currentDeltailInfoLocal] mutableCopy];
    chatGroupArray_mine = [_mm enumMyChatGroupLocal];
    chatGroupArray_recommend = [_mm enumRecommendChatGroupLocal];
//    [self viewDidLayoutSubviews];
}

- (void)reachabilityChanged:(Reachability*)sender {
    
    if (self.tabBarController.selectedIndex != 1) return;
    
    if ([sender isReachable]) {
        [self resetDataForViews];

    } else if (![sender isReachable]) {
        isSync = NO;
        [_notifyObject detailInfoSynced:isSync];
    }
}

- (void)resetDataForViews {
    [_lm currentDeltailInfoAsyncWithFinishBlock:^(BOOL success, NSDictionary * dic) {
        if (success) {
            dic_description = [dic mutableCopy];
            [_lm updateDetailInfoLocalWithData:dic];
            [_mm enumChatGroupWithFinishBlock:^(BOOL success, NSArray* result) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    chatGroupArray_mine = [_mm enumMyChatGroupLocal];
                    chatGroupArray_recommend = [_mm enumRecommendChatGroupLocal];
                    [_cycleTableView reloadData];
                });
            }];
            if (dic_description.count > 1) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self resetViews];
                });
            }
            isSync = YES;
            [_notifyObject detailInfoSynced:isSync];
        }
    }];
}

- (BOOL)isDescriptionValidate {
    return dic_description && dic_description.count > 1 && ((NSNumber*)[dic_description objectForKey:@"age"]).integerValue > 0 && ((NSArray*)[dic_description objectForKey:@"kids"]).count > 0;
}

- (void)resetViews {
    _cycleTableView.hidden = NO;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
  
    CGRect rc = CGRectMake(0, TABLE_VIEW_TOP_MARGIN, width, height - TABLE_VIEW_TOP_MARGIN);
    _cycleTableView.frame = rc;
    
//    [self resetViews];
}

- (BOOL)hasViewDescription {
    return [_lm isCurrentHasDetailInfo];
}

- (void)addDescriptionBtnSelected {
    [self performSegueWithIdentifier:@"addDescription" sender:nil];
}

#pragma mark -- table view delegate
- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0) {
    
    UITableViewRowAction * act = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"退 出" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        /**
         * 1. leave chat group
         */
        Targets* tmp = nil;
        if (indexPath.section == 0) {
            tmp = [chatGroupArray_mine objectAtIndex:indexPath.row];
        } else {
            tmp = [chatGroupArray_recommend objectAtIndex:indexPath.row];
        }
        
        NSNumber* group_id = tmp.group_id;
        
        [_mm leaveChatGroup:group_id andFinishBlock:^(BOOL success, id result) {
            /**
             * 2. table view reload data
             */
            chatGroupArray_mine = [_mm enumMyChatGroupLocal];
            [tableView reloadData];
        }];
        

        
    }];
    act.backgroundColor = [UIColor colorWithRed:0.2745 green:0.8588 blue:0.7922 alpha:1.f];

    UITableViewRowAction * act2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"取 消" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [tableView endEditing:YES];
        [tableView reloadData];
        
    }];
    act2.backgroundColor = [UIColor colorWithRed:0.6078 green:0.6078 blue:0.6078 alpha:1.f];
    
    return @[act2, act];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"enterChatGroup" sender:indexPath];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (isRecommmend) return 2;
    else return 1;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView* reVal = [[UIView alloc]init];
    reVal.backgroundColor = [UIColor whiteColor];
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    if (section == 0) {
        if ([tableView numberOfRowsInSection:section] == 0) {
            label.text = @"还没有加入过任何圈聊哦:)";
        } else {
            label.text = @"最近关注的";
        }
    } else {
        label.text = @"猜你喜欢";
    }
   
    label.textColor = [UIColor colorWithWhite:0.3509 alpha:1.f];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont boldSystemFontOfSize:12.f];
    [label sizeToFit];
    [reVal addSubview:label];
    
    label.center = CGPointMake(10.5f + label.frame.size.width / 2, 46 / 2);
    
    CALayer* line = [CALayer layer];
    line.borderColor = [UIColor colorWithWhite:0.5922 alpha:0.25].CGColor;
    line.borderWidth = 1.f;
    line.frame = CGRectMake(10.5, 46 - 1, [UIScreen mainScreen].bounds.size.width - 10.5, 1);
    [reVal.layer addSublayer:line];
    
    return reVal;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 46;
}

#pragma mark -- table view datasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [CycleOverCell preferredHeight];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return chatGroupArray_mine.count;
    } else {
        return chatGroupArray_recommend.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    CycleOverCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cycle over cell"];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CycleOverCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }

    Targets* tmp = nil;
    if (indexPath.section == 0) {
        tmp = [chatGroupArray_mine objectAtIndex:indexPath.row];
    } else {
        tmp = [chatGroupArray_recommend objectAtIndex:indexPath.row];
    }
   
    cell.current_session = tmp;
    
    return cell;
}

#pragma mark -- segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    ((UIViewController*)segue.destinationViewController).hidesBottomBarWhenPushed = YES;
    
    if ([segue.identifier isEqualToString:@"addCycle"]) {
    } else if ([segue.identifier isEqualToString:@"addDescription"]) {
        ((CycleAddDescriptionViewController*)segue.destinationViewController).lm = self.lm;
        ((CycleAddDescriptionViewController*)segue.destinationViewController).dic_description = dic_description;
        ((CycleAddDescriptionViewController*)segue.destinationViewController).isEditable = isSync;
        _notifyObject = (CycleAddDescriptionViewController*)segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"enterChatGroup"]) {
        
        NSIndexPath* path = (NSIndexPath*)sender;
        Targets* tmp = nil;
        if (path.section == 0) {
            tmp = [chatGroupArray_mine objectAtIndex:path.row];
        } else {
            tmp = [chatGroupArray_recommend objectAtIndex:path.row];
        }
        ((ChatGroupController*)segue.destinationViewController).group_id = tmp.group_id;
        ((ChatGroupController*)segue.destinationViewController).joiner_count = tmp.number_count;
        ((ChatGroupController*)segue.destinationViewController).group_name = tmp.target_name;
        ((ChatGroupController*)segue.destinationViewController).founder_id = tmp.owner_id;
    }
}

#pragma mark -- create update detail chat group
- (void)createUpdateChatGroup:(BOOL)success {
    if (success) {
        chatGroupArray_mine = [_mm enumMyChatGroupLocal];
        chatGroupArray_recommend = [_mm enumRecommendChatGroupLocal];
        [_cycleTableView reloadData];
    }
}

#pragma mark --
- (void)blockTouchEventForOtherViews {
    UIView* block_target = [self.view viewWithTag:-99];
    UIView* block_view = [[UIView alloc]initWithFrame:block_target.bounds];
    block_view.tag = -119;
    block_view.backgroundColor = [UIColor clearColor];
    [block_target addSubview:block_view];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backToHome:)];
    [block_view addGestureRecognizer:tap];
}

- (void)backToHome:(UITapGestureRecognizer*)gesture {
   
    static const CGFloat kAnimationDuration = 0.5; // in seconds
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
   
    UIView* target = [gesture.view superview];
    [gesture.view removeFromSuperview];
    CGRect rc_1 = CGRectMake(0, 0, width, height);
    CGRect rc_2 = CGRectMake(width - 100, 0, width, height);

    [INTUAnimationEngine animateWithDuration:kAnimationDuration
                                       delay:0.0
                                      easing:INTUEaseInOutQuadratic
                                     options:INTUAnimationOptionNone
                                  animations:^(CGFloat progress) {
                                      target.frame = INTUInterpolateCGRect(rc_2, rc_1, progress);
                                  }
                                  completion:^(BOOL finished) {
                                      NSLog(@"%@", finished ? @"Animation Completed" : @"Animation Canceled");
                                      [target removeFromSuperview];
                                      [self.navigationController popViewControllerAnimated:NO];
                                  }];
}

- (void)backToHomeThenPushChatGroup:(Targets*)tmp {
    static const CGFloat kAnimationDuration = 0.5; // in seconds
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    UIView* target = [self.view viewWithTag:-99];
    UIView* block_view = [target viewWithTag:-119];
    [block_view removeFromSuperview];
    CGRect rc_1 = CGRectMake(0, 0, width, height);
    CGRect rc_2 = CGRectMake(width - 100, 0, width, height);
    
    [INTUAnimationEngine animateWithDuration:kAnimationDuration
                                       delay:0.0
                                      easing:INTUEaseInOutQuadratic
                                     options:INTUAnimationOptionNone
                                  animations:^(CGFloat progress) {
                                      target.frame = INTUInterpolateCGRect(rc_2, rc_1, progress);
                                  }
                                  completion:^(BOOL finished) {
                                      NSLog(@"%@", finished ? @"Animation Completed" : @"Animation Canceled");
                                      [target removeFromSuperview];
                                      [self.navigationController popViewControllerAnimated:NO];
                                      [_baseController pushControllerWithTarget:tmp];
                                  }];
}
@end
