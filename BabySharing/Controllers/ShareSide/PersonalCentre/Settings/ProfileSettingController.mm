//
//  PrfileSettingController.m
//  BabySharing
//
//  Created by Alfred Yang on 3/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "ProfileSettingController.h"
#include <vector>
#import "TmpFileStorageModel.h"
#import "PersonalSettingController.h"
#import "OBShapedButton.h"

@interface SettingCell : UITableViewCell

@property (nonatomic, strong) UILabel *label;

@end

@implementation SettingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.label = [[UILabel alloc]init];
        self.label.textColor = [UIColor colorWithWhite:0.3059 alpha:1.f];
        self.label.font = [UIFont systemFontOfSize:14.f];
        [self addSubview:self.label];
    }
    return self;
}

@end


@interface ProfileSettingController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *queryView;
@end

@implementation ProfileSettingController {
    NSArray* data;
    std::vector<SEL> functions;
}

@synthesize queryView = _queryView;
@synthesize current_auth_token = _current_auth_token;
@synthesize current_user_id = _current_user_id;
@synthesize dic_profile_details = _dic_profile_details;
@synthesize delegate = _delegate;

#define SCREEN_WIDTH                [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT               [UIScreen mainScreen].bounds.size.height

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
//    data = @[@"个人信息", @"", @"新消息通知", @"隐私&偏好", @"", @"去评分", @"对话咚哒团队",@"关于咚哒", @"", @"清除缓存", @"退出登录"];
//    data = @[@"个人信息", @"",  @"去评分", @"对话咚哒团队",@"关于咚哒", @"", @"", @"", @"", @"清除缓存", @"退出登录"];
    data = @[@"去评分", @"关于咚哒", @"清除缓存"];
//    functions.push_back(@selector(personalSelected));
//    functions.push_back(nil);
//    functions.push_back(@selector(newMessageSettingSelected));
//    functions.push_back(@selector(privateSettingSelected));
//    functions.push_back(nil);
    functions.push_back(@selector(votedSelected));
//    functions.push_back(@selector(contactUsSelected));
    functions.push_back(@selector(aboutUsSelected));
//    functions.push_back(nil);
//    functions.push_back(nil);
//    functions.push_back(nil);
//    functions.push_back(nil);
    functions.push_back(@selector(clearTmpStorageSelectd));
//    functions.push_back(@selector(signOutSelected));
    
    _queryView.scrollEnabled = NO;
    [_queryView setSeparatorColor:[UIColor clearColor]];
    
    UILabel* label = [[UILabel alloc]init];
    label.text = @"设置";
    label.textColor = [UIColor colorWithWhite:0.3059 alpha:1.f];
    label.font = [UIFont systemFontOfSize:18.f];
    [label sizeToFit];
    self.navigationItem.titleView = label;
   
    UIButton* barBtn = [[UIButton alloc]initWithFrame:CGRectMake(13, 32, 30, 25)];
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
//    NSString* filepath = [resourceBundle pathForResource:@"Previous_blue" ofType:@"png"];
    NSString* filepath = [resourceBundle pathForResource:@"dongda_back" ofType:@"png"];
    CALayer * layer = [CALayer layer];
    layer.contents = (id)[UIImage imageNamed:filepath].CGImage;
    layer.frame = CGRectMake(-7, 0, 25, 25);
//    layer.position = CGPointMake(10, barBtn.frame.size.height / 2);
    [barBtn.layer addSublayer:layer];
//    [barBtn setBackgroundImage:[UIImage imageNamed:filepath] forState:UIControlStateNormal];
//    [barBtn setImage:[UIImage imageNamed:filepath] forState:UIControlStateNormal];
    [barBtn addTarget:self action:@selector(didPopControllerSelected) forControlEvents:UIControlEventTouchDown];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:barBtn];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.9490 alpha:1.f];
    _queryView.backgroundColor = [UIColor whiteColor];
    
    CALayer* line = [CALayer layer];
    line.borderColor = [UIColor colorWithWhite:0.5922 alpha:0.10].CGColor;
    line.borderWidth = 1.f;
    line.frame = CGRectMake(0, 73, [UIScreen mainScreen].bounds.size.width, 1);
    [self.view.layer addSublayer:line];
    
    /******************************************************************************************************************************/
    // log out btn
    OBShapedButton* logout_btn = [[OBShapedButton alloc]initWithFrame:CGRectMake(17.5, SCREEN_HEIGHT - 17.5 - 44 - 74, SCREEN_WIDTH - 2 * 17.5, 44)];
    [logout_btn setBackgroundImage:[UIImage imageNamed:[resourceBundle pathForResource:@"profile_logout_btn_bg" ofType:@"png"]] forState:UIControlStateNormal];
    logout_btn.titleLabel.font = [UIFont systemFontOfSize:17.f];
    [logout_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logout_btn setTitle:@"退出登录" forState:UIControlStateNormal];
    [logout_btn addTarget:self action:@selector(signOutSelected) forControlEvents:UIControlEventTouchUpInside];
    [_queryView addSubview:logout_btn];
}

- (void)didPopControllerSelected {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark -- uitableview delegate
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath  {
    
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
   
    return ![cell.textLabel.text isEqualToString:@""];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSelector:functions[indexPath.row] withObject:nil];
}

#pragma mark -- uitableview datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SettingCell * cell = [tableView dequeueReusableCellWithIdentifier:@"default"];
    
    if (cell == nil) {
        cell = [[SettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"default"];
        CALayer* line = [CALayer layer];
        line.borderColor = [UIColor colorWithWhite:0.5922 alpha:0.20].CGColor;
        line.borderWidth = 1.f;
        line.frame = CGRectMake(8, 44 - 1, tableView.frame.size.width, 1);
        [cell.layer addSublayer:line];
    }

    cell.label.text = [data objectAtIndex:indexPath.row];
//    cell.label.center = CGPointMake(cell.label.frame.size.width / 2 + 8, 13);
    [cell.label sizeToFit];
    cell.label.frame = CGRectMake(10, (44 - CGRectGetHeight(cell.label.frame)) / 2, cell.label.frame.size.width, cell.label.frame.size.height);

    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
//    if ([cell.textLabel.text isEqualToString:@"退出登录"]) {
    if ([cell.label.text isEqualToString:@"退出登录"]) {
        
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"退出登录"];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,str.length)];
        cell.textLabel.attributedText = str;
        cell.accessoryType = UITableViewCellAccessoryNone;
//    } else if ([cell.textLabel.text isEqualToString:@""]) {
    } else if ([cell.label.text isEqualToString:@""]) {
        cell.accessoryType = UITableViewCellAccessoryNone;
//    } else if ([cell.textLabel.text isEqualToString:@"清除缓存"]) {
    } else if ([cell.label.text isEqualToString:@"清除缓存"]) {
//        cell.textLabel.text = [cell.textLabel.text stringByAppendingString:[NSString stringWithFormat:@"(%.2fM)", [TmpFileStorageModel tmpFileStorageSize]]];
        cell.label.text = [cell.label.text stringByAppendingString:[NSString stringWithFormat:@"(%.2fM)", [TmpFileStorageModel tmpFileStorageSize]]];
        [cell.label sizeToFit];
        cell.accessoryType = UITableViewCellAccessoryNone;
//        cell.textLabel.textColor = [UIColor colorWithRed:0.3126 green:0.7529 blue:0.6941 alpha:1.f];
    }
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PersonalSetting"]) {
        ((PersonalSettingController*)segue.destinationViewController).current_user_id = self.current_user_id;
        ((PersonalSettingController*)segue.destinationViewController).current_auth_token = self.current_auth_token;
        ((PersonalSettingController*)segue.destinationViewController).dic_profile_details = self.dic_profile_details;
        ((PersonalSettingController*)segue.destinationViewController).delegate = self.delegate;
    } else if ([segue.identifier isEqualToString:@"about"]) {
        
    } else if ([segue.identifier isEqualToString:@"newMessageSetting"]) {
        
    } else if ([segue.identifier isEqualToString:@"privacy"]) {
        
    }
}

#pragma mark -- functions
- (void)personalSelected {
    [self performSegueWithIdentifier:@"PersonalSetting" sender:nil];
}

- (void)newMessageSettingSelected {
    [self performSegueWithIdentifier:@"newMessageSetting" sender:nil];
}

- (void)privateSettingSelected {
    [self performSegueWithIdentifier:@"privacy" sender:nil];
}

- (void)votedSelected {
    
}

- (void)contactUsSelected {
    
}

- (void)aboutUsSelected {
    [self performSegueWithIdentifier:@"about" sender:nil];
}

- (void)signOutSelected {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"current user sign out" object:nil];
}

- (void)clearTmpStorageSelectd {
    NSLog(@"clear tmp storage selected");
    [TmpFileStorageModel deleteBMTmpImageDir];
    [TmpFileStorageModel deleteBMTmpMovieDir];
    [_queryView reloadData];
}
@end
