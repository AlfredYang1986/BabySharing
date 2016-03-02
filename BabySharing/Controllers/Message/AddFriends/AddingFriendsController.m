//
//  AddingFriendsController.m
//  BabySharing
//
//  Created by Alfred Yang on 4/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "AddingFriendsController.h"
#import "AddressBookDelegate.h"
#import "AddingFriendsProtocol.h"
#import "WeiboFriendsDelegate.h"

#import "DongDaSearchBar.h"
#import "SearchSegView2.h"
#import "MessageFriendsCell.h"
#import "AppDelegate.h"

#import "AppDelegate.h"
#import "LoginModel.h"

@interface AddingFriendsController () <UISearchBarDelegate, AsyncDelegateProtocol, SearchSegViewDelegate, DongDaSearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *queryView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
//@property (weak, nonatomic) IBOutlet DongDaSearchBar* searchBar;
//@property (weak, nonatomic) IBOutlet UISegmentedControl *seg;
@property (weak, nonatomic) IBOutlet SearchSegView2 *seg;
@property (weak, nonatomic, setter=setCurrentDelegate:) id<UITableViewDataSource, UITableViewDelegate, AddingFriendsProtocol> current_delegate;

@end

@implementation AddingFriendsController {
    AddressBookDelegate* ab;
//    WeiboFriendsDelegate* wb;
}

@synthesize queryView = _queryView;
@synthesize searchBar = _searchBar;
@synthesize seg = _seg;

@synthesize current_delegate = _current_delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    
    [_seg addItemWithImg:[UIImage imageNamed:[resourceBundle pathForResource:@"friend_address_book" ofType:@"png"]] andSelectImage:[UIImage imageNamed:[resourceBundle pathForResource:@"friend_address_book_selected" ofType:@"png"]] andTitle:@"通讯录"];
    [_seg addItemWithImg:[UIImage imageNamed:[resourceBundle pathForResource:@"friend_wechat" ofType:@"png"]] andSelectImage:[UIImage imageNamed:[resourceBundle pathForResource:@"friend_wechat" ofType:@"png"]] andTitle:@"微信"];
    [_seg addItemWithImg:[UIImage imageNamed:[resourceBundle pathForResource:@"friend_qq" ofType:@"png"]] andSelectImage:[UIImage imageNamed:[resourceBundle pathForResource:@"friend_qq" ofType:@"png"]] andTitle:@"QQ"];
    _seg.isLayerHidden = YES;
    _seg.margin_between_items = 0.10 * [UIScreen mainScreen].bounds.size.width;
    _seg.selectedIndex = 0;
    _seg.delegate = self;
    
    ab = [[AddressBookDelegate alloc]init];
//    if ([ab isDelegateReady]) {
//        self.current_delegate = ab;
//    }
    
//    wb = [[WeiboFriendsDelegate alloc]init];
    
    UIButton* barBtn = [[UIButton alloc]initWithFrame:CGRectMake(10.5, 32, 25, 25)];
    NSString* filepath = [resourceBundle pathForResource:@"dongda_back" ofType:@"png"];
    CALayer * layer = [CALayer layer];
    layer.contents = (id)[UIImage imageNamed:filepath].CGImage;
    layer.frame = CGRectMake(-10, 0, 20, 20);
    [barBtn.layer addSublayer:layer];
    [barBtn addTarget:self action:@selector(didPopControllerSelected) forControlEvents:UIControlEventTouchDown];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:barBtn];
    
    UILabel* label = [[UILabel alloc]init];
    label.text = @"添加好友";
    label.textColor = [UIColor lightGrayColor];
    [label sizeToFit];
    
    self.navigationItem.titleView = label;
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.9490 alpha:1.f];
   
    _searchBar.delegate = self;
    _searchBar.placeholder = @"搜索好友";
    _searchBar.backgroundColor = [UIColor clearColor];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    UIImageView* iv = [[UIImageView alloc] initWithImage:[self imageWithColor:[UIColor whiteColor] size:CGSizeMake(width + 10, 44)]];
    [_searchBar insertSubview:iv atIndex:1];
    for (UIView* v in _searchBar.subviews.firstObject.subviews) {
        if ( [v isKindOfClass: [UITextField class]] ) {
            UITextField *tf = (UITextField *)v;
            tf.backgroundColor = [UIColor colorWithWhite:0.9490 alpha:1.f];
            tf.borderStyle = UITextBorderStyleRoundedRect;
            tf.clearButtonMode = UITextFieldViewModeWhileEditing;
        } else if ([v isKindOfClass:[UIButton class]]) {
            UIButton* cancel_btn = (UIButton*)v;
            [cancel_btn setTitleColor:[UIColor colorWithWhite:0.4667 alpha:1.f] forState:UIControlStateNormal];
            [cancel_btn setTitleColor:[UIColor colorWithWhite:0.4667 alpha:1.f] forState:UIControlStateDisabled];
        }
    }
    
    [_queryView registerNib:[UINib nibWithNibName:@"MessageFriendsCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"friend cell"];
    _queryView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

//取消searchbar背景色
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didPopControllerSelected {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"searchFriends"]) {
    
    }
}

- (void)setCurrentDelegate:(id<UITableViewDataSource,UITableViewDelegate,AddingFriendsProtocol>)current_delegate {
    _current_delegate = current_delegate;
    _queryView.delegate = _current_delegate;
    _queryView.dataSource = _current_delegate;
}

- (void)asyncDelegateIsReady:(id<UITableViewDataSource, UITableViewDelegate, AddingFriendsProtocol>)delegate {
    if (_current_delegate == delegate) {
        [_queryView reloadData];
    }
}

#pragma mark -- search bar delegate
//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
//    [_current_delegate filterFriendsWithString:searchText];
//    [_queryView reloadData];
//}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [self performSegueWithIdentifier:@"searchFriends" sender:nil];
    return NO;
}

#pragma mark -- seg delegate
- (void)segValueChanged2:(SearchSegView2 *)seg {
    if (seg.selectedIndex == 2) {
        [seg setSegSelectedIndex:0];
        [[AppDelegate defaultAppDelegate].lm postContentOnQQzoneWithText:@"快来加入咚哒吧!!!" andImage:[UIImage imageNamed:[[NSBundle mainBundle] pathForResource:@"icon" ofType:@"png"]] type:ShareNews];
    } else if (seg.selectedIndex == 1) {
        [seg setSegSelectedIndex:0];
    } else if (seg.selectedIndex == 0) {
        AppDelegate* app = [UIApplication sharedApplication].delegate;
        [app.lm queryUserList:[ab getAllPhones] withProviderName:@"phone" andFinishBlock:^(BOOL success, NSArray *lst) {
            self.current_delegate = ab;
            [ab splitWithFriends:lst];
            [_queryView reloadData];
        }];
    }
}

- (void)cancelBtnSelected {
    
}

- (void)searchTextChanged:(NSString*)searchText {
    
}
@end
