//
//  SearchViewController.m
//  BabySharing
//
//  Created by Alfred Yang on 20/11/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchRoleTagDelegate.h"

@interface SearchViewController ()
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *queryView;
@property (weak, nonatomic) IBOutlet UIView *bkView;

@end

@implementation SearchViewController {
    SearchRoleTagDelegate* role_tag;
}

@synthesize searchBar = _searchBar;
@synthesize queryView = _queryView;
@synthesize bkView = _bkView;

@synthesize delegate = _delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
//    role_tag = [[SearchRoleTagDelegate alloc]init];
    
    _queryView.delegate = _delegate;
    _queryView.dataSource = _delegate;
    _searchBar.delegate = _delegate;
//    _searchBar.showsCancelButton = YES;
    for (UIView* v in _searchBar.subviews)
    {
        if ( [v isKindOfClass: [UITextField class]] )
        {
            UITextField *tf = (UITextField *)v;
            tf.clearButtonMode = UITextFieldViewModeWhileEditing;
            break;
        }
    }
    _bkView.backgroundColor =  [UIColor colorWithRed:0.3126 green:0.7529 blue:0.6941 alpha:1.f];
    
    [_delegate collectData];
    UILabel* lb = [[UILabel alloc]init];
    lb.text = [_delegate getControllerTitle];
    [lb sizeToFit];
    lb.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = lb;
    
    UIButton* barBtn = [[UIButton alloc]initWithFrame:CGRectMake(13, 32, 30, 25)];
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    NSString* filepath = [resourceBundle pathForResource:@"Previous_simple" ofType:@"png"];
    CALayer * layer = [CALayer layer];
    layer.contents = (id)[UIImage imageNamed:filepath].CGImage;
    layer.frame = CGRectMake(0, 0, 13, 20);
    layer.position = CGPointMake(10, barBtn.frame.size.height / 2);
    [barBtn.layer addSublayer:layer];
    // [barBtn setBackgroundImage:[UIImage imageNamed:filepath] forState:UIControlStateNormal];
    // [barBtn setImage:[UIImage imageNamed:filepath] forState:UIControlStateNormal];
    [barBtn addTarget:self action:@selector(didPopViewControllerBtn) forControlEvents:UIControlEventTouchDown];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:barBtn];
}

- (void)didPopViewControllerBtn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    [_searchBar becomeFirstResponder];
//}

- (void)setDataDelegate:(id<SearchDataCollectionProtocol>)protocol {
    _delegate = protocol;
    
    _queryView.delegate = _delegate;
    _queryView.dataSource = _delegate;
    _searchBar.delegate = _delegate;
}

#pragma mark -- status bar color
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
    //UIStatusBarStyleDefault = 0 黑色文字，浅色背景时使用
    //UIStatusBarStyleLightContent = 1 白色文字，深色背景时使用
}

- (BOOL)prefersStatusBarHidden {
    return NO; //返回NO表示要显示，返回YES将hiden
}

- (void)needToReloadData {
    [_queryView reloadData];
}
@end
