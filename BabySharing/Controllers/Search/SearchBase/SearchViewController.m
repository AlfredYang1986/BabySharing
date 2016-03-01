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

#import <objc/runtime.h>

@interface SearchViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet DongDaSearchBar2 *searchBar;
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

@synthesize isNeedAsyncData = _isNeedAsyncData;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
//    role_tag = [[SearchRoleTagDelegate alloc]init];
    
    _queryView.delegate = _delegate;
    _queryView.dataSource = _delegate;
    _searchBar.delegate = _delegate;
    _searchBar.showsCancelButton = YES;
 
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
    _searchBar.placeholder = [_delegate getSearchPlaceHolder];// @"搜索角色标签";
    [_searchBar setPostLayoutSize:CGSizeMake(61, 30)];
    
    _bkView.backgroundColor =  [UIColor colorWithWhite:0.1098 alpha:1.f];
    [_delegate collectData];
   
//    Class cls = [_delegate class];
//    IMP imp = class_getMethodImplementation(cls, @selector(getSearchPlaceHolder));
//    if (imp) {
//        _searchBar.placeholder = imp();
//    }
//    Method m = class_getClassMethod(cls, @selector(getSearchPlaceHolder));
    
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
    
    _queryView.backgroundColor = [UIColor colorWithRed:0.2039 green:0.2078 blue:0.2314 alpha:1.f];
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
@end
