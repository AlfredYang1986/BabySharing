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
//#import "SearchUserTagsController.h"

#import "CycleAddDOBViewController.h"
#import "CycleAddKidsViewController.h"
#import "CycleAddHometownController.h"
#import "CycleAddSchoolViewController.h"

@interface CycleAddDescriptionViewController () <UITableViewDataSource, UITableViewDelegate, /*SearchUserTagControllerDelegate,*/ addDOBProtocol, addKidsProtocol, addHometownProtocol, addSchoolProtocol>
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
    
    titles = @[@"age", @"kids", @"hometown", @"school"];
    titles_cn = @[@"年龄", @"孩子", @"家乡", @"学校"];

    _roleTagLabel.text = [_dic_description objectForKey:@"role_tag"];
    
    if (_dic_description == nil) {
        [_lm currentDeltailInfoAsyncWithFinishBlock:^(BOOL success, NSDictionary * dic) {
            if (success) {
                dic_changed = [dic mutableCopy];
                [_lm updateDetailInfoLocalWithData:dic];
                if (dic_changed.count > 1) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self detailInfoSynced:YES];
                        [_descriptionDetailTableView reloadData];
                    });
                }
            }
        }];
    } else {
        dic_changed = [_dic_description mutableCopy];
    }
    
    UILabel* label = [[UILabel alloc]init];
    label.text = @"描述";
    label.textColor = [UIColor whiteColor];
    [label sizeToFit];
    self.navigationItem.titleView = label;
   
    UIButton* barBtn = [[UIButton alloc]initWithFrame:CGRectMake(13, 32, 30, 25)];
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
//    NSString* filepath = [resourceBundle pathForResource:@"Previous_blue" ofType:@"png"];
    NSString* filepath = [resourceBundle pathForResource:@"Previous_simple" ofType:@"png"];
    CALayer * layer = [CALayer layer];
    layer.contents = (id)[UIImage imageNamed:filepath].CGImage;
    layer.frame = CGRectMake(0, 0, 13, 20);
    layer.position = CGPointMake(10, barBtn.frame.size.height / 2);
    [barBtn.layer addSublayer:layer];
//    [barBtn setBackgroundImage:[UIImage imageNamed:filepath] forState:UIControlStateNormal];
//    [barBtn setImage:[UIImage imageNamed:filepath] forState:UIControlStateNormal];
    [barBtn addTarget:self action:@selector(didPopControllerSelected) forControlEvents:UIControlEventTouchDown];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:barBtn];

    UIButton* barBtn2 = [[UIButton alloc]initWithFrame:CGRectMake(13, 32, 30, 25)];
    [barBtn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [barBtn2 setTitle:@"保存" forState:UIControlStateNormal];
    [barBtn2 sizeToFit];
    [barBtn2 addTarget:self action:@selector(saveDescriptionBtnSelected) forControlEvents:UIControlEventTouchDown];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:barBtn2];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveDescriptionBtnSelected)];
}

- (void)didPopControllerSelected {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)saveDescriptionBtnSelected {
    if (_isEditable && dic_changed) {
//        NSEnumerator* enumerator = dic_changed.keyEnumerator;
//        id iter = nil;
//        
//        while ((iter = [enumerator nextObject]) != nil) {
//            [_dic_description setObject:[dic_changed objectForKey:iter] forKey:iter];
//        }
//
//        [_lm updateDetailInfoWithData:_dic_description];
        [_lm updateDetailInfoWithData:dic_changed];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)changeRoleTagBtnSelected {
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    SearchUserTagsController* sp = [storyboard instantiateViewControllerWithIdentifier:@"SearchPickRoleTags"];
//    sp.delegate = self;
//    [self.navigationController pushViewController:sp animated:YES];
}

- (void)didSelectTag:(NSString*)tags {
    _roleTagLabel.text = tags;
    [dic_changed setValue:tags forKey:@"role_tag"];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"addDOB"]) {
  
        int age = -1;
        if (dic_changed && [dic_changed.allKeys containsObject:@"age"]) {
            age = ((NSNumber*)[dic_changed objectForKey:@"age"]).intValue;
        }
        
        int horoscrope = -1;
        if (dic_changed && [dic_changed.allKeys containsObject:@"horoscrope"]) {
            horoscrope = ((NSNumber*)[dic_changed objectForKey:@"horoscrope"]).intValue;
        }
       
        NSDate* date = nil;
        if (dic_changed && [dic_changed.allKeys containsObject:@"dob"]) {
            date = [NSDate dateWithTimeIntervalSince1970:((NSNumber*)[dic_changed objectForKey:@"dob"]).longLongValue / 1000];
        }
        
        ((CycleAddDOBViewController*)segue.destinationViewController).age = age;
        ((CycleAddDOBViewController*)segue.destinationViewController).horoscrope = horoscrope;
        ((CycleAddDOBViewController*)segue.destinationViewController).dob = date;
        ((CycleAddDOBViewController*)segue.destinationViewController).delegate = self;
    
    } else if ([segue.identifier isEqualToString:@"addKids"]) {
        
        ((CycleAddKidsViewController*)segue.destinationViewController).kids = [[dic_changed objectForKey:@"kids"] mutableCopy];
        ((CycleAddKidsViewController*)segue.destinationViewController).delegate = self;
    } else if ([segue.identifier isEqualToString:@"addHometown"]) {
        ((CycleAddHometownController*)segue.destinationViewController).delegate = self;
        ((CycleAddHometownController*)segue.destinationViewController).ori_hometown = [dic_changed objectForKey:@"hometown"];
    } else if ([segue.identifier isEqualToString:@"addSchool"]) {
        ((CycleAddSchoolViewController*)segue.destinationViewController).delegate = self;
        ((CycleAddSchoolViewController*)segue.destinationViewController).ori_school_name = [dic_changed objectForKey:@"school"];
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

#pragma mark -- cycle add hometown
- (void)addHometown:(NSString *)hometown {
    if (dic_changed == nil) {
        dic_changed = [[NSMutableDictionary alloc]init];
    }
    
    [dic_changed setObject:hometown forKey:@"hometown"];
    [_descriptionDetailTableView reloadData];
}

- (void)addSchool:(NSString *)school_name {
    if (dic_changed == nil) {
        dic_changed = [[NSMutableDictionary alloc]init];
    }
    
    [dic_changed setObject:school_name forKey:@"school"];
    [_descriptionDetailTableView reloadData];   
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
            case 2:
                [self performSegueWithIdentifier:@"addHometown" sender:nil];
                break;
            case 3:
                [self performSegueWithIdentifier:@"addSchool" sender:nil];
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
    CycleDescriptionCell* cell = (CycleDescriptionCell*)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"cycle description cell"];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CycleDescriptionCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.titleLabel.textColor = [UIColor grayColor];
    cell.titleLabel.text = [titles_cn objectAtIndex:indexPath.row];
    cell.descriptionLabel.textColor = [UIColor colorWithRed:0.3126 green:0.7529 blue:0.6941 alpha:1.f];
  
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
