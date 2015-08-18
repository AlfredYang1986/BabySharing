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

#import "CycleAddDOBViewController.h"
#import "CycleAddKidsViewController.h"

@interface CycleAddDescriptionViewController () <UITableViewDataSource, UITableViewDelegate, SearchUserTagControllerDelegate, addDOBProtocol, addKidsProtocol>
@property (weak, nonatomic) IBOutlet UILabel *roleTagLabel;
@property (weak, nonatomic) IBOutlet UIView *tagRowView;
@property (weak, nonatomic) IBOutlet UITableView *descriptionDetailTableView;

@end

@implementation CycleAddDescriptionViewController {
    NSArray* titles;
    NSArray* titles_cn;
 
    NSMutableDictionary* dic_changed;
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
    
    dic_changed = [_dic_description mutableCopy];
}

- (void)saveDescriptionBtnSelected {
    if (_isEditable && dic_changed) {
        NSEnumerator* enumerator = dic_changed.keyEnumerator;
        id iter = nil;
        
        while ((iter = [enumerator nextObject]) != nil) {
            [_dic_description setObject:[dic_changed objectForKey:iter] forKey:iter];
        }

        [_lm updateDetailInfoWithData:_dic_description];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
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
  
        int age = -1;
        if (_dic_description && [_dic_description.allKeys containsObject:@"age"]) {
            age = ((NSNumber*)[_dic_description objectForKey:@"age"]).intValue;
        }
        
        int horoscrope = -1;
        if (_dic_description && [_dic_description.allKeys containsObject:@"horoscrope"]) {
            horoscrope = ((NSNumber*)[_dic_description objectForKey:@"horoscrope"]).intValue;
        }
       
        NSDate* date = nil;
        if (_dic_description && [_dic_description.allKeys containsObject:@"dob"]) {
            date = [NSDate dateWithTimeIntervalSince1970:((NSNumber*)[_dic_description objectForKey:@"dob"]).longLongValue / 1000];
        }
        
        ((CycleAddDOBViewController*)segue.destinationViewController).age = age;
        ((CycleAddDOBViewController*)segue.destinationViewController).horoscrope = horoscrope;
        ((CycleAddDOBViewController*)segue.destinationViewController).dob = date;
        ((CycleAddDOBViewController*)segue.destinationViewController).delegate = self;
    
    } else if ([segue.identifier isEqualToString:@"addKids"]) {
        
        ((CycleAddKidsViewController*)segue.destinationViewController).kids = [[_dic_description objectForKey:@"kids"] mutableCopy];
        ((CycleAddKidsViewController*)segue.destinationViewController).delegate = self;
    }
}

- (void)detailInfoSynced:(BOOL)success {
    _isEditable = YES;
}

#pragma mark -- cycle add dob
- (void)didChangeDOB:(NSDate*)dob andAge:(NSInteger)age andHoroscrope:(Horoscrope)horoscrope {
    if (dic_changed == nil) {
        dic_changed = [[NSMutableDictionary alloc]init];
    }
    
    [dic_changed setObject:[NSNumber numberWithLongLong:[NSNumber numberWithDouble:dob.timeIntervalSince1970 * 1000].longLongValue] forKey:@"dob"];
    [dic_changed setObject:[NSNumber numberWithInteger:age] forKey:@"age"];
    [dic_changed setObject:[NSNumber numberWithInteger:horoscrope] forKey:@"horoscrope"];
    
    [_descriptionDetailTableView reloadData];
}

#pragma mark -- cycle add kids
- (void)changeKidsInfo:(NSArray*)kids {
    if (dic_changed == nil) {
        dic_changed = [[NSMutableDictionary alloc]init];
    }
   
    if (kids != nil) {
        [dic_changed setObject:kids forKey:@"kids"];
        [_descriptionDetailTableView reloadData];
    }
}

#pragma mark -- table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (!_isEditable) {
        UIAlertView* view = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"can edit because sync is not ready" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [view show];
    } else {
        switch (indexPath.row) {
            case 0:
                [self performSegueWithIdentifier:@"addDOB" sender:nil];
                break;
            case 1:
                [self performSegueWithIdentifier:@"addKids" sender:nil];
                break;
            default:
                break;
        }
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
  
    NSString* title = [titles objectAtIndex:indexPath.row];
    NSObject* tmp = [dic_changed objectForKey:title];
    if ([tmp isKindOfClass:[NSString class]]) {
        cell.descriptionLabel.text = (NSString*)tmp;
    } else if ([tmp isKindOfClass:[NSNumber class]]) {
        cell.descriptionLabel.text = [NSString stringWithFormat:@"%ld", ((NSNumber*)tmp).longValue];
    } else if ([tmp isKindOfClass:[NSArray class]]){
        cell.descriptionLabel.text = [NSString stringWithFormat:@"%lu个孩子", (unsigned long)((NSArray*)tmp).count];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}
@end
