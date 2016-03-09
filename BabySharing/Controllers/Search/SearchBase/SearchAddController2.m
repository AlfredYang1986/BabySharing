//
//  SearchAddController2.m
//  BabySharing
//
//  Created by Alfred Yang on 1/21/16.
//  Copyright © 2016 BM. All rights reserved.
//

#import "SearchAddController2.h"
#import "DongDaSearchBar2.h"
#import "AppDelegate.h"

@interface SearchAddController2 ()

@property (weak, nonatomic) IBOutlet UIView *bkView;
@property (weak, nonatomic) IBOutlet DongDaSearchBar2 *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *queryView;
@property (weak, nonatomic) LoginModel *loginModel;

@end

@implementation SearchAddController2

@synthesize bkView = _bkView;
@synthesize searchBar = _searchBar;
@synthesize queryView = _queryView;

@synthesize delegate = _delegate;

- (void)viewDidLoad {
    //    _bkView.backgroundColor = [UIColor colorWithRed:0.3126 green:0.7529 blue:0.6941 alpha:1.f];
    _bkView.backgroundColor = [UIColor colorWithWhite:0.1098 alpha:1.f];
    
    _searchBar.delegate = _delegate;
    _queryView.dataSource = _delegate;
    _queryView.delegate = _delegate;
    
    _searchBar.showsCancelButton = YES;
    _searchBar.placeholder = @"搜索角色标签";
    [_searchBar becomeFirstResponder];
    // 获取当前的用户id
    self.loginModel = [AppDelegate defaultAppDelegate].lm;
    
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    _searchBar.bounds = CGRectMake(0, 0, width + 10, 56);
    _searchBar.sb_bg = [UIColor colorWithWhite:0.1098 alpha:1.f];
    _searchBar.textField.backgroundColor = [UIColor colorWithWhite:0.9490 alpha:1.f];
    _searchBar.textField.borderStyle = UITextBorderStyleRoundedRect;
    _searchBar.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_searchBar.cancleBtn setTitleColor:[UIColor colorWithWhite:1.f alpha:1.f] forState:UIControlStateNormal];
    [_searchBar.cancleBtn setTitleColor:[UIColor colorWithWhite:1.f alpha:1.f] forState:UIControlStateDisabled];
    _searchBar.cancleBtn.backgroundColor = [UIColor colorWithRed:100.0 / 255.0 green:210.0 / 255.0 blue:210.0 / 255.0 alpha:1.f];
    _searchBar.cancleBtn.layer.cornerRadius = 5.f;
    _searchBar.cancleBtn.clipsToBounds = YES;
    _searchBar.cancleBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    
    [_searchBar setPostLayoutSize:CGSizeMake(61, 30)];
    
    _queryView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _queryView.backgroundColor = [UIColor colorWithRed:0.2039 green:0.2078 blue:0.2314 alpha:1.f];
    _queryView.backgroundColor = [UIColor whiteColor];
    
    UILabel* lb = [[UILabel alloc]init];
    lb.text = [_delegate getControllerTitle];
    lb.font = [UIFont systemFontOfSize:18.f];
    [lb sizeToFit];
    lb.textColor = [UIColor whiteColor];
    lb.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, 22 + lb.frame.size.height / 2);
    [_bkView addSubview:lb];
    
    UIButton* barBtn = [[UIButton alloc]initWithFrame:CGRectMake(14.5, 20.5, 30, 25)];
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    NSString* filepath = [resourceBundle pathForResource:@"dongda_back_light" ofType:@"png"];
    CALayer * layer = [CALayer layer];
    layer.contents = (id)[UIImage imageNamed:filepath].CGImage;
    
#define BACK_ICON_WIDTH         22
#define BACK_ICON_HEIGHT        BACK_ICON_WIDTH
    
    layer.frame = CGRectMake(0, 0, BACK_ICON_WIDTH, BACK_ICON_HEIGHT);
//    layer.position = CGPointMake(10, barBtn.frame.size.height / 2);
    [barBtn.layer addSublayer:layer];
    // [barBtn setBackgroundImage:[UIImage imageNamed:filepath] forState:UIControlStateNormal];
    // [barBtn setImage:[UIImage imageNamed:filepath] forState:UIControlStateNormal];
    [barBtn addTarget:self action:@selector(didPopViewControllerBtn) forControlEvents:UIControlEventTouchDown];
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:barBtn];
    [_bkView addSubview:barBtn];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_searchBar becomeFirstResponder];
}

- (void)didPopViewControllerBtn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setAddingDelegate:(id<SearchDataCollectionProtocol>)delegate {
    _delegate = delegate;
    
    _searchBar.delegate = _delegate;
    _queryView.dataSource = _delegate;
    _queryView.delegate = _delegate;
}

#pragma mark -- status bar color
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
    //UIStatusBarStyleDefault = 0 黑色文字，浅色背景时使用
    //UIStatusBarStyleLightContent = 1 白色文字，深色背景时使用
}

- (BOOL)prefersStatusBarHidden {
    return YES; //返回NO表示要显示，返回YES将hiden
}

- (void)needToReloadData {
    [_queryView reloadData];
}

- (NSString*)getUserInputString {
    return _searchBar.text;
}
@end
