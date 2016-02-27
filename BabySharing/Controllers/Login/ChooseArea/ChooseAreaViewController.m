//
//  ChooseAreaViewController.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 30/12/2014.
//  Copyright (c) 2014 YY. All rights reserved.
//

#import "ChooseAreaViewController.h"
#import "LoginViewController.h"
#import "AreaTableCell.h"

//@interface ChooseAreaViewController () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate> {
@interface ChooseAreaViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate> {
    NSArray* arr;
    NSArray* filter_arr;
}
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UITableView *areaTableView;
@property (weak, nonatomic) IBOutlet UIView *fakeBar;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@end

@implementation ChooseAreaViewController

@synthesize areaTableView = _areaTableView;
//@synthesize areaSearchBar = _areaSearchBar;
@synthesize delegate = _delegate;

//@synthesize searchIcon = _searchIcon;
@synthesize searchTextField = _searchTextField;
@synthesize confirmBtn = _confirmBtn;

@synthesize fakeBar = _fakeBar;
@synthesize bgView = _bgView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    NSString *areaPath = [[NSBundle mainBundle] pathForResource:@"AreaCodeJson" ofType:@"txt"];
    NSData *data = [NSData dataWithContentsOfFile:areaPath];
    NSError* error;
    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers error:&error];
    
    arr = [dic objectForKey:@"Area"];
    filter_arr = arr;
    
    [_areaTableView registerNib:[UINib nibWithNibName:@"AreaTableCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Area Table Cell"];
    _areaTableView.sectionIndexColor = [UIColor colorWithWhite:0.3050 alpha:1.f];
    _areaTableView.sectionIndexTrackingBackgroundColor = [UIColor colorWithWhite:1.f alpha:0.60];
    
//    UILabel* title_label = [[UILabel alloc]init];
//    title_label.text = @"选择国家或地区";
//    title_label.textColor = [UIColor whiteColor];
//    [title_label sizeToFit];
//    self.navigationItem.titleView = title_label;
//    
//    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
//    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
//    UIButton* barBtn = [[UIButton alloc]initWithFrame:CGRectMake(13, 32, 30, 25)];
//    NSString* filepath = [resourceBundle pathForResource:@"Previous_simple" ofType:@"png"];
//    CALayer * layer = [CALayer layer];
//    layer.contents = (id)[UIImage imageNamed:filepath].CGImage;
//    layer.frame = CGRectMake(0, 0, 13, 20);
////    layer.position = CGPointMake(10, barBtn.frame.size.height / 2);
//    layer.position = CGPointMake(0, barBtn.frame.size.height / 2);
//    [barBtn.layer addSublayer:layer];
//    [barBtn addTarget:self action:@selector(didPopViewController) forControlEvents:UIControlEventTouchDown];
//    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:barBtn];
//    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    
    [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _confirmBtn.backgroundColor = [UIColor colorWithRed:0.9686 green:0.7204 blue:0.1961 alpha:1.f];
    _confirmBtn.layer.cornerRadius = 4.f;
    _confirmBtn.clipsToBounds = YES;

//    NSString* search_filepath = [resourceBundle pathForResource:@"Explore" ofType:@"png"];
//    _searchIcon.image = [UIImage imageNamed:search_filepath];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchTextChanged) name:UITextFieldTextDidChangeNotification object:nil];
   
#define SCREEN_WIDTH            [UIScreen mainScreen].bounds.size.width
#define FAKE_BAR_HEIGHT         44
#define STATUS_BAR_HEIGHT       20
    
#define BACK_BTN_LEFT_MARGIN    16 + 10
    
    _fakeBar.backgroundColor = [UIColor colorWithWhite:0.1098 alpha:1.f];
    _bgView.backgroundColor = [UIColor colorWithWhite:0.1098 alpha:1.f];
    
    UILabel* label = [[UILabel alloc]init];
    label.text = @"选择国家和区域";
    label.font = [UIFont systemFontOfSize:18.f];
    label.textColor = [UIColor whiteColor];
    [label sizeToFit];
    label.center = CGPointMake(SCREEN_WIDTH / 2, STATUS_BAR_HEIGHT + FAKE_BAR_HEIGHT / 2);
    [_fakeBar addSubview:label];
    
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    UIButton* barBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 25)];
    NSString* filepath = [resourceBundle pathForResource:@"dongda_back_light" ofType:@"png"];
    CALayer * layer = [CALayer layer];
    layer.contents = (id)[UIImage imageNamed:filepath].CGImage;
    layer.frame = CGRectMake(0, 0, 25, 25);
    //    layer.position = CGPointMake(10, barBtn.frame.size.height / 2);
    layer.position = CGPointMake(0, barBtn.frame.size.height / 2);
    [barBtn.layer addSublayer:layer];
    barBtn.center = CGPointMake(BACK_BTN_LEFT_MARGIN + barBtn.frame.size.width / 2, STATUS_BAR_HEIGHT + FAKE_BAR_HEIGHT / 2);
    
    [barBtn addTarget:self action:@selector(didPopViewController) forControlEvents:UIControlEventTouchDown];
    [_fakeBar addSubview:barBtn];
    
    _areaTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didPopViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
    //UIStatusBarStyleDefault = 0 黑色文字，浅色背景时使用
    //UIStatusBarStyleLightContent = 1 白色文字，深色背景时使用
}

- (BOOL)prefersStatusBarHidden {
    return YES; //返回NO表示要显示，返回YES将hiden
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

#pragma mark -- table view datasource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AreaTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Area Table Cell"];
    
    if (cell == nil) {
        cell = [[AreaTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Area Table Cell"];
    }
  
//    NSArray *languages = [NSLocale preferredLanguages];
//    NSString *currentLanguage = [languages objectAtIndex:0];
    
    NSDictionary* cur = [filter_arr objectAtIndex:indexPath.row];
    NSString* cur_name = [cur objectForKey:@"cn"];
//    if ([currentLanguage isEqualToString:@"zh-Hans"]) {
//        cur_name = [cur objectForKey:@"cn"];
//    } else {
//        cur_name = [cur objectForKey:@"en"];
//    }
   
    NSString* cur_code = [cur objectForKey:@"code"];
   
    cell.countryLabel.text = cur_name;
    cell.codeLabel.text = [@"+" stringByAppendingString:cur_code];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return filter_arr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 'Z' - 'A' + 1;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"%c", 'A' + section];
}

#pragma mark -- table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary* item = [filter_arr objectAtIndex:indexPath.row];
    [_delegate didSelectArea:[item objectForKey:@"code"]];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    sleep(0.5);
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
     NSMutableArray *toBeReturned = [[NSMutableArray alloc]init];
     for(char c = 'A';c<='Z';c++)
         [toBeReturned addObject:[NSString stringWithFormat:@"%c",c]];
    
    return [toBeReturned copy];
}

#pragma mark -- text field delegate
- (void)searchTextChanged {
    NSString* searchText = _searchTextField.text;
    
    if ([searchText isEqualToString:@""]) {
        filter_arr = arr;
        [_areaTableView reloadData];
        return;
    }
    
    NSString* regex = @"[^x00-xff]+";
    NSPredicate* p = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    
    if ([p evaluateWithObject:searchText]) {
        
        //        NSString *regex2 = [NSString stringWithFormat:@"^[%@]\\w*", searchText];
        NSString *regex2 = [NSString stringWithFormat:@"^%@\\w*", searchText];
        NSPredicate* p2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex2];
        
        NSMutableArray* tmp = [[NSMutableArray alloc]init];
        for (NSDictionary* iter in arr) {
            if ([p2 evaluateWithObject:[iter objectForKey:@"cn"]]) {
                [tmp addObject:iter];
            }
        }
        filter_arr = [tmp copy];
    } else {
        
        NSString *regex2 = [NSString stringWithFormat:@"^%@\\w*", [searchText lowercaseString]];
        NSPredicate* p2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex2];
        
        NSMutableArray* tmp = [[NSMutableArray alloc]init];
        for (NSDictionary* iter in arr) {
            if ([p2 evaluateWithObject:[(NSString*)[iter objectForKey:@"en"] lowercaseString]]) {
                [tmp addObject:iter];
            }
        }
        filter_arr = [tmp copy];
    }
    [_areaTableView reloadData];
}

//#pragma mark -- search bar delegate
//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
//    
//    if ([searchText isEqualToString:@""]) {
//        filter_arr = arr;
//        [_areaTableView reloadData];
//        return;
//    }
//    
//    NSString* regex = @"[^x00-xff]+";
//    NSPredicate* p = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
//    
//    
//    if ([p evaluateWithObject:searchText]) {
//
////        NSString *regex2 = [NSString stringWithFormat:@"^[%@]\\w*", searchText];
//        NSString *regex2 = [NSString stringWithFormat:@"^%@\\w*", searchText];
//        NSPredicate* p2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex2];
//       
//        NSMutableArray* tmp = [[NSMutableArray alloc]init];
//        for (NSDictionary* iter in arr) {
//            if ([p2 evaluateWithObject:[iter objectForKey:@"cn"]]) {
//                [tmp addObject:iter];
//            }
//        }
//        filter_arr = [tmp copy];
//    } else {
//        
//        NSString *regex2 = [NSString stringWithFormat:@"^%@\\w*", [searchText lowercaseString]];
//        NSPredicate* p2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex2];
//       
//        NSMutableArray* tmp = [[NSMutableArray alloc]init];
//        for (NSDictionary* iter in arr) {
//            if ([p2 evaluateWithObject:[(NSString*)[iter objectForKey:@"en"] lowercaseString]]) {
//                [tmp addObject:iter];
//            }
//        }
//        filter_arr = [tmp copy];
//    }
//    [_areaTableView reloadData];
//}
//
//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
//    [searchBar resignFirstResponder];
//}

@end
