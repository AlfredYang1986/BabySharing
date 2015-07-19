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

@interface ChooseAreaViewController () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate> {
    NSArray* arr;
    NSArray* filter_arr;
}

@end

@implementation ChooseAreaViewController

@synthesize areaTableView = _areaTableView;
@synthesize areaSearchBar = _areaSearchBar;
@synthesize delegate = _delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO animated:NO];
//    arr = [[NSArray alloc] initWithObjects:
//           [[AreaNode alloc] initWithAreaName:@"China" andAreaCode:@"+86"],
//           [[AreaNode alloc] initWithAreaName:@"USA" andAreaCode:@"+01"],
//           [[AreaNode alloc] initWithAreaName:@"CAD" andAreaCode:@"+01"],
//           [[AreaNode alloc] initWithAreaName:@"AU" andAreaCode:@"+61"],
//           nil];
//    
//    NSSortDescriptor* ordering = [[NSSortDescriptor alloc]initWithKey:@"areaCode" ascending:YES];
//    arr = [arr sortedArrayUsingDescriptors: [NSArray arrayWithObject: ordering]];
    
    NSString *areaPath = [[NSBundle mainBundle] pathForResource:@"AreaCodeJson" ofType:@"txt"];
    NSData *data = [NSData dataWithContentsOfFile:areaPath];
    NSError* error;
    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers error:&error];
    
    arr = [dic objectForKey:@"Area"];
    filter_arr = arr;
    
    [_areaTableView registerNib:[UINib nibWithNibName:@"AreaTableCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Area Table Cell"];
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
  
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    
    NSDictionary* cur = [filter_arr objectAtIndex:indexPath.row];
    NSString* cur_name;
    if ([currentLanguage isEqualToString:@"zh-Hans"]) {
        cur_name = [cur objectForKey:@"cn"];
    } else {
        cur_name = [cur objectForKey:@"en"];
    }
   
    NSString* cur_code = [cur objectForKey:@"code"];
   
    cell.countryLabel.text = cur_name;
    cell.codeLabel.text = cur_code;
    
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

#pragma mark -- search bar delegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if ([searchText isEqualToString:@""]) {
        filter_arr = arr;
        [_areaTableView reloadData];
        return;
    }
    
    NSString* regex = @"[^x00-xff]+";
    NSPredicate* p = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    
    if ([p evaluateWithObject:searchText]) {

        NSString *regex2 = [NSString stringWithFormat:@"^[%@]\\w*", searchText];
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

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

@end
