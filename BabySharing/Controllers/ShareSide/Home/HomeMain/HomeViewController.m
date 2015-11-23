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
#import "HomeViewTableCellDelelage.h"

#define HEADER_MARGIN_TO_SCREEN 8

#define VIEW_BOUNTDS        CGFloat screen_width = [UIScreen mainScreen].bounds.size.width; \
                            CGFloat screen_height = [UIScreen mainScreen].bounds.size.height; \
                            CGRect rc = CGRectMake(0, 0, screen_width, screen_height);


#define QUERY_VIEW_START    CGRectMake(HEADER_MARGIN_TO_SCREEN, -44, rc.size.width - 2 * HEADER_MARGIN_TO_SCREEN, rc.size.height)
#define QUERY_VIEW_SCROLL   CGRectMake(HEADER_MARGIN_TO_SCREEN, 0, rc.size.width - 2 * HEADER_MARGIN_TO_SCREEN, rc.size.height)
#define QUERY_VIEW_END      CGRectMake(-rc.size.width, -44, rc.size.width, rc.size.height)

#define BACK_TO_TOP_TIME    3.0

//@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource, QueryCellActionProtocol> //, HomeSegControlDelegate>
@interface HomeViewController () 
    
//@property (weak, nonatomic) IBOutlet UITableView *queryView;
@property (weak, nonatomic, readonly) NSString* current_user_id;
@property (weak, nonatomic, readonly) NSString* current_auth_token;
@property (weak, nonatomic, readonly) QueryModel* qm;
@property (nonatomic) BOOL isLoading;
@property (nonatomic) BOOL isHandleScrolling;

@property (weak, nonatomic) IBOutlet UITableView *foundView;
@end

@implementation HomeViewController {
    MoviePlayTrait* trait;
    
    UIView* bkView;
    UITapGestureRecognizer* tap;
    BOOL showBack2Top;
    CGFloat offset_y;
    
    HomeViewTableCellDelelage* datasource;
    
    NSMutableArray* queryViewLst;
}

//@synthesize queryView = _queryView;
@synthesize current_auth_token = _current_auth_token;
@synthesize current_user_id = _current_user_id;
@synthesize qm = _qm;
@synthesize isLoading = _isLoading;
@synthesize isHandleScrolling = _isHandleScrolling;
@synthesize delegate = _delegate;

//@synthesize foundView = _foundView;

@synthesize isPushed = _isPushed;
@synthesize nav_title = _nav_title;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.3126 green:0.7529 blue:0.6941 alpha:1.f]];

//    UINib* nib = [UINib nibWithNibName:@"QueryCell" bundle:[NSBundle mainBundle]];
//    [_queryView registerNib:nib forCellReuseIdentifier:@"query cell"];
//    [_queryView registerClass:[QueryHeader class] forHeaderFooterViewReuseIdentifier:@"query header"];
//    _queryView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    _current_user_id = delegate.lm.current_user_id;
    _current_auth_token = delegate.lm.current_auth_token;
    _qm = delegate.qm;
    
    _isLoading = NO;
    
    /**
     * set title view
     */
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    UILabel* title = [[UILabel alloc]init];
    title.textColor = [UIColor whiteColor];
    if (_nav_title == nil || [_nav_title isEqualToString:@""]) {
        _nav_title = @"咚嗒";
    }
    title.text = _nav_title;
    [title sizeToFit];
    self.navigationItem.titleView = title;
    
    trait = [[MoviePlayTrait alloc]init];

    [self layoutTableViews];
    
    BWStatusBarOverlay* tmp = [BWStatusBarOverlay shared];
    [tmp setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [tmp setBackgroundColor:[UIColor colorWithRed:0.3126 green:0.7529 blue:0.6941 alpha:1.f]];
    [tmp.textLabel setTextColor:[UIColor whiteColor]];
    showBack2Top = YES;
    
    tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back2TopHandler:)];
    [tmp addGestureRecognizer:tap];
 
    if (_isPushed) {
        UIButton* barBtn = [[UIButton alloc]initWithFrame:CGRectMake(13, 32, 30, 25)];
        NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
        NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
        NSString* filepath = [resourceBundle pathForResource:@"Previous_simple" ofType:@"png"];
        CALayer * layer = [CALayer layer];
        layer.contents = (id)[UIImage imageNamed:filepath].CGImage;
        layer.frame = CGRectMake(0, 0, 25, 25);
        layer.position = CGPointMake(10, barBtn.frame.size.height / 2);
        [barBtn.layer addSublayer:layer];
        [barBtn addTarget:self action:@selector(didPopViewControllerBtn) forControlEvents:UIControlEventTouchDown];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:barBtn];
    
    } else {
        NSString * filePath = [resourceBundle pathForResource:[NSString stringWithFormat:@"Cycle"] ofType:@"png"];
        UIImage *image = [UIImage imageNamed:filePath];

        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame =CGRectMake(0, 0, 25, 25);
        [btn setBackgroundImage:image forState:UIControlStateNormal];
        [btn addTarget: self action: @selector(didSelectChatGroupBtn) forControlEvents: UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    }
    
    self.view.backgroundColor = [UIColor grayColor];
    
    datasource = [[HomeViewTableCellDelelage alloc]init];
    datasource.trait = trait;
    datasource.controller = self;
    datasource.delegate = _delegate;
//    _queryView.dataSource = datasource;
//    _queryView.delegate = datasource;
    
    [self.navigationController setNavigationBarHidden:YES];
    [self createContentCardView];
    self.view.backgroundColor = [UIColor lightGrayColor];
}

- (void)setDataelegate:(id<HomeViewControllerDataDelegate>)delegate {
    _delegate = delegate;
    datasource.delegate = delegate;
}

#pragma mark -- table view for card content
- (NSArray*)createContentCardView {
  
    if (queryViewLst == nil) {
        queryViewLst = [[NSMutableArray alloc]initWithCapacity:3];
    }
    
//    for (int index = 0; index < 3; ++index) {
        UITableView* tmp = [[UITableView alloc]init];
        CGFloat width = [UIScreen mainScreen].bounds.size.width - 2 * HEADER_MARGIN_TO_SCREEN;
        CGSize size = CGSizeMake(width, [QueryHeader preferredHeight] + [QueryCell preferredHeightWithDescription:@"Any Word"]);
        tmp.frame = CGRectMake(8, 44, size.width, size.height);
        [self.view addSubview:tmp];
        [queryViewLst addObject:tmp];
    
        UINib* nib = [UINib nibWithNibName:@"QueryCell" bundle:[NSBundle mainBundle]];
        [tmp registerNib:nib forCellReuseIdentifier:@"query cell"];
        [tmp registerClass:[QueryHeader class] forHeaderFooterViewReuseIdentifier:@"query header"];
        tmp.separatorStyle = UITableViewCellSeparatorStyleNone;
    tmp.scrollEnabled = NO;
    
    tmp.delegate = datasource;
    tmp.dataSource = datasource;
    
    tmp.layer.cornerRadius = 8.f;
    tmp.clipsToBounds = YES;
//    }
    
    return queryViewLst;
}

- (void)didPopViewControllerBtn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)layoutTableViews {
    NSLog(@"layout the tableviews");
    VIEW_BOUNTDS
//    _queryView.frame = QUERY_VIEW_START;
    bkView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, 20)];
    bkView.backgroundColor = [UIColor colorWithRed:0.3126 green:0.7529 blue:0.6941 alpha:1.f];
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
    
    if (_delegate == nil) {
        self.delegate = [[MainHomeViewDataDelegate alloc]init];
    }
    
    if ([_delegate isKindOfClass:[MainHomeViewDataDelegate class]]) {
        _isHandleScrolling = YES;
        
    } else {
        [_delegate currentSelectIndexWithBlock:^(NSInteger index) {
//            [_queryView setContentOffset:CGPointMake(0, index * (44 + [QueryCell preferredHeightWithDescription:@"Any Words"]))];
        }];
        self.navigationController.navigationBar.hidden = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _isHandleScrolling = NO;
}

- (void)back2TopHandler:(UITapGestureRecognizer*)gesture {
//    [_queryView setContentOffset:CGPointZero animated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return NO; //返回NO表示要显示，返回YES将hiden
}

#pragma mark -- scroll refresh
- (void)dealloc {
//    ((UIScrollView*)_queryView).delegate = nil;
    BWStatusBarOverlay* tmp = [BWStatusBarOverlay shared];
    [tmp removeGestureRecognizer:tap];
}

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

- (void)moveViewFromRect:(CGRect)begin toRect:(CGRect)end {
    static const CGFloat kAnimationDuration = 0.30; // in seconds
    [INTUAnimationEngine animateWithDuration:kAnimationDuration
                                       delay:0.0
                                      easing:INTUEaseInOutQuadratic
                                     options:INTUAnimationOptionNone
                                  animations:^(CGFloat progress) {
//                                      _queryView.frame = INTUInterpolateCGRect(begin, end, progress);
                                      
                                      // NSLog(@"Progress: %.2f", progress);
                                  }
                                  completion:^(BOOL finished) {
                                      // NOTE: When passing INTUAnimationOptionRepeat, this completion block is NOT executed at the end of each cycle. It will only run if the animation is canceled.
                                      NSLog(@"%@", finished ? @"Animation Completed" : @"Animation Canceled");
                                      //                                                         self.animationID = NSNotFound;
                                      _isLoading = NO;
                                  }];
}


#pragma mark -- segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"HomeDetailSegue"]) {

        self.tabBarController.tabBar.hidden = YES;
    } else if ([segue.identifier isEqualToString:@"search"]) {
        
    }
}

#pragma mark -- QueryCellActionProtocol
- (void)didSelectLikeBtn:(id)content {
//    QueryContent* cur = (QueryContent*)content;
//    NSLog(@"like post id: %@", cur.content_post_id);
//    
//    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    [delegate.pm postLikeToServiceWithPostID:cur.content_post_id];
}

- (void)didSelectShareBtn:(id)content {
//    QueryContent* cur = (QueryContent*)content;
    
}

- (void)didSelectCommentsBtn:(id)content {
    [self performSegueWithIdentifier:@"HomeDetailSegue" sender:content];
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
@end
