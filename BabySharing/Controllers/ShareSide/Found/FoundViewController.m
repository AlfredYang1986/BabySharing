//
//  FoundViewController.m
//  BabySharing
//
//  Created by Alfred Yang on 17/11/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import "FoundViewController.h"
#import "HomeViewFoundDelegateAndDatasource.h"

#define FOUND_BOUNDS        CGFloat found_width = [UIScreen mainScreen].bounds.size.width; \
                            CGFloat found_height = [UIScreen mainScreen].bounds.size.height; \
                            CGRect rc1 = CGRectMake(0, 0, found_width, found_height);

#define FOUND_VIEW_START    CGRectMake(0, 0, rc1.size.width, rc1.size.height)
#define FOUND_VIEW_END      CGRectMake(0, 0, rc1.size.width, rc1.size.height)

@interface FoundViewController ()
@property (weak, nonatomic) IBOutlet UITableView *queryView;

@end

@implementation FoundViewController {
    HomeViewFoundDelegateAndDatasource* found_datasource;
    UIView* bkView;
}

@synthesize queryView = _queryView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.3126 green:0.7529 blue:0.6941 alpha:1.f]];

    found_datasource = [[HomeViewFoundDelegateAndDatasource alloc]initWithTableView:_queryView andContainer:self];
    _queryView.delegate = found_datasource;
    _queryView.dataSource = found_datasource;
    _queryView.backgroundColor = [UIColor lightGrayColor];
    
    [self layoutTableViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)layoutTableViews {
    NSLog(@"layout the tableviews");
    FOUND_BOUNDS
    _queryView.frame = FOUND_VIEW_START;
    
    bkView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, found_width, 20)];
//    bkView.backgroundColor = [UIColor colorWithRed:0.3126 green:0.7529 blue:0.6941 alpha:1.f];
    bkView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bkView];
    [self.view bringSubviewToFront:bkView];
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
