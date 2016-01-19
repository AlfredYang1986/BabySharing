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
//    _bkView.backgroundColor = [UIColor colorWithRed:0.3126 green:0.7529 blue:0.6941 alpha:1.f];
    _bkView.backgroundColor = [UIColor colorWithWhite:0.f alpha:1.f];

    _searchBar.delegate = _delegate;
    _queryView.dataSource = _delegate;
    _queryView.delegate = _delegate;
    
    _searchBar.showsCancelButton = YES;
    _searchBar.placeholder = @"搜索角色标签";
    [_searchBar becomeFirstResponder];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    UIImageView* iv = [[UIImageView alloc] initWithImage:[SearchAddViewController imageWithColor:[UIColor blackColor] size:CGSizeMake(width + 10, 44)]];
    [_searchBar insertSubview:iv atIndex:1];
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
    
    _queryView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _queryView.backgroundColor = [UIColor blackColor];
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
