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
   
    NSArray* str_horoscrope;
    
    UISwitch* sw;
}

@synthesize queryView = _queryView;
@synthesize datePicker = _datePicker;

@synthesize delegate = _delegate;
//@synthesize dic_description = _dic_description;

@synthesize dob = _dob;
@synthesize age = _age;
@synthesize horoscrope = _horoscrope;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _queryView.delegate = self;
    _queryView.dataSource = self;
    _queryView.scrollEnabled = NO;
    [_queryView registerNib:[UINib nibWithNibName:@"CycleDescriptionCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cycle description cell"];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(doneBtnSelected)];
    
//    _datePicker.hidden = YES;
    _datePicker.datePickerMode = UIDatePickerModeDate;
    
    titles_cn = @[@"年龄", @"星座", @"允许使用星座作为推荐条件"];
    titles = @[@"age", @"horoscrope", @""];
    
    str_horoscrope = @[@"Aries", @"Taurus", @"Gemini", @"Cancer", @"Leo", @"Virgo", @"Libra", @"Scorpio", @"Sagittarius", @"Capricorn", @"Aquarius", @"Pisces"];
    
    [_datePicker addTarget:self action:@selector(dateValueChanged) forControlEvents:UIControlEventValueChanged];
    if (_dob) _datePicker.date = _dob;
    
    sw = [[UISwitch alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doneBtnSelected {
    [_delegate didChangeDOB:_datePicker.date andAge:_age andHoroscrope:_horoscrope];
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

    int tmp_age = [comps_2 year] - [comps year];
    int tmp_horoscrope = [self horoscropeWithMonth:[comps month] andDay:[comps day]];
    
    if (tmp_age != _age || tmp_horoscrope != _horoscrope) {
        [_queryView reloadData];
    }
    _age = tmp_age;
    _horoscrope = tmp_horoscrope;
}

- (Horoscrope)horoscropeWithMonth:(NSInteger)month andDay:(NSInteger)day {
    month = month < 3 ? 12 + month : month;
    int rel = day >= 20 ?  month - 3 : month - 4;
    return rel == -1 ? rel == 11 : rel;
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
    if (indexPath.section == 0 && indexPath.row == 0 && _age >= 0) {
        cell.descriptionLabel.text = [NSString stringWithFormat:@"%d", _age];
    } else if (indexPath.section == 0 && indexPath.row == 1 && (int)_horoscrope >= 0) {
        cell.descriptionLabel.text = [str_horoscrope objectAtIndex:_horoscrope];
    } else if (indexPath.section == 1) {
        [sw removeFromSuperview];
        [cell addSubview:sw];
        sw.center = CGPointMake(cell.center.x + cell.frame.size.width / 2 - sw.frame.size.width / 2 - 20, cell.center.y);
    }
    
    return cell;
}
@end
