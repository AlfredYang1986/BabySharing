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
@property (weak, nonatomic) IBOutlet UIImageView *searchIcon;
//@property (weak, nonatomic) IBOutlet UISearchBar *areaSearchBar;
@property (weak, nonatomic) IBOutlet UITableView *areaTableView;
@end

@implementation ChooseAreaViewController

@synthesize areaTableView = _areaTableView;
//@synthesize areaSearchBar = _areaSearchBar;
@synthesize delegate = _delegate;

@synthesize searchIcon = _searchIcon;
@synthesize searchTextField = _searchTextField;
@synthesize confirmBtn = _confirmBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    NSString *areaPath = [[NSBundle mainBundle] pathForResource:@"AreaCodeJson" ofType:@"txt"];
    NSData *data = [NSData dataWithContentsOfFile:areaPath];
    NSError* error;
    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers error:&error];
    
    arr = [dic objectForKey:@"Area"];
    filter_arr = arr;
    
    [_areaTableView registerNib:[UINib nibWithNibName:@"AreaTableCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Area Table Cell"];
    
    UILabel* title_label = [[UILabel alloc]init];
    title_label.text = @"选择国家或地区";
    title_label.textColor = [UIColor whiteColor];
    [title_label sizeToFit];
    self.navigationItem.titleView = title_label;
    
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    UIButton* barBtn = [[UIButton alloc]initWithFrame:CGRectMake(13, 32, 30, 25)];
    NSString* filepath = [resourceBundle pathForResource:@"Previous_simple" ofType:@"png"];
    CALayer * layer = [CALayer layer];
    layer.contents = (id)[UIImage imageNamed:filepath].CGImage;
    layer.frame = CGRectMake(0, 0, 13, 20);
//    layer.position = CGPointMake(10, barBtn.frame.size.height / 2);
    layer.position = CGPointMake(0, barBtn.frame.size.height / 2);
    [barBtn.layer addSublayer:layer];
    [barBtn addTarget:self action:@selector(didPopViewController) forControlEvents:UIControlEventTouchDown];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:barBtn];
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    
    [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _confirmBtn.backgroundColor = [UIColor orangeColor];
    _confirmBtn.layer.cornerRadius = 4.f;
    _confirmBtn.clipsToBounds = YES;

    NSString* search_filepath = [resourceBundle pathForResource:@"Explore" ofType:@"png"];
    _searchIcon.image = [UIImage imageNamed:search_filepath];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchTextChanged) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)didPopViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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

#pragma mark -- table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary* item = [filter_arr objectAtIndex:indexPath.row];
    [_delegate didSelectArea:[item objectForKey:@"code"]];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    sleep(0.5);
    
    [self.navigationController popViewControllerAnimated:YES];
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
