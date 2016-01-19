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

@interface SearchViewController () <UITextFieldDelegate>
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
    _searchBar.showsCancelButton = YES;
  
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    UIImageView* iv = [[UIImageView alloc] initWithImage:[SearchViewController imageWithColor:[UIColor blackColor] size:CGSizeMake(width + 10, 44)]];
    [_searchBar insertSubview:iv atIndex:1];
    _searchBar.placeholder = @"搜索角色标签";
    for (UIView* v in _searchBar.subviews.firstObject.subviews) {
        if ( [v isKindOfClass: [UITextField class]] ) {
            UITextField *tf = (UITextField *)v;
            tf.backgroundColor = [UIColor colorWithWhite:0.9490 alpha:1.f];
            tf.borderStyle = UITextBorderStyleRoundedRect;
            tf.clearButtonMode = UITextFieldViewModeWhileEditing;
        } else if ([v isKindOfClass:[UIButton class]]) {
            UIButton* cancel_btn = (UIButton*)v;
            //            [cancel_btn setTitle:@"test" forState:UIControlStateNormal];
            [cancel_btn setTitleColor:[UIColor colorWithWhite:0.4667 alpha:1.f] forState:UIControlStateNormal];
            [cancel_btn setTitleColor:[UIColor colorWithWhite:0.4667 alpha:1.f] forState:UIControlStateDisabled];
            cancel_btn.backgroundColor = [UIColor orangeColor];
            cancel_btn.layer.cornerRadius = 4.f;
            cancel_btn.clipsToBounds = YES;
            cancel_btn.titleLabel.font = [UIFont systemFontOfSize:14.f];
        }
        //        else if ([v isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
        //            v.backgroundColor = [UIColor whiteColor];
        //        }
    }
    _bkView.backgroundColor =  [UIColor colorWithWhite:0.f alpha:1.f];
    
    [_delegate collectData];
    UILabel* lb = [[UILabel alloc]init];
    lb.text = [_delegate getControllerTitle];
    [lb sizeToFit];
    lb.textColor = [UIColor whiteColor];
//    self.navigationItem.titleView = lb;
    lb.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, 20 + 44 / 2);
    [_bkView addSubview:lb];
    
    UIButton* barBtn = [[UIButton alloc]initWithFrame:CGRectMake(13, 32, 30, 25)];
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    NSString* filepath = [resourceBundle pathForResource:@"dongda_back" ofType:@"png"];
    CALayer * layer = [CALayer layer];
    layer.contents = (id)[UIImage imageNamed:filepath].CGImage;
    layer.frame = CGRectMake(0, 0, 25, 25);
//    layer.position = CGPointMake(10, barBtn.frame.size.height / 2);
    [barBtn.layer addSublayer:layer];
    // [barBtn setBackgroundImage:[UIImage imageNamed:filepath] forState:UIControlStateNormal];
    // [barBtn setImage:[UIImage imageNamed:filepath] forState:UIControlStateNormal];
    [barBtn addTarget:self action:@selector(didPopViewControllerBtn) forControlEvents:UIControlEventTouchDown];
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:barBtn];
    [_bkView addSubview:barBtn];
    
    _queryView.backgroundColor = [UIColor blackColor];
    _queryView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_queryView registerClass:[FoundHotTagsCell class] forCellReuseIdentifier:@"hot role tags"];
    [_queryView registerNib:[UINib nibWithNibName:@"FoundSearchHeader" bundle:[NSBundle mainBundle]] forHeaderFooterViewReuseIdentifier:@"hot role header"];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAlpha(context, 1.f);
    CGContextSetFillColorWithColor(context,color.CGColor);
    CGContextFillRect(context, rect);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
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
