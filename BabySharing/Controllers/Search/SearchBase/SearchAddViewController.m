//
//  SearchAddViewController.m
//  BabySharing
//
//  Created by Alfred Yang on 20/11/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import "SearchAddViewController.h"
#import "DongDaSearchBar2.h"

@interface SearchAddViewController ()
@property (weak, nonatomic) IBOutlet UIView *bkView;
@property (weak, nonatomic) IBOutlet DongDaSearchBar2 *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *queryView;

@end

@implementation SearchAddViewController

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
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    _searchBar.bounds = CGRectMake(0, 0, width + 10, 56);
    _searchBar.sb_bg = [UIColor colorWithWhite:0.1098 alpha:1.f];
    _searchBar.textField.backgroundColor = [UIColor colorWithWhite:0.9490 alpha:1.f];
    _searchBar.textField.borderStyle = UITextBorderStyleRoundedRect;
    _searchBar.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_searchBar.cancleBtn setTitleColor:[UIColor colorWithWhite:1.f alpha:1.f] forState:UIControlStateNormal];
    [_searchBar.cancleBtn setTitleColor:[UIColor colorWithWhite:1.f alpha:1.f] forState:UIControlStateDisabled];
    _searchBar.cancleBtn.backgroundColor = [UIColor colorWithRed:0.9686 green:0.7294 blue:0.1961 alpha:1.f];
    _searchBar.cancleBtn.layer.cornerRadius = 5.f;
    _searchBar.cancleBtn.clipsToBounds = YES;
    _searchBar.cancleBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    
    [_searchBar setPostLayoutSize:CGSizeMake(61, 30)];
    
    _queryView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _queryView.backgroundColor = [UIColor colorWithRed:0.2039 green:0.2078 blue:0.2314 alpha:1.f];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_searchBar becomeFirstResponder];
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
