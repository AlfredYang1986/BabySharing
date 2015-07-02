//
//  ChooseAreaViewController.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 30/12/2014.
//  Copyright (c) 2014 YY. All rights reserved.
//

#import "ChooseAreaViewController.h"
#import "LoginViewController.h"

@implementation AreaNode

@synthesize areaCode = _areaCode;
@synthesize areaName = _areaName;

- (id)initWithAreaName:(NSString*)name andAreaCode:(NSString*)code {
    self = [super init];
    if (self != nil) {
        _areaName = name;
        _areaCode = code;
    }
    return self;
}
@end

@interface ChooseAreaViewController () {
    NSArray* arr;
    NSString* filter;
    NSArray* filter_arr;
}

@end

@implementation ChooseAreaViewController

@synthesize areaTableView = _areaTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    arr = [[NSArray alloc] initWithObjects:
           [[AreaNode alloc] initWithAreaName:@"China" andAreaCode:@"+86"],
           [[AreaNode alloc] initWithAreaName:@"USA" andAreaCode:@"+01"],
           [[AreaNode alloc] initWithAreaName:@"CAD" andAreaCode:@"+01"],
           [[AreaNode alloc] initWithAreaName:@"AU" andAreaCode:@"+61"],
           nil];
    
    NSSortDescriptor* ordering = [[NSSortDescriptor alloc]initWithKey:@"areaCode" ascending:YES];
    arr = [arr sortedArrayUsingDescriptors: [NSArray arrayWithObject: ordering]];
    filter_arr = arr;
    filter = @"";
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"default"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"default"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
   
    NSString* cur_name = ((AreaNode*)[filter_arr objectAtIndex:indexPath.row]).areaName;
    NSString* cur_code = ((AreaNode*)[filter_arr objectAtIndex:indexPath.row]).areaCode;
    
    NSString* show_name = [cur_name stringByAppendingString:@"    "];
    show_name = [show_name stringByAppendingString: cur_code];
    cell.textLabel.text = show_name;
    //    NSString *path = [[NSBundle mainBundle] pathForResource:[item objectForKey:@"imageKey"] ofType:@"png"];
    //    UIImage *theImage = [UIImage imageWithContentsOfFile:path];
    //    cell.imageView.image = theImage;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return filter_arr.count;
}

#pragma mark -- table view delegate

- (void)confirmSelectAreaCode:(NSString*)select {
    NSArray* controllers = ((UINavigationController*)self.navigationController).viewControllers;
    for (UIViewController* contorller in controllers) {
        if ([contorller isKindOfClass:[LoginViewController class]]) {
            ((LoginViewController*)contorller).areaCodeSelected = select;
            break;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AreaNode* node = [filter_arr objectAtIndex: indexPath.row];
    [self confirmSelectAreaCode:[NSString stringWithFormat:@"(%@)", node.areaCode]];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- text filed delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString* final_string = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSLog(@"%@", final_string);
    NSLog(@"%@", textField.text);
    NSLog(@"%@", string);
    if ([final_string isEqualToString:@""]) {
        filter_arr = arr;
    } else {
        NSPredicate* predicate = [NSPredicate predicateWithFormat: @"SELF.areaName contains[c] %@", final_string];
        filter_arr = [arr filteredArrayUsingPredicate:predicate];
    }
    [_areaTableView reloadData];
    
    return YES;
}
@end
