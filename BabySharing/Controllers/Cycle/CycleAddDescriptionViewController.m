//
//  CycleAddDescriptionViewController.m
//  BabySharing
//
//  Created by Alfred Yang on 13/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "CycleAddDescriptionViewController.h"
#import "CycleDescriptionCell.h"

#import "LoginModel.h"
#import "SearchUserTagsController.h"

@interface CycleAddDescriptionViewController () <UITableViewDataSource, UITableViewDelegate, SearchUserTagControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *roleTagLabel;
@property (weak, nonatomic) IBOutlet UIView *tagRowView;
@property (weak, nonatomic) IBOutlet UITableView *descriptionDetailTableView;

@end

@implementation CycleAddDescriptionViewController {
    NSArray* titles;
    NSArray* titles_cn;
    
}

@synthesize roleTagLabel = _roleTagLabel;
@synthesize tagRowView = _tagRowView;
@synthesize descriptionDetailTableView = _descriptionDetailTableView;

@synthesize lm = _lm;
@synthesize dic_description = _dic_description;

@synthesize isEditable = _isEditable;

- (void)viewDidLoad {
    
    _descriptionDetailTableView.dataSource = self;
    _descriptionDetailTableView.delegate = self;
    _descriptionDetailTableView.scrollEnabled = NO;
    [_descriptionDetailTableView registerNib:[UINib nibWithNibName:@"CycleDescriptionCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cycle description cell"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveDescriptionBtnSelected)];
    
    titles = @[@"age", @"kids", @"hometown", @"school"];
    titles_cn = @[@"年龄", @"孩子", @"家乡", @"学校"];

    _roleTagLabel.text = [_dic_description objectForKey:@"role_tag"];
}

- (void)saveDescriptionBtnSelected {
    if (_isEditable) {
    }
}

- (IBAction)changeRoleTagBtnSelected {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchUserTagsController* sp = [storyboard instantiateViewControllerWithIdentifier:@"SearchPickRoleTags"];
    sp.delegate = self;
    [self.navigationController pushViewController:sp animated:YES];
}

- (void)didSelectTag:(NSString*)tags {
    _roleTagLabel.text = tags;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"addDOB"]) {
    }
}

- (void)detailInfoSynced:(BOOL)success {
    _isEditable = YES;
}

#pragma mark -- table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (!_isEditable) {
        UIAlertView* view = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"can edit because sync is not ready" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [view show];
    } else {
        [self performSegueWithIdentifier:@"addDOB" sender:nil];
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark -- table view datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CycleDescriptionCell* cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"cycle description cell"];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CycleDescriptionCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.titleLabel.text = [titles_cn objectAtIndex:indexPath.row];
    cell.descriptionLabel.text = [_dic_description objectForKey:[titles objectAtIndex:indexPath.row]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}
@end
