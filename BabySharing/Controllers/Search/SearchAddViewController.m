//
//  SearchAddViewController.m
//  BabySharing
//
//  Created by Alfred Yang on 20/11/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import "SearchAddViewController.h"

@interface SearchAddViewController ()
@property (weak, nonatomic) IBOutlet UIView *bkView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *queryView;

@end

@implementation SearchAddViewController

@synthesize bkView = _bkView;
@synthesize searchBar = _searchBar;
@synthesize queryView = _queryView;

@synthesize delegate = _delegate;

- (void)viewDidLoad {
    _bkView.backgroundColor = [UIColor colorWithRed:0.3126 green:0.7529 blue:0.6941 alpha:1.f];

    _searchBar.delegate = _delegate;
    _queryView.dataSource = _delegate;
    _queryView.delegate = _delegate;
    
    _searchBar.showsCancelButton = YES;
    for (UIView* v in _searchBar.subviews)
    {
        if ( [v isKindOfClass: [UITextField class]] )
        {
            UITextField *tf = (UITextField *)v;
            tf.clearButtonMode = UITextFieldViewModeWhileEditing;
            break;
        }
    }
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
    return NO; //返回NO表示要显示，返回YES将hiden
}

- (void)needToReloadData {
    [_queryView reloadData];
}

- (NSString*)getUserInputString {
    return _searchBar.text;
}
@end
