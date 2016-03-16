//
//  FoundViewController.m
//  BabySharing
//
//  Created by Alfred Yang on 17/11/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import "FoundViewController.h"
#import "HomeViewFoundDelegateAndDatasource.h"
#import "FoundSearchController.h"
#import "INTUAnimationEngine.h"

#define STATUS_HEIGHT       20
#define SCREEN_WIDTH        [UIScreen mainScreen].bounds.size.width

#define SEARCH_BOUNDS       CGFloat search_height = 44; \
                            CGRect rc_search = CGRectMake(0, 0, SCREEN_WIDTH, search_height);

#define FOUND_BOUNDS        CGFloat found_width = [UIScreen mainScreen].bounds.size.width; \
                            CGFloat found_height = [UIScreen mainScreen].bounds.size.height; \
                            CGRect rc1 = CGRectMake(0, search_height, found_width, found_height);

#define FOUND_VIEW_START    CGRectMake(0, STATUS_HEIGHT + search_height + 10, rc1.size.width, rc1.size.height - STATUS_HEIGHT - search_height - 49)
#define FOUND_VIEW_END      CGRectMake(0, 0, rc1.size.width, rc1.size.height - STATUS_HEIGHT - 49)

#define SEARCH_RECT         CGRectMake(0, STATUS_HEIGHT, rc_search.size.width, rc_search.size.height)

@interface FoundViewController () <UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *queryView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation FoundViewController {
    HomeViewFoundDelegateAndDatasource* found_datasource;
    UIView* bkView;
    
    CALayer* line;
    CALayer* line1;
}

@synthesize queryView = _queryView;
@synthesize searchBar = _searchBar;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.3126 green:0.7529 blue:0.6941 alpha:1.f]];

    found_datasource = [[HomeViewFoundDelegateAndDatasource alloc]initWithTableView:_queryView andContainer:self];
    _queryView.delegate = found_datasource;
    _queryView.dataSource = found_datasource;
    _queryView.backgroundColor = [UIColor colorWithWhite:0.9490 alpha:1.f];
    
    [self layoutTableViews];
    self.view.backgroundColor = [UIColor colorWithWhite:0.9490 alpha:1.f];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)layoutTableViews {
    NSLog(@"layout the tableviews");
    SEARCH_BOUNDS
    FOUND_BOUNDS
    _searchBar.frame = SEARCH_RECT;
    _queryView.frame = FOUND_VIEW_START;
    
    bkView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, found_width, STATUS_HEIGHT)];
//    bkView.backgroundColor = [UIColor colorWithRed:0.3126 green:0.7529 blue:0.6941 alpha:1.f];
    bkView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bkView];
    [self.view bringSubviewToFront:bkView];
   
    _searchBar.delegate = self;
    _searchBar.placeholder = @"搜索标签和角色";
#define SEARCH_BAR_HEIGHT   44
    UIImageView* iv = [[UIImageView alloc] initWithImage:[self imageWithColor:[UIColor whiteColor] size:CGSizeMake(SCREEN_WIDTH, SEARCH_BAR_HEIGHT)]];
    [_searchBar insertSubview:iv atIndex:1];
    for (UIView* v in _searchBar.subviews.firstObject.subviews) {
        if ( [v isKindOfClass: [UITextField class]] ) {
            UITextField *tf = (UITextField *)v;
            tf.backgroundColor = [UIColor colorWithWhite:0.9490 alpha:1.f];
            tf.borderStyle = UITextBorderStyleRoundedRect;
            tf.clearButtonMode = UITextFieldViewModeWhileEditing;
        } else if ([v isKindOfClass:[UIButton class]]) {
            // UIButton* cancel_btn = (UIButton*)v;
            // [cancel_btn setTitle:@"test" forState:UIControlStateNormal];
            // [cancel_btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            // [cancel_btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        }
    }
    
    line = [CALayer layer];
    line.borderColor = [UIColor colorWithWhite:0.5922 alpha:0.30].CGColor;
    line.borderWidth = 1.f;
    line.frame = CGRectMake(0, 64, SCREEN_WIDTH, 1);
    [self.view.layer addSublayer:line];
    
    line1 = [CALayer layer];
    line1.borderColor = [UIColor colorWithWhite:0.5922 alpha:0.10].CGColor;
    line1.borderWidth = 1.f;
    line1.frame = CGRectMake(0, 64, SCREEN_WIDTH, 1);
    [self.view.layer addSublayer:line1];
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

- (void)viewDidLayoutSubviews {
    SEARCH_BOUNDS
    FOUND_BOUNDS
    _searchBar.frame = SEARCH_RECT;
    _queryView.frame = FOUND_VIEW_START;
}

#pragma mark -- searh bar delegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"FoundSearch" bundle:nil];
    FoundSearchController* svc = [storyboard instantiateViewControllerWithIdentifier:@"FoundSearch"];
    [self.navigationController pushViewController:svc animated:NO];
    return NO;
}

- (void)scrollDidScroll:(UIScrollView*)scrollView {
    SEARCH_BOUNDS
    FOUND_BOUNDS
    if (scrollView.contentOffset.y > 100) {
        if (_searchBar.hidden == NO) {
            _searchBar.hidden = YES;
            _queryView.frame = FOUND_VIEW_END;
            line.hidden = YES;
            line1.hidden = YES;
        }
        
    } else {
        if (_searchBar.hidden == YES) {
            _searchBar.hidden = NO;
            _queryView.frame = FOUND_VIEW_START;
            line.hidden = NO;
            line1.hidden = NO;
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end
