//
//  SearchAddViewController.m
//  BabySharing
//
//  Created by Alfred Yang on 20/11/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import "SearchAddViewController.h"
#import "DongDaSearchBar2.h"
#import "Tools.h"

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
    [super viewDidLoad];
    _bkView.backgroundColor = [UIColor whiteColor];

    self.view.backgroundColor = [Tools colorWithRED:242 GREEN:242 BLUE:242 ALPHA:1.0];
    _searchBar.delegate = _delegate;
    _queryView.dataSource = _delegate;
    _queryView.delegate = _delegate;
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 1)];
    line1.backgroundColor = [Tools colorWithRED:155.0 GREEN:155.0 BLUE:155.0 ALPHA:0.15];
    [_queryView addSubview:line1];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 52, [UIScreen mainScreen].bounds.size.width + 20, 1)];
    line2.backgroundColor = [Tools colorWithRED:155.0 GREEN:155.0 BLUE:155.0 ALPHA:0.35];
    [_searchBar addSubview:line2];
    
    _searchBar.showsCancelButton = YES;
    _searchBar.placeholder = @"4-12个字节，限中英文、数字、表情";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:_searchBar.textField];
    [_searchBar becomeFirstResponder];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    [UIView performWithoutAnimation:^{
        _searchBar.bounds = CGRectMake(0, 0, width + 10, 53);
    }];
    _searchBar.sb_bg = [UIColor whiteColor];
    _searchBar.textField.backgroundColor = [UIColor colorWithWhite:0.9490 alpha:1.f];
    _searchBar.textField.borderStyle = UITextBorderStyleRoundedRect;
    _searchBar.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_searchBar.cancleBtn setTitleColor:[UIColor colorWithWhite:1.f alpha:1.f] forState:UIControlStateNormal];
    [_searchBar.cancleBtn setTitleColor:[UIColor colorWithWhite:1.f alpha:1.f] forState:UIControlStateDisabled];
    _searchBar.cancleBtn.backgroundColor = [UIColor colorWithRed:70.0 / 255.0 green:219.0 / 255.0 blue:202.0 / 255.0 alpha:1.f];
    _searchBar.cancleBtn.layer.cornerRadius = 5.f;
    [_searchBar.cancleBtn setTitle:@"添加" forState:UIControlStateNormal];
    _searchBar.cancleBtn.clipsToBounds = YES;
    _searchBar.cancleBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    
    
    [_searchBar setPostLayoutSize:CGSizeMake(61, 30)];
    
    _queryView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _queryView.backgroundColor = [UIColor whiteColor]; //[UIColor colorWithRed:0.2039 green:0.2078 blue:0.2314 alpha:1.f];
    
    UILabel* lb = [[UILabel alloc]init];
    lb.text = [_delegate getControllerTitle];
    lb.textColor = [Tools colorWithRED:74.0 GREEN:74.0 BLUE:74.0 ALPHA:1.0];
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
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)setAddingDelegate:(id<SearchDataCollectionProtocol>)delegate {
    _delegate = delegate;
    
    _searchBar.delegate = _delegate;
    _queryView.dataSource = _delegate;
    _queryView.delegate = _delegate;
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

- (NSString*)getUserInputString {
    return _searchBar.text;
}

- (void)textFieldChanged:(NSNotification *)noti {
    UITextField *textFile = (UITextField *)noti.object;
    NSString *toBeString = textFile.text;
    NSString *lang = textFile.textInputMode.primaryLanguage; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textFile markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textFile positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if ([Tools bityWithStr:textFile.text] > 12) {
                textFile.text = [Tools subStringWithByte:12 str:toBeString];
            }
        }
    } else {
        // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (toBeString.length > 12) {
            textFile.text = [Tools subStringWithByte:12 str:textFile.text];
        }
    }
}

- (void)keyboardHide {
    [_searchBar.textField resignFirstResponder];
}
@end
