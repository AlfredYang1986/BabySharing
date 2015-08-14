//
//  CycleAddDOBViewController.m
//  BabySharing
//
//  Created by Alfred Yang on 13/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "CycleAddDOBViewController.h"
#import "CycleDescriptionCell.h"

@interface CycleAddDOBViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *queryView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation CycleAddDOBViewController {
    NSArray* titles_cn;
    NSArray* titles;
}

@synthesize queryView = _queryView;
@synthesize datePicker = _datePicker;

@synthesize delegate = _delegate;
@synthesize dic_description = _dic_description;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _queryView.delegate = self;
    _queryView.dataSource = self;
    _queryView.scrollEnabled = NO;
    [_queryView registerNib:[UINib nibWithNibName:@"CycleDescriptionCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cycle description cell"];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(doneBtnSelected)];
    
    _datePicker.hidden = YES;
    
    titles_cn = @[@"年龄", @"星座", @"允许使用星座作为推荐条件"];
    titles = @[@"age", @"horoscrope", @""];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doneBtnSelected {
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -- ui table view datasource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
    _datePicker.hidden = NO;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && _datePicker.hidden == YES) {
        return YES;
    } else return NO;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return @"你的生日将不会被公开";
    } else {
        return @"";
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 22;
    } else return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return 1;
    } else {
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CycleDescriptionCell* cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"cycle description cell"];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CycleDescriptionCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.titleLabel.text = [titles_cn objectAtIndex:indexPath.section * 2 + indexPath.row];
    cell.descriptionLabel.text = [_dic_description objectForKeyedSubscript:[titles objectAtIndex:indexPath.section * 2 + indexPath.row]];
    
    return cell;
}
@end
