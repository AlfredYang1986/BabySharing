//
//  CycleAddKidsViewController.m
//  BabySharing
//
//  Created by Alfred Yang on 13/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "CycleAddKidsViewController.h"

#import "CycleAddKidsCell.h"
#import "CycleAddKidsFooter.h"

@interface CycleAddKidsViewController () <UITableViewDataSource, UITableViewDelegate, CycleAddKisCellProtocol>
@property (weak, nonatomic) IBOutlet UITableView *queryView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation CycleAddKidsViewController {
    NSInteger current_index;
    
    NSMutableArray* kids_changed;
}

@synthesize queryView = _queryView;
@synthesize datePicker = _datePicker;

@synthesize kids = _kids;
@synthesize delegate = _delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_queryView registerNib:[UINib nibWithNibName:@"CycleAddKidsCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cycle add kids"];
    [_queryView registerNib:[UINib nibWithNibName:@"CycleAddKidsFooter" bundle:[NSBundle mainBundle]] forHeaderFooterViewReuseIdentifier:@"cycle add kids footer"];
    _queryView.scrollEnabled = NO;
    
    UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panHandler:)];
    [self.view addGestureRecognizer:pan];
    
    [_datePicker addTarget:self action:@selector(dateValueChanged) forControlEvents:UIControlEventValueChanged];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(doneBtnSelected)];
    
    kids_changed = [_kids copy];
    [self changeCurrentIndex:0];
}

- (void)changeCurrentIndex:(NSInteger)index {
    current_index = index;
    @try {
        NSDictionary* tmp = [kids_changed objectAtIndex:current_index];
        if ([tmp.allKeys containsObject:@"dob"]) {
            _datePicker.date = [NSDate dateWithTimeIntervalSince1970:((NSNumber*)[tmp objectForKey:@"dob"]).longLongValue / 1000];
        }
    }
    @catch (NSException *exception) {
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)panHandler:(UIPanGestureRecognizer*)gesture {
    NSLog(@"pan handler");
}

- (void)doneBtnSelected {
    NSMutableArray* rel = [[NSMutableArray alloc]init];
    for (int index = 0; index < kids_changed.count + 1; ++index) {
        CycleAddKidsCell* cell = (CycleAddKidsCell*)[_queryView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        if (cell != nil && [cell hasValue]) {
            NSDictionary* tmp = [cell getChangedKidData];
            [rel addObject:tmp];
        }
    }
   
    [_delegate changeKidsInfo:rel];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dateValueChanged {
    // dob
    NSDate* pick = _datePicker.date;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:pick];
    
    // now
    NSDate* now = [NSDate date];
    NSDateComponents *comps_2 = [calendar components:unitFlags fromDate:now];
    
    long tmp_age = [comps_2 year] - [comps year];
    int tmp_horoscrope = [self horoscropeWithMonth:[comps month] andDay:[comps day]];

    CycleAddKidsCell* cell = (CycleAddKidsCell*)[_queryView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:current_index inSection:0]];

    NSMutableDictionary* dic_one_change = [[NSMutableDictionary  alloc]init];
    [dic_one_change setObject:[NSNumber numberWithLong:tmp_age] forKey:@"age"];
    [dic_one_change setObject:[NSNumber numberWithInt:tmp_horoscrope] forKey:@"horoscrope"];
    [dic_one_change setObject:[NSNumber numberWithLongLong:[NSNumber numberWithDouble:_datePicker.date.timeIntervalSince1970 * 1000].longLongValue] forKey:@"dob"];
    [cell resetKidData:[dic_one_change copy]];
}

- (Horoscrope)horoscropeWithMonth:(NSInteger)month andDay:(NSInteger)day {
    month = month < 3 ? 12 + month : month;
    long rel = day >= 20 ?  month - 3 : month - 4;
    return rel == -1 ? rel == 11 : rel;
}

#pragma mark -- add kids protocol
- (void)selectKidsSchool {
    [self performSegueWithIdentifier:@"addKidsSchool" sender:nil];
}

- (void)addKidsBtnSelected {
    
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"addKidsSchool"]) {
    }
}

#pragma mark -- table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44 * 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 66;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    CycleAddKidsFooter* footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"cycle add kids footer"];
    
    if (footer == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CycleAddKidsFooter" owner:self options:nil];
        footer = [nib objectAtIndex:0];
    }
    
    return footer;
}

#pragma mark -- data soucr
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return kids_changed.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CycleAddKidsCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cycle add kids"];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CycleAddKidsCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
  
    @try {
//        cell.kid = [kids_changed objectAtIndex:indexPath.row];
        [cell resetKidData:[kids_changed objectAtIndex:indexPath.row]];
    }
    @catch (NSException *exception) {
        
    
    }
    
    cell.delegate = self;
    
    return cell;
}

@end
