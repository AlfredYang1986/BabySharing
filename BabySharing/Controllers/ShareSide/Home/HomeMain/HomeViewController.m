//
//  HomeViewController.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 9/01/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "HomeViewController.h"

#import "QueryModel.h"
#import "AppDelegate.h"
#import "QueryContent+ContextOpt.h"
#import "QueryContentItem.h"
#import "TmpFileStorageModel.h"
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "MoviePlayTrait.h"
#import "INTUAnimationEngine.h"
#import "QueryCell.h"
#import "QueryHeader.h"
#import "INTUAnimationEngine.h"
#import "BWStatusBarOverlay.h"
#import "HomeDataDelegate.h"
#import "PersonalCentreTmpViewController.h"
#import "PersonalCentreOthersDelegate.h"
#import "HomeViewTableCellDelegate.h"
#import "ChatGroupController.h"
#import "Targets.h"
#import "QueryContent.h"
#import "OBShapedButton.h"
#import "ContentCardView.h"
#import "HomeCell.h"
#import "MJRefresh.h"
#import "Define.h"

#define HEADER_MARGIN_TO_SCREEN 10.5
#define CONTENT_START_POINT     71
#define PAN_HANDLE_CHECK_POINT  10

#define VIEW_BOUNTDS        CGFloat screen_width = [UIScreen mainScreen].bounds.size.width; \
                            CGFloat screen_height = [UIScreen mainScreen].bounds.size.height; \
                            CGRect rc = CGRectMake(0, 0, screen_width, screen_height);

#define QUERY_VIEW_START    CGRectMake(HEADER_MARGIN_TO_SCREEN, -44, rc.size.width - 2 * HEADER_MARGIN_TO_SCREEN, rc.size.height)
#define QUERY_VIEW_SCROLL   CGRectMake(HEADER_MARGIN_TO_SCREEN, 0, rc.size.width - 2 * HEADER_MARGIN_TO_SCREEN, rc.size.height)
#define QUERY_VIEW_END      CGRectMake(-rc.size.width, -44, rc.size.width, rc.size.height)

#define BACK_TO_TOP_TIME    3.0
#define SHADOW_WIDTH 4
#define MARGIN_BETWEEN_CARD     3

#define DEBUG_NEW_HOME_PAGE
// 减速度
#define DECELERATION 400.0

//@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource, QueryCellActionProtocol> //, HomeSegControlDelegate>
@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate>
    
//@property (weak, nonatomic) IBOutlet UITableView *queryView;
@property (weak, nonatomic, readonly) NSString* current_user_id;
@property (weak, nonatomic, readonly) NSString* current_auth_token;
@property (weak, nonatomic, readonly) QueryModel* qm;
@property (nonatomic) BOOL isLoading;

@end

@implementation HomeViewController {
    MoviePlayTrait* trait;
    
    UIView* bkView;
    UITapGestureRecognizer* tap;
    BOOL showBack2Top;
    CGFloat offset_y;
    
    HomeViewTableCellDelegate* datasource;
    
    NSMutableArray* queryViewLst;
    
    CGPoint point;
    BOOL isAnimation;
    
    UITableView *queryView;
    CGFloat rowHeight;
    NSMutableArray<QueryContent *> *queryViewData;
   
    CATextLayer* badge;
    
    CGFloat contentOffsetY;
    NSTimer *timer;
    CGFloat duration;
    CGFloat velocity;
    CGFloat distance;
    CGFloat allDistance;
    CGFloat acceleration;
    CGFloat startIndex;
    CGFloat endIndex;
    BOOL isDecelerate;
    UIButton* actionView;
    CAShapeLayer *circleLayer;
    UIView *animationView;
    CGFloat radius;
    CALayer *maskLayer;
}

@synthesize current_auth_token = _current_auth_token;
@synthesize current_user_id = _current_user_id;
@synthesize qm = _qm;
@synthesize isLoading = _isLoading;
@synthesize delegate = _delegate;

@synthesize isPushed = _isPushed;
@synthesize nav_title = _nav_title;

@synthesize current_index = _current_index;

- (void)loadView {
    [super loadView];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        [[UINavigationBar appearance] setShadowImage:[self imageWithColor:[UIColor colorWithWhite:0.5922 alpha:0.25] size:CGSizeMake(width, 1)]];
        [[UINavigationBar appearance] setBackgroundImage:[self imageWithColor:[UIColor whiteColor] size:CGSizeMake(width, 64)] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    }
    rowHeight = [UIScreen mainScreen].bounds.size.height - 60 - 44 - 35;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    _current_user_id = delegate.lm.current_user_id;
    _current_auth_token = delegate.lm.current_auth_token;
    _qm = delegate.qm;
    
    _isLoading = NO;
    
    trait = [[MoviePlayTrait alloc]init];

    [self layoutTableViews];
    
    BWStatusBarOverlay* tmp = [BWStatusBarOverlay shared];
    [tmp setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [tmp setBackgroundColor:[UIColor colorWithRed:0.3126 green:0.7529 blue:0.6941 alpha:1.f]];
    [tmp.textLabel setTextColor:[UIColor whiteColor]];
    showBack2Top = YES;
    
    tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back2TopHandler:)];
    [tmp addGestureRecognizer:tap];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    datasource = [[HomeViewTableCellDelegate alloc]init];
    datasource.trait = trait;
    datasource.controller = self;
    datasource.delegate = _delegate;
    datasource.current_index = _current_index;
   
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
#ifdef DEBUG_NEW_HOME_PAGE
#define CONTENT_TAB_BAT_HEIGHT          (_isPushed ? 0 : 49)
    {
        
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat height = [UIScreen mainScreen].bounds.size.height - 64 - CONTENT_TAB_BAT_HEIGHT;
        queryViewData = [NSMutableArray array];
        queryView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, width, height)];
        queryView.backgroundColor = [UIColor colorWithRed:0.9529 green:0.9529 blue:0.9529 alpha:1.f];
        queryView.dataSource = self;
        queryView.delegate = self;
        queryView.separatorStyle = UITableViewCellSeparatorStyleNone;
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 12.5)];
        footView.backgroundColor = Background;
        [queryView setTableFooterView:footView];
        
        if (!_isPushed) {
            __unsafe_unretained UITableView *tableView = queryView;
            
            // 下拉刷新
            tableView.mj_header = [BSRefreshAnimationHeader headerWithRefreshingBlock:^{
                [_delegate collectData:^(NSArray *data) {
                    [queryView reloadData];
                    [tableView.mj_header endRefreshing];
                }];
            }];

            // 设置自动切换透明度(在导航栏下面自动隐藏)
            tableView.mj_header.automaticallyChangeAlpha = YES;
            
            // 上拉刷新
            tableView.mj_footer = [BSRefreshAnimationFooter footerWithRefreshingBlock:^{
                [_delegate appendData:^(NSArray *data) {
                    [queryView reloadData];
                    [tableView.mj_footer endRefreshing];
                }];
            }];
        }
        
        [self.view addSubview:queryView];
        [self.view bringSubviewToFront:queryView];
    }
#else
    [self createContentCardView];
#endif
    
    for (int index = 0; index < queryViewLst.count; ++index) {
        ContentCardView* tmp = [queryViewLst objectAtIndex:index];
        tmp.queryView.tag = index + _current_index;
    }
    
    isAnimation = NO;
    
    [self createNavActionView];
    [self createHomeContentLogo];
    [self createAnimateView];
    
    [self.view bringSubviewToFront:bkView];
    self.view.backgroundColor = [UIColor colorWithRed:0.9529 green:0.9529 blue:0.9529 alpha:1.f];
    
    if (_isPushed) {
        UILabel* label = [[UILabel alloc]init];
        label.text = _nav_title;
        label.textColor = [UIColor colorWithWhite:0.5059 alpha:1.f];
        [label sizeToFit];
        self.navigationItem.titleView = label;
        
        UIButton* barBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
        NSString* filepath = [resourceBundle pathForResource:@"dongda_back" ofType:@"png"];
        CALayer * layer = [CALayer layer];
        layer.contents = (id)[UIImage imageNamed:filepath].CGImage;
        layer.frame = CGRectMake(-12, 0, 25, 25);
    //    layer.position = CGPointMake(barBtn.frame.size.width / 2, barBtn.frame.size.height / 2);
        [barBtn.layer addSublayer:layer];
        [barBtn addTarget:self action:@selector(didPopViewControllerBtn) forControlEvents:UIControlEventTouchDown];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:barBtn];
        
        bkView.hidden = YES;
    }
    

}

- (void)setDataelegate:(id<HomeViewControllerDataDelegate>)delegate {
    _delegate = delegate;
    datasource.delegate = delegate;
}

- (void)setCurrentContentIndex:(NSInteger)current_index {
    _current_index = current_index;
    
    for (int index = 0; index < queryViewLst.count; ++index) {
        ContentCardView *tmp = [queryViewLst objectAtIndex:index];
        tmp.queryView.tag = index + current_index;
    }
}

#pragma mark -- create navigation action view
- (void)createNavActionView {
    
    actionView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 130, 38)];
    actionView.backgroundColor = [UIColor colorWithRed:78.0/255.0 green:219.0/255.0 blue:202.0/255.0 alpha:1.0];
    
    [actionView addTarget:self action:@selector(didSelectChatGroupBtn) forControlEvents:UIControlEventTouchUpInside];
    actionView.tag = -99;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    actionView.center = CGPointMake(width - actionView.frame.size.width / 2 + 5 + 65, 21 + actionView.frame.size.height / 2);
  
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    NSString* filepath = [resourceBundle pathForResource:@"home_chat_back" ofType:@"png"];
    CALayer *layer = [[CALayer alloc] init];
    layer.frame = CGRectMake(0, 0, 30, 30);
    layer.position = CGPointMake(CGRectGetWidth(actionView.frame) / 2 - 65 / 2 - 0.5 - 4.5, CGRectGetHeight(actionView.frame) / 2);
    layer.contents = (id)([UIImage imageNamed:filepath].CGImage);
    [actionView.layer addSublayer:layer];

    maskLayer = [[CALayer alloc] init];
    maskLayer.frame = CGRectMake(0, 0, sqrt(pow(15, 2)), sqrt(pow(15, 2)));
    maskLayer.position = CGPointMake(15, 15);
    maskLayer.backgroundColor = [UIColor colorWithRed:78.0/255.0 green:219.0/255.0 blue:202.0/255.0 alpha:1.0].CGColor;
    [layer addSublayer:maskLayer];
    
    actionView.layer.cornerRadius = 19;
    actionView.layer.shadowColor = [UIColor blackColor].CGColor;
    actionView.layer.shadowOffset = CGSizeMake(-1, 1);
    actionView.layer.shadowOpacity = 0.3;
    actionView.layer.shadowRadius = 1;
//    加入两个线条
    [bkView addSubview:actionView];
    
    // badge
    CGPoint animateCenter = [actionView convertPoint:CGPointMake(28, actionView.frame.size.height / 2) toView:actionView];
    badge = [CATextLayer layer];
    badge.fontSize = 11.f;
    badge.contentsScale = 2.f;
    badge.backgroundColor = [UIColor clearColor].CGColor;
    badge.foregroundColor = [UIColor whiteColor].CGColor;
    badge.alignmentMode = @"center";
    
    CGSize sz = [@"..." sizeWithFont:[UIFont systemFontOfSize:11.f] constrainedToSize:CGSizeMake(FLT_MAX, FLT_MAX)];
    badge.frame = CGRectMake(0, 0, sz.width, sz.height);
    
    badge.position = CGPointMake(animateCenter.x, animateCenter.y);
    [actionView.layer addSublayer:badge];
}

#pragma mark -- dong da home content logo
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

    
    UIBezierPath *startCircle = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(CGRectMake(0, 0, CGRectGetWidth(animationView.frame), CGRectGetHeight(animationView.frame)), radius - 19, radius - 19)];
    circleLayer = [[CAShapeLayer alloc] init];
    circleLayer.backgroundColor = [UIColor redColor].CGColor;
    circleLayer.path = startCircle.CGPath;
    animationView.layer.mask = circleLayer;
    [bkView addSubview:animationView];
    bkView.clipsToBounds = YES;
    [bkView bringSubviewToFront:actionView];
    

}

- (NSInteger)getShowingIndex:(UITableView*)tableView {
    return _current_index;
}

- (void)didPopViewControllerBtn {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)layoutTableViews {
    CGFloat screen_width = [UIScreen mainScreen].bounds.size.width;
    bkView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 64)];
    bkView.backgroundColor = [UIColor whiteColor];
    
    CALayer* line = [CALayer layer];
    line.borderWidth = 1.f;
    line.borderColor = [UIColor colorWithRed:0.5922 green:0.5922 blue:0.5922 alpha:0.25].CGColor;
    line.frame = CGRectMake(0, 63, screen_width, 1);
    [bkView.layer addSublayer:line];
//    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0, 63, screen_width, 2)];
//    line.backgroundColor = [UIColor colorWithRed:0.5922 green:0.5922 blue:0.5922 alpha:0.25];
//    [bkView addSubview:line];
    
    [self.view addSubview:bkView];
    [self.view bringSubviewToFront:bkView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:!_isPushed animated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTagAnimation" object:nil];
    
    if (_delegate == nil) {
        self.delegate = [[MainHomeViewDataDelegate alloc] init];
    }
    
    if ([_delegate isKindOfClass:[MainHomeViewDataDelegate class]]) {
//        self.navigationController.navigationBar.hidden = NO;
        self.tabBarController.tabBar.hidden = NO;
    } else {
        self.tabBarController.tabBar.hidden = YES;
    }
    
    int count = [GotyeOCAPI getTotalUnreadMessageCount];
    if (count == 0) {
        badge.hidden = YES;
    } else if (count > 99) {
        badge.string = @"...";
    } else {
        badge.string = [NSString stringWithFormat:@"%d", count];
    }
    if ([self getShowingIndex:queryView] != 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[self getShowingIndex:queryView] inSection:0];
        [queryView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}

- (void)test {
    NSLog(@"fdfdsd");
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _current_index = 0;
}

- (void)back2TopHandler:(UITapGestureRecognizer*)gesture {
//    [_queryView setContentOffset:CGPointZero animated:YES];
}

#pragma mark -- scroll refresh
- (void)dealloc {
    BWStatusBarOverlay* tmp = [BWStatusBarOverlay shared];
    [tmp removeGestureRecognizer:tap];
}

#pragma mark -- segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"HomeDetailSegue"]) {

        self.tabBarController.tabBar.hidden = YES;
    } else if ([segue.identifier isEqualToString:@"search"]) {
        
    } else if ([segue.identifier isEqualToString:@"ChatSegue"]) {
        Targets* tmp = (Targets*)sender;
        ((ChatGroupController*)segue.destinationViewController).group_id = tmp.group_id;
        ((ChatGroupController*)segue.destinationViewController).joiner_count = tmp.number_count;
        ((ChatGroupController*)segue.destinationViewController).group_name = tmp.target_name;
        ((ChatGroupController*)segue.destinationViewController).founder_id = tmp.owner_id;
    }
}

#pragma mark -- QueryCellActionProtocol
- (void)didSelectLikeBtn:(id)content complete:(complete)complete{
    NSLog(@"collect for this user");
    QueryContent* cur = (QueryContent*)content;
    NSLog(@"like post id: %@", cur.content_post_id);
    
    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [delegate.pm postLikeToServiceWithPostID:cur.content_post_id withFinishBlock:^(BOOL success, QueryContent *content) {
//        if (success) {
//            NSLog(@"like post success");
//            NSString* msg = @"like post success";
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:msg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
//            [alert show];
//        }
        complete(success);
    }];
}
- (void)didSelectJoinGroupBtn:(id)content {
//    [self performSegueWithIdentifier:@"HomeDetailSegue" sender:content];
  
    /**
     * 0. get create info
     */
    QueryContent* cur = (QueryContent*)content;
    NSLog(@"like post id: %@", cur.content_post_id);
    NSString* post_id = cur.content_post_id;
    NSString* content_description = cur.content_description;
    NSString* owner_id = cur.owner_id;
    /**
     * 1. check is there chat group exist
     *      1.1 query if exist
     *      1.2 create if not
     */
    AppDelegate* app = [UIApplication sharedApplication].delegate;
    [app.mm createChatGroupWithGroupThemeName:content_description andPostID:post_id andOwnerID:owner_id andFinishBlock:^(BOOL success, id result) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ChatGroupController* pc = [storyboard instantiateViewControllerWithIdentifier:@"chatGroup"];
        NSDictionary* tar = (NSDictionary*)result;
        pc.group_id = [tar objectForKey:@"group_id"];//group_id;
        pc.joiner_count = [tar objectForKey:@"joiners_count"];//tmp.number_count;
        pc.group_name = [tar objectForKey:@"group_name"];//tmp.target_name;
        pc.founder_id = [tar objectForKey:@"owner_id"];//tmp.owner_id;
        [self.navigationController setNavigationBarHidden:NO];
        [self.navigationController pushViewController:pc animated:YES];
    }];
}

- (void)didSelectCollectionBtn:(id)content {
    NSLog(@"collect for this user");
    QueryContent* cur = (QueryContent*)content;
    NSLog(@"like post id: %@", cur.content_post_id);
    
    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [delegate.pm postPushToServiceWithPostID:cur.content_post_id withFinishBlock:^(BOOL success, QueryContent *content) {
        if (success) {
            NSLog(@"push post success");
            NSString* msg = @"push post success";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"暂时先给个暂时的" message:msg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
            [alert show];
        }
    }];
}

- (void)didSelectNotLikeBtn:(id)content complete:(complete)complete{
    NSLog(@"collect for this user");
    QueryContent* cur = (QueryContent*)content;
    NSLog(@"like post id: %@", cur.content_post_id);
    
    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [delegate.pm postUnLikeToServiceWithPostID:cur.content_post_id withFinishBlock:^(BOOL success, QueryContent *content) {
        //        if (success) {
        //            NSLog(@"like post success");
        //            NSString* msg = @"like post success";
        //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:msg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        //            [alert show];
        //        }
        complete(success);
    }];
}

- (void)didSelectScreenImg:(id)content {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PersonalCentreTmpViewController* pc = [storyboard instantiateViewControllerWithIdentifier:@"PersonalCenter"];
    PersonalCentreOthersDelegate* delegate = [[PersonalCentreOthersDelegate alloc]init];
    pc.current_delegate = delegate;
    pc.owner_id = ((QueryContent*)content).owner_id;
    pc.isPushed = YES;
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController pushViewController:pc animated:YES];
}

#pragma mark -- search controller
- (void)didSelectSearchBtn:(id)content {
    [self performSegueWithIdentifier:@"search" sender:nil];
}

#pragma mark -- chat group controller
- (void)didSelectChatGroupBtn {
//    [self performSegueWithIdentifier:@"ChatGroupSegue" sender:nil];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController* groupVC = [storyboard instantiateViewControllerWithIdentifier:@"cycleViewController"];
    groupVC.view.frame = CGRectMake(CGRectGetWidth(self.navigationController.view.frame), 0, CGRectGetWidth(self.navigationController.view.frame), CGRectGetHeight(self.navigationController.view.frame));
//    groupVC.view.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:groupVC.view];
    [self.view bringSubviewToFront:bkView];
    actionView.enabled = NO;
    
    CABasicAnimation *maskLayerAnimation = [circleLayer animationForKey:@"path"] ? (CABasicAnimation *)[circleLayer animationForKey:@"path"] : [CABasicAnimation animationWithKeyPath:@"path"];
    CGRect endRect = CGRectMake(0, 0, CGRectGetWidth(animationView.frame), CGRectGetHeight(animationView.frame));
    maskLayerAnimation.fromValue = (__bridge id)(circleLayer.path);
    maskLayerAnimation.toValue = (__bridge id)([UIBezierPath bezierPathWithOvalInRect:endRect].CGPath);
    maskLayerAnimation.duration = 0.4;
    maskLayerAnimation.delegate = self;
    [circleLayer addAnimation:maskLayerAnimation forKey:@"path"];
    
    CABasicAnimation *shadowAnimation = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
    shadowAnimation.fillMode=kCAFillModeForwards;
    shadowAnimation.removedOnCompletion = NO;
    shadowAnimation.duration = 0.0;
    shadowAnimation.fromValue = [NSNumber numberWithFloat:0.3];
    shadowAnimation.toValue = [NSNumber numberWithFloat:0.0];
    [actionView.layer addAnimation:shadowAnimation forKey:@"shadowOpacity"];
    
    // 设定为缩放
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    // 动画选项设定
    scaleAnimation.duration = 0.4; // 动画持续时间
    scaleAnimation.repeatCount = 1; // 重复次数
    // 缩放倍数
    scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0]; // 开始时的倍率
    scaleAnimation.toValue = [NSNumber numberWithFloat:0.0]; // 结束时的倍率
    // 添加动画
    [maskLayer addAnimation:scaleAnimation forKey:@"scale-layer"];

    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        for (UIView *subView in self.view.subviews) {
            if (![subView isEqual:bkView]) {
                subView.frame = CGRectMake(CGRectGetMinX(subView.frame) - [UIScreen mainScreen].bounds.size.width, CGRectGetMinY(subView.frame), CGRectGetWidth(subView.frame), CGRectGetHeight(subView.frame));
            }
        }
        self.tabBarController.tabBar.frame = CGRectMake(CGRectGetMinX(self.tabBarController.tabBar.frame) - CGRectGetWidth(self.tabBarController.tabBar.frame), CGRectGetMinY(self.tabBarController.tabBar.frame), CGRectGetWidth(self.tabBarController.tabBar.frame), CGRectGetHeight(self.tabBarController.tabBar.frame));
    } completion:^(BOOL finished) {
        groupVC.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        [groupVC.view removeFromSuperview];
        [self.navigationController pushViewController:groupVC animated:NO];
        for (UIView *subView in self.view.subviews) {
            if (![subView isEqual:bkView]) {
                subView.frame = CGRectMake(CGRectGetMinX(subView.frame) + [UIScreen mainScreen].bounds.size.width, CGRectGetMinY(subView.frame), CGRectGetWidth(subView.frame), CGRectGetHeight(subView.frame));
            }
        }
        CABasicAnimation *shadowAnimation = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
        shadowAnimation.fillMode=kCAFillModeForwards;
        shadowAnimation.removedOnCompletion = NO;
        shadowAnimation.duration = 0.0;
        shadowAnimation.fromValue = [NSNumber numberWithFloat:0.0];
        shadowAnimation.toValue = [NSNumber numberWithFloat:0.3];
        [actionView.layer addAnimation:shadowAnimation forKey:@"shadowOpacity"];
//        actionView.layer.shadowOpacity = 0.3;
        actionView.enabled = YES;
    }];
}

#pragma mark -- enter chat group
- (void)pushControllerWithTarget:(Targets*)target {
    [self performSegueWithIdentifier:@"ChatSegue" sender:target];
}

#pragma mark -- table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 100;
    return [_delegate count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return rowHeight;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"homeCell"];
    if (cell == nil) {
        cell = [[HomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"homeCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.number.textAlignment = NSTextAlignmentCenter;
        cell.delegate = self;
    }
    cell.indexPath = indexPath;
//    UILabel *lable = [cell.contentView viewWithTag:90];
//    lable.text = [NSString stringWithFormat:@"%ld", indexPath.row];
    [cell updateViewWith:[_delegate queryItemAtIndex:indexPath.row]];
//    [cell updateViewWith:[_delegate queryItemAtIndex:0]];
//    cell.number.text = [NSString stringWithFormat:@"%ld", indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    HomeCell *homeCell = (HomeCell *)cell;
//    [homeCell stopViedo];
}

#pragma mark scrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    contentOffsetY = scrollView.contentOffset.y;
//    [timer invalidate];
//    timer = nil;
    [self stopAnimation];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (queryView.mj_header.state == MJRefreshStateRefreshing || queryView.mj_footer.state == MJRefreshStateRefreshing) {
        return;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (queryView.mj_header.state == MJRefreshStateRefreshing || queryView.mj_footer.state == MJRefreshStateRefreshing) {
        return;
    }
    if (scrollView.contentOffset.y < 0 || scrollView.contentOffset.y > (scrollView.contentSize.height -CGRectGetHeight(scrollView.frame))) {
        return;
    }
    isDecelerate = decelerate;
    [scrollView setContentOffset:scrollView.contentOffset];
    velocity = -[[scrollView panGestureRecognizer] velocityInView:scrollView].y / rowHeight;
    acceleration = -velocity * 30 * (1.0 - 0.9);
    distance = -pow(velocity, 2.0) / (2.0 * acceleration);
    dispatch_async(dispatch_get_main_queue(), ^{
        [scrollView setContentOffset:scrollView.contentOffset animated:NO];
        [self scrollToItemWithScrollView:scrollView];
    });
}

- (void)scrollToItemWithScrollView:(UIScrollView *)scrollView {
    NSLog(@"MonkeyHengLog: %@ === %f", @"速度", velocity);
    if (!isDecelerate) {
        NSLog(@"拖动终止为0");
        CGFloat offsetY = scrollView.contentOffset.y - floor(scrollView.contentOffset.y / rowHeight) * rowHeight;
        if (offsetY > rowHeight / 2) {
            [scrollView setContentOffset:CGPointMake(0, scrollView.contentOffset.y + rowHeight - offsetY) animated:YES];
        } else {
            [scrollView setContentOffset:CGPointMake(0, scrollView.contentOffset.y - offsetY) animated:YES];
        }
        return;
    }
    
    if (fabs(velocity) > 2.0) {
        NSLog(@"正常滚动");
        startIndex = scrollView.contentOffset.y / rowHeight;
        endIndex = startIndex + distance;
        endIndex = distance > 0 ? ceil(endIndex) : floor(endIndex);
        // 归位
        distance = endIndex - startIndex;
        duration = fabs(distance) / fabs(0.5 * velocity);
        acceleration = -velocity / duration;
    } else {
        CGFloat offsetY = scrollView.contentOffset.y - floor(scrollView.contentOffset.y / rowHeight) * rowHeight;
        if (offsetY > rowHeight / 2) {
            [scrollView setContentOffset:CGPointMake(0, scrollView.contentOffset.y + rowHeight - offsetY) animated:YES];
        } else {
            [scrollView setContentOffset:CGPointMake(0, scrollView.contentOffset.y - offsetY) animated:YES];
        }
        return;
    }
    allDistance = 0;
    [self starAnimation];
}

- (void)starAnimation {
    if (!timer) {
        timer = [NSTimer timerWithTimeInterval:1.0/60.0
                                             target:self
                                           selector:@selector(step)
                                           userInfo:nil
                                            repeats:YES];
        
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    }
}

- (void)step {
    CGFloat time = MIN(duration, 1.000000 / 60.000000); // 时间
    CGFloat offsetIndex = velocity * time + 0.5 * acceleration * pow(time, 2.0);
    velocity = velocity + acceleration * time;
    allDistance += offsetIndex;
    if (offsetIndex < 0.0 && distance > 0.0) {
        offsetIndex = distance - allDistance + offsetIndex;
        [self stopAnimation];
        allDistance = 0;
    } else if (offsetIndex > 0.0 && distance < 0.0) {
        offsetIndex = distance - allDistance + offsetIndex;
        [self stopAnimation];
        allDistance = 0;
    }
    CGPoint offset = CGPointMake(0, queryView.contentOffset.y + offsetIndex * rowHeight);
    if (offset.y > 0 && offset.y < (queryView.contentSize.height - queryView.frame.size.height)) {
        [queryView setContentOffset:CGPointMake(0, queryView.contentOffset.y + offsetIndex * rowHeight)];
        [queryView layoutIfNeeded];
    } else {
        if (offset.y <= 0) {
            [queryView setContentOffset:CGPointMake(0, 0)];
        } else if(offset.y >= (queryView.contentSize.height - queryView.frame.size.height)){
            [queryView setContentOffset:CGPointMake(0, queryView.contentSize.height - queryView.frame.size.height)];
        }
        [queryView layoutIfNeeded];
        [self stopAnimation];
    }
}

- (void)stopAnimation
{
    [timer invalidate];
    timer = nil;
}

@end
