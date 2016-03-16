//
//  FoundSearchController.m
//  BabySharing
//
//  Created by Alfred Yang on 8/12/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import "FoundSearchController.h"
#import "SearchSegView2.h"

#import "Define.h"
#import "AppDelegate.h"
#import "FoundSearchModel.h"

#import "HomeTagsController.h"
#import "OBShapedButton.h"

#import "SearchDefines.h"
#import "FoundSearchTagDeleage.h"
#import "FoundSearchRoleTagDelegate.h"

#import "FoundSearchProtocol.h"

#define SEARCH_BAR_HEIGHT               44
#define SEG_BAR_HEIGHT                  44
#define MARGIN                          8

#define CANCEL_BTN_WIDTH                70
#define CANCEL_BTN_WIDTH_WITH_MARGIN    70
#define STATUS_BAR_HEIGHT               20
#define TAB_BAR_HEIGHT                  49

@interface FoundSearchController () <UISearchBarDelegate, SearchSegViewDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *queryView;
@property (strong, nonatomic) SearchSegView2* seg;
@property (weak, nonatomic, setter=setCurrentTableViewDelegate:) id<UITableViewDataSource, UITableViewDelegate, FoundSearchProtocol> current_delegate;
@end

@implementation FoundSearchController {
    UIView* bkView;
    FoundSearchTagDeleage* tagDelegate;
    FoundSearchRoleTagDelegate* roleDelegate;
}

@synthesize searchBar = _searchBar;
@synthesize queryView = _queryView;
@synthesize seg = _seg;
@synthesize current_delegate = _current_delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _seg = [[SearchSegView2 alloc] initWithFrame:CGRectMake(0, 0, 100, 200)];
    [_seg addItemWithTitle:@"标签"];
    [_seg addItemWithTitle:@"角色"];
    _seg.delegate = self;
    _seg.selectedIndex = 0;
    _seg.margin_between_items = 0.15 * [UIScreen mainScreen].bounds.size.width;
    [self.view addSubview:_seg];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    _seg.frame = CGRectMake(0, 0, width, SEG_BAR_HEIGHT);
    _seg.backgroundColor = [UIColor whiteColor];
//    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, SEG_BAR_HEIGHT, width, 1)];
//    line.backgroundColor = [UIColor re];
//    [_seg addSubview:line];
    
    

    
//    _queryView.scrollEnabled = NO;
    _queryView.backgroundColor = [UIColor whiteColor]; //[UIColor colorWithWhite:0.9490 alpha:1.f];
    self.view.backgroundColor = [UIColor colorWithWhite:0.9490 alpha:1.f];
    
    [_queryView registerNib:[UINib nibWithNibName:@"FoundSearchHeader" bundle:[NSBundle mainBundle]] forHeaderFooterViewReuseIdentifier:@"found header"];
    [_queryView registerClass:[FoundHotTagsCell class] forCellReuseIdentifier:@"Hot Tag Cell"];
    [_queryView registerNib:[UINib nibWithNibName:@"FoundSearchResultCell" bundle:[NSBundle mainBundle]] forHeaderFooterViewReuseIdentifier:@"Search Result"];
    
    bkView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20)];
    //    bkView.backgroundColor = [UIColor colorWithRed:0.3126 green:0.7529 blue:0.6941 alpha:1.f];
    bkView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bkView];
    [self.view bringSubviewToFront:bkView];

    tagDelegate = [[FoundSearchTagDeleage alloc] init];
    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    tagDelegate.fm = app.fm;
    tagDelegate.controller = self;
    self.current_delegate = tagDelegate;
    [tagDelegate asyncQueryFoundSearchDataWithFinishBlock:^{
        [_queryView reloadData];
    }];
    
    roleDelegate = [[FoundSearchRoleTagDelegate alloc]init];
    roleDelegate.fm = app.fm;
    roleDelegate.controller = self;
    
    _searchBar.delegate = self;
    _searchBar.showsCancelButton = YES;
    _searchBar.showsCancelButton = YES;
    for(UIView *view in  [[[_searchBar subviews] objectAtIndex:0] subviews]) {
        if([view isKindOfClass:[NSClassFromString(@"UINavigationButton") class]]) {
            UIButton * cancel =(UIButton *)view;
            [cancel setTitle:@"取消" forState:UIControlStateNormal];
            [cancel  setTintColor:[UIColor blackColor]];
            [cancel.titleLabel setTextColor:[UIColor blackColor]];
        }
    }
    _searchBar.placeholder = @"搜索";
    _searchBar.backgroundColor = [UIColor clearColor];
    UIImageView* iv = [[UIImageView alloc] initWithImage:[self imageWithColor:[UIColor whiteColor] size:CGSizeMake(width, SEARCH_BAR_HEIGHT)]];
    [_searchBar insertSubview:iv atIndex:1];
    for (UIView* v in _searchBar.subviews.firstObject.subviews) {
        if ( [v isKindOfClass: [UITextField class]] ) {
            UITextField *tf = (UITextField *)v;
            tf.backgroundColor = [UIColor colorWithWhite:0.9490 alpha:1.f];
            tf.borderStyle = UITextBorderStyleRoundedRect;
            tf.clearButtonMode = UITextFieldViewModeWhileEditing;
        } else if ([v isKindOfClass:[UIButton class]]) {
            UIButton* cancel_btn = (UIButton*)v;
            cancel_btn.titleLabel.font = [UIFont systemFontOfSize:14.f];
            [cancel_btn setTitleColor:[UIColor colorWithWhite:0.3059 alpha:1.f] forState:UIControlStateNormal];
            [cancel_btn setTitleColor:[UIColor colorWithWhite:0.3059 alpha:1.f] forState:UIControlStateDisabled];
        }
    }
    
    CALayer* layer = [CALayer layer];
    layer.borderColor = UpLineColor.CGColor;
//    layer.borderColor = [UIColor redColor].CGColor;
    layer.borderWidth = 1.f;
    layer.frame = CGRectMake(0, STATUS_BAR_HEIGHT + SEARCH_BAR_HEIGHT + SEG_BAR_HEIGHT, [UIScreen mainScreen].bounds.size.width, 1);
    [self.view.layer addSublayer:layer];
   
    CALayer* line = [CALayer layer];
    line.borderColor = DownLineColor.CGColor;
//    line.borderColor = [UIColor redColor].CGColor;
    line.borderWidth = 1.f;
    line.frame = CGRectMake(0, STATUS_BAR_HEIGHT + SEARCH_BAR_HEIGHT + SEG_BAR_HEIGHT + MARGIN - 1, [UIScreen mainScreen].bounds.size.width, 1);
    [self.view.layer addSublayer:line];
    [_searchBar becomeFirstResponder];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    CGFloat offset_y = STATUS_BAR_HEIGHT;
 
    _searchBar.frame = CGRectMake(0, offset_y, width, SEARCH_BAR_HEIGHT);
    
    offset_y += SEARCH_BAR_HEIGHT;
    _seg.frame = CGRectMake(0, offset_y, width, SEG_BAR_HEIGHT);
    
    offset_y += SEG_BAR_HEIGHT + MARGIN;
    _queryView.frame = CGRectMake(0, offset_y, width, height - offset_y - TAB_BAR_HEIGHT);
}

- (void)cancelSearchSelected {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark -- text field delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [_current_delegate queryFoundTagSearchWithInput:_searchBar.text andFinishBlock:^(BOOL success, NSDictionary *preview) {
        [_queryView reloadData];
    }];
    
    [textField resignFirstResponder];
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self cancelSearchSelected];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [_current_delegate queryFoundTagSearchWithInput:_searchBar.text andFinishBlock:^(BOOL success, NSDictionary *preview) {
        [_queryView reloadData];
    }];
    
    [_searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchText isEqualToString:@""]) {
//        _fm.previewDic = nil;
        [_current_delegate resetCurrentSearchData];
        [_queryView reloadData];
    }
}

#pragma mark -- recommand tag delegate
- (void)recommandTagBtnSelected:(NSString *)tag_name adnType:(NSInteger)tag_type {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HomeTagsController* svc = [storyboard instantiateViewControllerWithIdentifier:@"TagSearch"];
    svc.tag_name = tag_name;
    svc.tag_type = tag_type;
    
    [self.navigationController pushViewController:svc animated:YES];
}

- (void)recommandRoleTagBtnSelected:(NSString *)tag_name {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HomeTagsController* svc = [storyboard instantiateViewControllerWithIdentifier:@"TagSearch"];
    svc.tag_name = tag_name;
    
    [self.navigationController pushViewController:svc animated:YES];
}

#pragma mark -- search seg view delegate
- (void)segValueChanged2:(SearchSegView2*)seg {
    _searchBar.text = @"";
    [_current_delegate resetCurrentSearchData];
//    _fm.previewDic = nil;
//    [_queryView reloadData];
    if (seg.selectedIndex == 0) {
        self.current_delegate = tagDelegate;
    } else {
        self.current_delegate = roleDelegate;
    }
}

- (void)setCurrentTableViewDelegate:(id<UITableViewDataSource,UITableViewDelegate, FoundSearchProtocol>)current_delegate {
    _current_delegate = current_delegate;
    _queryView.delegate = _current_delegate;
    _queryView.dataSource = _current_delegate;
    [_current_delegate asyncQueryFoundSearchDataWithFinishBlock:^{
        [_queryView reloadData];
    }];
}
@end
