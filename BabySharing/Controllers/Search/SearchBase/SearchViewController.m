//
//  SearchViewController.m
//  BabySharing
//
//  Created by Alfred Yang on 20/11/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchRoleTagDelegate.h"

#import "FoundHotTagsCell.h"
#import "DongDaSearchBar2.h"
#import "Tools.h"
#import <objc/runtime.h>

@interface SearchViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet DongDaSearchBar2 *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *queryView;
@property (weak, nonatomic) IBOutlet UIView *bkView;
@property (weak, nonatomic) IBOutlet UIView *line;

@end

@implementation SearchViewController {
    SearchRoleTagDelegate* role_tag;
}

@synthesize searchBar = _searchBar;
@synthesize queryView = _queryView;
@synthesize bkView = _bkView;

@synthesize delegate = _delegate;

@synthesize isNeedAsyncData = _isNeedAsyncData;
@synthesize isShowsSearchIcon = _isShowsSearchIcon;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.

    _queryView.delegate = _delegate;
    _queryView.dataSource = _delegate;
    _searchBar.delegate = _delegate;
    _searchBar.showsCancelButton = YES;

    self.line.backgroundColor = [Tools colorWithRED:155 GREEN:155 BLUE:155 ALPHA:0.5];
    [self.view bringSubviewToFront:self.line];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    _searchBar.bounds = CGRectMake(0, 0, width + 10, 53);
//    _searchBar.sb_bg = [UIColor colorWithWhite:0.1098 alpha:1.f];
    _searchBar.sb_bg = [UIColor whiteColor];
    _searchBar.textField.backgroundColor = [UIColor colorWithWhite:0.9490 alpha:1.f];
    _searchBar.textField.borderStyle = UITextBorderStyleRoundedRect;
    _searchBar.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_searchBar.cancleBtn setTitleColor:[UIColor colorWithWhite:1.f alpha:1.f] forState:UIControlStateNormal];
    [_searchBar.cancleBtn setTitleColor:[UIColor colorWithWhite:1.f alpha:1.f] forState:UIControlStateDisabled];
    [_searchBar.cancleBtn setTitle:@"添加" forState:UIControlStateNormal];
    [_searchBar.cancleBtn setTitle:@"添加" forState:UIControlStateDisabled];
    _searchBar.cancleBtn.backgroundColor = [UIColor colorWithRed:70.0/255.0 green:219.0 / 255.0 blue:202.0 / 255.0 alpha:1.f];
    _searchBar.cancleBtn.layer.cornerRadius = 5.f;
    _searchBar.cancleBtn.clipsToBounds = YES;
    _searchBar.cancleBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    _searchBar.placeholder = [_delegate getSearchPlaceHolder];// @"搜索角色标签";
    [_searchBar setPostLayoutSize:CGSizeMake(61, 30)];
    
    if (self.isShowsSearchIcon == NO) {
        _searchBar.showsSearchIcon = NO;
    }
    
    _bkView.backgroundColor =  [UIColor whiteColor];
    [_delegate collectData];
   
    
    UILabel* lb = [[UILabel alloc]init];
    lb.text = [_delegate getControllerTitle];
    lb.font = [UIFont systemFontOfSize:18.f];
    [lb sizeToFit];
    lb.textColor = [UIColor colorWithWhite:0.2902 alpha:1.f];
    lb.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, 24 + (44 - lb.frame.size.height) / 2 + lb.frame.size.height / 2);
    [_bkView addSubview:lb];
    
    UIButton* barBtn = [[UIButton alloc]initWithFrame:CGRectMake(14.5, 34.5, 30, 25)];
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    NSString* filepath = [resourceBundle pathForResource:@"dongda_back" ofType:@"png"];
    CALayer * layer = [CALayer layer];
    layer.contents = (id)[UIImage imageNamed:filepath].CGImage;
    
#define BACK_ICON_WIDTH         22
#define BACK_ICON_HEIGHT        BACK_ICON_WIDTH
    layer.frame = CGRectMake(0, 0, BACK_ICON_WIDTH, BACK_ICON_HEIGHT);
    [barBtn.layer addSublayer:layer];
    [barBtn addTarget:self action:@selector(didPopViewControllerBtn) forControlEvents:UIControlEventTouchDown];
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:barBtn];
    [_bkView addSubview:barBtn];
    
    _queryView.backgroundColor = [UIColor colorWithWhite:1.f alpha:1.f]; //[UIColor colorWithRed:0.2039 green:0.2078 blue:0.2314 alpha:1.f];
    _queryView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_queryView registerClass:[FoundHotTagsCell class] forCellReuseIdentifier:@"hot role tags"];
    [_queryView registerNib:[UINib nibWithNibName:@"FoundSearchHeader" bundle:[NSBundle mainBundle]] forHeaderFooterViewReuseIdentifier:@"hot role header"];
   
    if (_isNeedAsyncData) {
        [_delegate asyncQueryDataWithFinishCallback:^(BOOL success, NSArray *data) {
            if (success) {
                [_queryView reloadData];
            }
        }];
    }
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.9490 alpha:1.f];
    
    CALayer* line = [CALayer layer];
    line.borderColor = [UIColor colorWithWhite:0.5922 alpha:0.25].CGColor;
    line.borderWidth = 1.f;
    line.frame = CGRectMake(0, 117, width, 1);
    [self.view.layer addSublayer:line];
    
    CALayer* line_2 = [CALayer layer];
    line_2.borderColor = [UIColor colorWithWhite:0.5922 alpha:0.1].CGColor;
    line_2.borderWidth = 1.f;
    line_2.frame = CGRectMake(0, 127, width, 1);
    [self.view.layer addSublayer:line_2];
}

- (void)didPopViewControllerBtn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
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
    
    protocol.controller = self;
}

#pragma mark -- status bar color
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
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
