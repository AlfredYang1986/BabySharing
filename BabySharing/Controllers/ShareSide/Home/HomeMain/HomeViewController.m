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

#import "OBShapedButton.h"
#import "ContentCardView.h"

#import "MJRefresh.h"

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

//@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource, QueryCellActionProtocol> //, HomeSegControlDelegate>
@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate>
    
//@property (weak, nonatomic) IBOutlet UITableView *queryView;
@property (weak, nonatomic, readonly) NSString* current_user_id;
@property (weak, nonatomic, readonly) NSString* current_auth_token;
@property (weak, nonatomic, readonly) QueryModel* qm;
@property (nonatomic) BOOL isLoading;

@property (weak, nonatomic) IBOutlet UITableView *foundView;
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
    
    UITableView* queryView;
}

//@synthesize queryView = _queryView;
@synthesize current_auth_token = _current_auth_token;
@synthesize current_user_id = _current_user_id;
@synthesize qm = _qm;
@synthesize isLoading = _isLoading;
@synthesize delegate = _delegate;

//@synthesize foundView = _foundView;

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
    {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat height = [UIScreen mainScreen].bounds.size.height - 64 - 49;
        queryView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, width, height)];
        queryView.backgroundColor = [UIColor colorWithRed:0.9529 green:0.9529 blue:0.9529 alpha:1.f];
        queryView.dataSource = self;
        queryView.delegate = self;
        queryView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        queryView.bounces = NO;
       
        if (!_isPushed) {
            __unsafe_unretained UITableView *tableView = queryView;
            
            // 下拉刷新
            tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                [_delegate collectData:^(NSArray *data) {
                    [queryView reloadData];
                    [tableView.mj_header endRefreshing];
                }];
            }];
            
            // 设置自动切换透明度(在导航栏下面自动隐藏)
//            UIImage* img = [UIImage imageNamed:[resourceBundle pathForResource:@"home_refresh" ofType:@"gif"]];
            tableView.mj_header.automaticallyChangeAlpha = YES;
            
            // 上拉刷新
            tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
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
        ContentCardView* tmp = [queryViewLst objectAtIndex:index];
        tmp.queryView.tag = index + current_index;
    }
}

#pragma mark -- create navigation action view
- (UIView*)createNavActionView {
    
    OBShapedButton* actionView = [[OBShapedButton alloc]init];
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    NSString* filepath = [resourceBundle pathForResource:@"home_chatgroup_icon" ofType:@"png"];
    [actionView setBackgroundImage:[UIImage imageNamed:filepath] forState:UIControlStateNormal];
    [actionView addTarget:self action:@selector(didSelectChatGroupBtn) forControlEvents:UIControlEventTouchUpInside];
    actionView.tag = -99;
    actionView.frame = CGRectMake(0, 0, 69, 40);
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    actionView.center = CGPointMake(width - actionView.frame.size.width / 2 + 5, 21 + actionView.frame.size.height / 2);
    [bkView addSubview:actionView];

    return actionView;
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

#pragma mark -- table view for card content
- (ContentCardView *)createOneContentCardViewAtIndex:(NSInteger)index {
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ContentCardView" owner:self options:nil];
    ContentCardView* tmp = [nib objectAtIndex:0];
    
    tmp.queryView.delegate = datasource;
    tmp.queryView.dataSource = datasource;
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 2 * HEADER_MARGIN_TO_SCREEN;
    CGSize size = CGSizeMake(width, [QueryHeader preferredHeight] + [QueryCell preferredHeightWithDescription:@"Any Word"]);
#ifdef DEBUG_NEW_HOME_PAGE
    tmp.frame = CGRectMake(HEADER_MARGIN_TO_SCREEN,  HEADER_MARGIN_TO_SCREEN - 4, size.width, size.height);
#else
    tmp.frame = CGRectMake(HEADER_MARGIN_TO_SCREEN + index * 4, CONTENT_START_POINT + index * (size.height + MARGIN_BETWEEN_CARD), size.width - index * 8, size.height);
#endif
   
    [tmp layoutSubviews];
    return tmp;
}

- (NSArray*)createContentCardView {
  
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (queryViewLst == nil) {
        queryViewLst = [[NSMutableArray alloc]initWithCapacity:3];
    }
   
    for (int index = 0; index < 3; ++index) {

        ContentCardView* tmp = [self createOneContentCardViewAtIndex:index];
        
        [self.view addSubview:tmp];
        [queryViewLst addObject:tmp];
    }
    
    [self.view bringSubviewToFront:queryViewLst.firstObject];
    [self.view bringSubviewToFront:bkView];
    
    return queryViewLst;
}

#ifndef DEBUG_NEW_HOME_PAGE
- (void)nextCard {
  
    if ([_delegate count] == _current_index + 1) {
        UIAlertView* view = [[UIAlertView alloc]initWithTitle:@"Last Card" message:@"This is the last card of content" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [view show];
        return;
    }
 
    for (ContentCardView* iter in queryViewLst) {
        iter.queryView.layer.hidden = NO;
    }
    
    ContentCardView* tmp = [queryViewLst lastObject];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 2 * HEADER_MARGIN_TO_SCREEN;
    CGSize size = CGSizeMake(width, [QueryHeader preferredHeight] + [QueryCell preferredHeightWithDescription:@"Any Word"]);
    tmp.frame = CGRectMake(HEADER_MARGIN_TO_SCREEN + 2 * 4, CONTENT_START_POINT + 2 * (size.height + MARGIN_BETWEEN_CARD), size.width - 2 * 8, size.height);
    tmp.queryView.tag = 2 + _current_index;
    
    if (tmp.queryView.tag == [_delegate count]) {
        tmp.hidden = YES;
    } else {
        [tmp layoutSubviews];
        [tmp.queryView reloadData];
        tmp.hidden = NO;
    }

    isAnimation = YES;
    static const CGFloat kAnimationDuration = 0.50f; // in seconds
    [INTUAnimationEngine animateWithDuration:kAnimationDuration
                                       delay:0.0
                                      easing:INTUEaseInOutQuadratic
                                     options:INTUAnimationOptionNone
                                  animations:^(CGFloat progress) {
                                      for (int index = -1; index < 2; ++index) {
                                          ((UIView*)[queryViewLst objectAtIndex:index + 1]).frame = INTUInterpolateCGRect(((UIView*)[queryViewLst objectAtIndex:index + 1]).frame, CGRectMake(HEADER_MARGIN_TO_SCREEN + abs(index) * 4, CONTENT_START_POINT + index * (size.height + MARGIN_BETWEEN_CARD) - (index == -1 ? 28 : 0), size.width - abs(index) * 8, size.height), progress);
                                          [(UIView*)[queryViewLst objectAtIndex:index + 1] layoutSubviews];
//                                          UIView* qv = ((ContentCardView*)[queryViewLst objectAtIndex:index + 1]).queryView;
//                                          CALayer* shadow = ((ContentCardView*)[queryViewLst objectAtIndex:index + 1]).shadow;
//                                          shadow.frame = INTUInterpolateCGRect(shadow.frame, CGRectMake(-4, -4, qv.frame.size.width + 8, qv.frame.size.height + 8), progress);
                                      }
                                  }
                                  completion:^(BOOL finished) {
                                      // NOTE: When passing INTUAnimationOptionRepeat, this completion block is NOT executed at the end of each cycle. It will only run if the animation is canceled.
                                      NSLog(@"%@", finished ? @"Animation Completed" : @"Animation Canceled");
                                      // self.animationID = NSNotFound;
                                      _isLoading = NO;

                                      UIView* head = [queryViewLst firstObject];
                                      [queryViewLst removeObject:head];
                                      [queryViewLst addObject:head];
                                      _current_index += 1;
                                      head.hidden = YES;
                                      isAnimation = NO;

                                      [self.view bringSubviewToFront:queryViewLst.firstObject];
                                      [self.view bringSubviewToFront:bkView];
                                  }];
    
}

- (void)previousCard {
    if (_current_index == 0) {
        UIAlertView* view = [[UIAlertView alloc]initWithTitle:@"First Card" message:@"This is the first card of content" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [view show];
        return;
    }

    for (ContentCardView* iter in queryViewLst) {
        iter.queryView.layer.hidden = NO;
    }
    
    ContentCardView* tmp = [queryViewLst lastObject];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 2 * HEADER_MARGIN_TO_SCREEN;
    CGSize size = CGSizeMake(width, [QueryHeader preferredHeight] + [QueryCell preferredHeightWithDescription:@"Any Word"]);
    tmp.frame = CGRectMake(HEADER_MARGIN_TO_SCREEN + 2 * 4, CONTENT_START_POINT + -1 * (size.height + MARGIN_BETWEEN_CARD), size.width - 2 * 8, size.height);
    tmp.queryView.tag = -1 + _current_index;
    [tmp layoutSubviews];
    [tmp.queryView reloadData];
    tmp.hidden = NO;

    isAnimation = YES;
    [queryViewLst removeObject:tmp];
    [queryViewLst insertObject:tmp atIndex:0];
    
    static const CGFloat kAnimationDuration = 0.50f; // in seconds
    [INTUAnimationEngine animateWithDuration:kAnimationDuration
                                       delay:0.0
                                      easing:INTUEaseInOutQuadratic
                                     options:INTUAnimationOptionNone
                                  animations:^(CGFloat progress) {
                                      for (int index = 0; index < 3; ++index) {
                                          ((UIView*)[queryViewLst objectAtIndex:index]).frame = INTUInterpolateCGRect(((UIView*)[queryViewLst objectAtIndex:index]).frame, CGRectMake(HEADER_MARGIN_TO_SCREEN + abs(index) * 4, CONTENT_START_POINT + index * (size.height + MARGIN_BETWEEN_CARD), size.width - abs(index) * 8, size.height), progress);
                                          [(UIView*)[queryViewLst objectAtIndex:index] layoutSubviews];
                                      }
                                  }
                                  completion:^(BOOL finished) {
                                      // NOTE: When passing INTUAnimationOptionRepeat, this completion block is NOT executed at the end of each cycle. It will only run if the animation is canceled.
                                      NSLog(@"%@", finished ? @"Animation Completed" : @"Animation Canceled");
                                      // self.animationID = NSNotFound;
                                      _isLoading = NO;
                                      
                                      _current_index -= 1;
                                      UIView* tmp = [queryViewLst lastObject];
                                      tmp.hidden = YES;
                                      isAnimation = NO;

                                      [self.view bringSubviewToFront:queryViewLst.firstObject];
                                      [self.view bringSubviewToFront:bkView];
                                  }];
}

- (void)handlePan:(UIPanGestureRecognizer*)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        point = [gesture translationInView:self.view];
        
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        CGPoint newPoint = [gesture translationInView:self.view];
    
        if (!isAnimation) {
            if (newPoint.y - point.y > PAN_HANDLE_CHECK_POINT) {
                [self previousCard];
            } else if (point.y - newPoint.y > PAN_HANDLE_CHECK_POINT) {
                [self nextCard];
            }
        }
        
        point = CGPointMake(-1, -1);
        
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
    }
}
#endif

- (NSInteger)getShowingIndex:(UITableView*)tableView {
    return _current_index;
}

- (void)didPopViewControllerBtn {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)layoutTableViews {
    CGFloat screen_width = [UIScreen mainScreen].bounds.size.width;
//    bkView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, 20)];
    bkView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, 64)];
//    bkView.backgroundColor = [UIColor lightGrayColor];
    bkView.backgroundColor = [UIColor whiteColor];
    
    CALayer* line = [CALayer layer];
    line.borderWidth = 1.f;
    line.borderColor = [UIColor colorWithRed:0.5922 green:0.5922 blue:0.5922 alpha:0.25].CGColor;
    line.frame = CGRectMake(0, 64, screen_width, 1);
    [bkView.layer addSublayer:line];
    
    [self.view addSubview:bkView];
    [self.view bringSubviewToFront:bkView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController setNavigationBarHidden:!_isPushed animated:YES];
    
    if (_delegate == nil) {
        self.delegate = [[MainHomeViewDataDelegate alloc]init];
    }
    
    if ([_delegate isKindOfClass:[MainHomeViewDataDelegate class]]) {
        
    } else {
        [_delegate currentSelectIndexWithBlock:^(NSInteger index) {
//            [_queryView setContentOffset:CGPointMake(0, index * (44 + [QueryCell preferredHeightWithDescription:@"Any Words"]))];
        }];
        self.navigationController.navigationBar.hidden = NO;
    }
}

- (void)back2TopHandler:(UITapGestureRecognizer*)gesture {
//    [_queryView setContentOffset:CGPointZero animated:YES];
}

#pragma mark -- scroll refresh
- (void)dealloc {
//    ((UIScrollView*)_queryView).delegate = nil;
    BWStatusBarOverlay* tmp = [BWStatusBarOverlay shared];
    [tmp removeGestureRecognizer:tap];
}

//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    
//    if (!_isHandleScrolling) {
//        return;
//    }
//    
//    // 假设偏移表格高度的20%进行刷新
//    if (!_isLoading) { // 判断是否处于刷新状态，刷新中就不执行
//        // 取内容的高度：
//        // 如果内容高度大于UITableView高度，就取TableView高度
//        // 如果内容高度小于UITableView高度，就取内容的实际高度
//        float height = scrollView.contentSize.height > _queryView.frame.size.height ?_queryView.frame.size.height : scrollView.contentSize.height;
//       
//        VIEW_BOUNTDS
//        if (scrollView.contentOffset.y > [QueryCell preferredHeightWithDescription:@""] * 0.4) {
//            [self.navigationController setNavigationBarHidden:YES animated:YES];
//            
//            if (offset_y != 0 && offset_y - scrollView.contentOffset.y > 30) {
//                showBack2Top = YES;
//            }
//            
//            BWStatusBarOverlay* tmp = [BWStatusBarOverlay shared];
//            if (tmp.isHidden && showBack2Top) {
//                [[BWStatusBarOverlay shared] showSuccessWithMessage:@"back to top" duration:BACK_TO_TOP_TIME animated:YES];
//                showBack2Top = NO;
//            }
//            _queryView.frame = QUERY_VIEW_SCROLL;
//        } else {
//            [self.navigationController setNavigationBarHidden:NO animated:YES];
//            showBack2Top = YES;
//            BWStatusBarOverlay* tmp = [BWStatusBarOverlay shared];
//            if (!tmp.isHidden) {
//                [BWStatusBarOverlay dismissAnimated:YES];
//            }
//            _queryView.frame = QUERY_VIEW_START;
//        }
//       
//        offset_y = scrollView.contentOffset.y;
//        
//        if ((height - scrollView.contentSize.height + scrollView.contentOffset.y) / height > 0.2) { // 调用上拉刷新方
//            CGRect rc = _queryView.frame;
//            rc.origin.y = rc.origin.y - 44;
//            [_queryView setFrame:rc];
////            [_qm appendQueryDataByUser:_current_user_id withToken:_current_auth_token andBeginIndex:_qm.querydata.count];
////            [_qm appendQueryDataByUser:_current_user_id withToken:_current_auth_token andBeginIndex:_qm.querydata.count];
//            [_delegate appendData:nil];
//            rc.origin.y = rc.origin.y + 44;
//            [_queryView setFrame:rc];
//            [_queryView reloadData];
//            return;
//            
//        } else if (- scrollView.contentOffset.y / _queryView.frame.size.height > 0.2) { // 调用下拉刷新方法
//            _isLoading = YES;
//            __block CGRect rc = _queryView.frame;
//            rc.origin.y = rc.origin.y + 44;
//            [_queryView setFrame:rc];
////            [_qm refreshQueryDataByUser:_current_user_id withToken:_current_auth_token withFinishBlock:^{
//            [_delegate collectData:^(NSArray *data) {
//                CGRect tmp = rc;
//                rc.origin.y = rc.origin.y - 44;
////                [_queryView setFrame:rc];
//                [_queryView reloadData];
//                [self moveViewFromRect:tmp toRect:rc];
//            }];
//
//            return;
//        }
//        
//        // move and change
//    }
//
//}

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
- (void)didSelectLikeBtn:(id)content {

}

- (void)didSelectShareBtn:(id)content {
    
}

- (void)didSelectCommentsBtn:(id)content {
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
    [delegate.pm postLikeToServiceWithPostID:cur.content_post_id withFinishBlock:^(BOOL success, QueryContent *content) {
        if (success) {
            NSLog(@"like post success");
            NSString* msg = @"like post success";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:msg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
            [alert show];
        }
    }];
}

- (void)didSelectNotLikeBtn:(id)content {
    
}

- (void)didSelectScreenImg:(id)content {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PersonalCentreTmpViewController* pc = [storyboard instantiateViewControllerWithIdentifier:@"PersonalCenter"];
    PersonalCentreOthersDelegate* delegate = [[PersonalCentreOthersDelegate alloc]init];
    pc.current_delegate = delegate;
    pc.owner_id = ((QueryContent*)content).owner_id;
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController pushViewController:pc animated:YES];
}

#pragma mark -- search controller
- (void)didSelectSearchBtn:(id)content {
    [self performSegueWithIdentifier:@"search" sender:nil];
}

#pragma mark -- chat group controller
- (void)didSelectChatGroupBtn {
    [self performSegueWithIdentifier:@"ChatGroupSegue" sender:nil];
}

#pragma mark -- enter chat group
- (void)pushControllerWithTarget:(Targets*)target {
    [self performSegueWithIdentifier:@"ChatSegue" sender:target];
}

#pragma mark -- table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return _qm.querydata.count;
    return [_delegate count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    
    
    CGFloat h = [QueryHeader preferredHeight] + [QueryCell preferredHeightWithDescription:@"Any Word"];
    return h + HEADER_MARGIN_TO_SCREEN + 2;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"defatult"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"default"];
    }
    
    ContentCardView* tmp = [cell viewWithTag:-101];
    if (tmp == nil) {
        tmp = [self createOneContentCardViewAtIndex:0];
        cell.backgroundColor = [UIColor colorWithRed:0.9529 green:0.9529 blue:0.9529 alpha:1.f];
        cell.clipsToBounds = YES;
        [cell addSubview:tmp];
    }
   
    tmp.queryView.tag = indexPath.row;
    
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (queryView.mj_header.state == MJRefreshStateRefreshing || queryView.mj_footer.state == MJRefreshStateRefreshing) {
        return;
    }
    
//    CGFloat step_length = [QueryHeader preferredHeight] + [QueryCell preferredHeightWithDescription:@"Any Word"] + HEADER_MARGIN_TO_SCREEN + 2;
//    CGFloat height = [UIScreen mainScreen].bounds.size.height - 64 - 49;
//    NSInteger step = (scrollView.contentOffset.y + height) / step_length;
//    [scrollView setContentOffset:CGPointMake(0, step_length * (step - 1)) animated:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (queryView.mj_header.state == MJRefreshStateRefreshing || queryView.mj_footer.state == MJRefreshStateRefreshing) {
        return;
    }

//    CGFloat step_length = [QueryHeader preferredHeight] + [QueryCell preferredHeightWithDescription:@"Any Word"] + HEADER_MARGIN_TO_SCREEN + 2;
//    CGFloat height = [UIScreen mainScreen].bounds.size.height - 64 - 49;
//    NSInteger step = (scrollView.contentOffset.y + height) / step_length;
//    [scrollView setContentOffset:CGPointMake(0, step_length * (step - 1)) animated:YES];
}
@end
