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
@property (weak, nonatomic) IBOutlet UILabel *reminderLabel;

@end

@implementation CycleAddKidsViewController {
    NSInteger current_index;
    
    NSMutableArray* kids_changed;
    
    UIButton* addBtn;
    UIButton* nextBtn;
    UIButton* prevBtn;
    UIButton* delectBtn;
    
    CALayer* layer0;
}

@synthesize queryView = _queryView;
@synthesize datePicker = _datePicker;
@synthesize reminderLabel = _reminderLabel;

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
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(doneBtnSelected)];
    
    kids_changed = [_kids mutableCopy];
    
    if (kids_changed.count == 0) {
        NSMutableDictionary* dic_new = [[NSMutableDictionary alloc]init];
        [kids_changed addObject:dic_new];
    }
    
    [self changeCurrentIndex:0];
    
    UILabel* label = [[UILabel alloc]init];
    label.text = @"您的孩子";
    label.textColor = [UIColor whiteColor];
    [label sizeToFit];
    self.navigationItem.titleView = label;
   
    UIButton* barBtn = [[UIButton alloc]initWithFrame:CGRectMake(13, 32, 30, 25)];
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    NSString* filepath2 = [resourceBundle pathForResource:@"Previous_simple" ofType:@"png"];
    CALayer * layer = [CALayer layer];
    layer.contents = (id)[UIImage imageNamed:filepath2].CGImage;
    layer.frame = CGRectMake(0, 0, 13, 20);
    layer.position = CGPointMake(10, barBtn.frame.size.height / 2);
    [barBtn.layer addSublayer:layer];
//    [barBtn setBackgroundImage:[UIImage imageNamed:filepath] forState:UIControlStateNormal];
//    [barBtn setImage:[UIImage imageNamed:filepath] forState:UIControlStateNormal];
    [barBtn addTarget:self action:@selector(didPopControllerSelected) forControlEvents:UIControlEventTouchDown];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:barBtn];
    
    UIButton* barBtn2 = [[UIButton alloc]initWithFrame:CGRectMake(13, 32, 30, 25)];
    [barBtn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [barBtn2 setTitle:@"完成" forState:UIControlStateNormal];
    [barBtn2 sizeToFit];
    [barBtn2 addTarget:self action:@selector(doneBtnSelected) forControlEvents:UIControlEventTouchDown];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:barBtn2];
    
    layer0 = [CALayer layer];
    layer0.borderWidth = 1.f;
    layer0.borderColor = [UIColor grayColor].CGColor;
    [self.view.layer addSublayer:layer0];
}

- (void)didPopControllerSelected {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLayoutSubviews {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    layer0.frame = CGRectMake(16, _reminderLabel.frame.origin.y - 10, width - 32, 1);
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
    
    [self resetFuncBtns];
}

- (NSInteger)vidateKidsCount {
    NSInteger result = 0;
    for (NSDictionary* dic in kids_changed) {
        if ([dic.allKeys containsObject:@"age"])
            ++result;
    }
    return result;
}

- (void)resetFuncBtns {
    
    if (current_index == kids_changed.count - 1) nextBtn.enabled = NO;
    else nextBtn.enabled = YES;
    
    if (current_index == 0) prevBtn.enabled = NO;
    else prevBtn.enabled = YES;
    
    if ([self vidateKidsCount] > 0) delectBtn.enabled = YES;
    else delectBtn.enabled = NO;
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
    NSMutableDictionary * dic_new = [[NSMutableDictionary alloc]initWithCapacity:5];
    [kids_changed addObject:dic_new];
    
    [_queryView reloadData];
    [self changeCurrentIndex:kids_changed.count -1];
    [_queryView setContentOffset:CGPointMake(0, MAX(current_index * [CycleAddKidsCell preferredHeight], 0) - 64) animated:YES];
}

- (void)deleteKidsBtnSelected {
    [kids_changed removeObjectAtIndex:current_index];
    [_queryView reloadData];
    [self changeCurrentIndex:MIN(current_index + 1, kids_changed.count - 1)];
    [_queryView setContentOffset:CGPointMake(0, MAX(current_index * [CycleAddKidsCell preferredHeight], 0) - 64) animated:YES];
}

- (void)nextKidsBtnSelected {
    [self changeCurrentIndex:current_index + 1];
    [_queryView setContentOffset:CGPointMake(0, MAX(current_index * [CycleAddKidsCell preferredHeight], 0) - 64) animated:YES];
}

- (void)prevKidsBtnSelected {
    [self changeCurrentIndex:current_index - 1];
    [_queryView setContentOffset:CGPointMake(0, MAX(current_index * [CycleAddKidsCell preferredHeight], 0) - 64) animated:YES];
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
    return [CycleAddKidsCell preferredHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return [CycleAddKidsFooter preferredHeight];
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    CycleAddKidsFooter* footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"cycle add kids footer"];
    
    if (footer == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CycleAddKidsFooter" owner:self options:nil];
        footer = [nib objectAtIndex:0];
    }
   
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];

    if (addBtn == nil) {
        addBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        [addBtn setImage:[UIImage imageNamed:[resourceBundle pathForResource:@"Plus" ofType:@"png"]] forState:UIControlStateNormal];
        [addBtn addTarget:self action:@selector(addKidsBtnSelected) forControlEvents:UIControlEventTouchDown];
        
        addBtn.layer.borderWidth = 1.f;
        addBtn.layer.borderColor = [UIColor blueColor].CGColor;
        addBtn.layer.cornerRadius = 15.f;
        addBtn.clipsToBounds = YES;
    } else {
        [addBtn removeFromSuperview];
    }
    
    if (delectBtn == nil) {
        delectBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        [delectBtn setImage:[UIImage imageNamed:[resourceBundle pathForResource:@"Cancel_blue" ofType:@"png"]] forState:UIControlStateNormal];
        [delectBtn addTarget:self action:@selector(deleteKidsBtnSelected) forControlEvents:UIControlEventTouchDown];
        
        delectBtn.layer.borderWidth = 1.f;
        delectBtn.layer.borderColor = [UIColor blueColor].CGColor;
        delectBtn.layer.cornerRadius = 15.f;
        delectBtn.clipsToBounds = YES;
    } else {
        [delectBtn removeFromSuperview];
    }
    
    if (nextBtn == nil) {
        nextBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        [nextBtn setImage:[UIImage imageNamed:[resourceBundle pathForResource:@"Next_blue" ofType:@"png"]] forState:UIControlStateNormal];
        [nextBtn addTarget:self action:@selector(nextKidsBtnSelected) forControlEvents:UIControlEventTouchDown];
        
        nextBtn.layer.borderWidth = 1.f;
        nextBtn.layer.borderColor = [UIColor blueColor].CGColor;
        nextBtn.layer.cornerRadius = 15.f;
        nextBtn.clipsToBounds = YES;
    } else {
        [nextBtn removeFromSuperview];
    }
    
    if (prevBtn == nil) {
        prevBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        [prevBtn setImage:[UIImage imageNamed:[resourceBundle pathForResource:@"Previous_blue" ofType:@"png"]] forState:UIControlStateNormal];
        [prevBtn addTarget:self action:@selector(prevKidsBtnSelected) forControlEvents:UIControlEventTouchDown];
        
        prevBtn.layer.borderWidth = 1.f;
        prevBtn.layer.borderColor = [UIColor blueColor].CGColor;
        prevBtn.layer.cornerRadius = 15.f;
        prevBtn.clipsToBounds = YES;
    } else {
        [prevBtn removeFromSuperview];
    }
    
    [footer.containerView addSubview:addBtn];
    addBtn.center = CGPointMake(50, 22);

    [footer.containerView addSubview:delectBtn];
    delectBtn.center = CGPointMake(90, 22);
    
    [footer.containerView addSubview:nextBtn];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
//    nextBtn.center = CGPointMake(footer.frame.size.width - 40, 22);
    nextBtn.center = CGPointMake(width - 40, 22);
    
    [footer.containerView addSubview:prevBtn];
//    prevBtn.center = CGPointMake(footer.frame.size.width - 80, 22);
    prevBtn.center = CGPointMake(width - 80, 22);

    [self resetFuncBtns];
    
    return footer;
}

#pragma mark -- data soucr
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return kids_changed.count;
//  return kids_changed.count == 0 ? 1 : kids_changed.count;
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
