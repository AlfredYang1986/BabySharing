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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    data = @[@"个人信息", @"", @"新消息通知", @"隐私偏好", @"", @"去评分", @"对话咚哒团队",@"关于咚哒", @"", @"清除缓存", @"退出登录"];
    functions.push_back(@selector(personalSelected));
    functions.push_back(nil);
    functions.push_back(@selector(newMessageSettingSelected));
    functions.push_back(@selector(privateSettingSelected));
    functions.push_back(nil);
    functions.push_back(@selector(votedSelected));
    functions.push_back(@selector(contactUsSelected));
    functions.push_back(@selector(aboutUsSelected));
    functions.push_back(nil);
    functions.push_back(@selector(clearTmpStorageSelectd));
    functions.push_back(@selector(signOutSelected));
    
    _queryView.scrollEnabled = NO;
    [_queryView setSeparatorColor:[UIColor clearColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
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
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"default"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"default"];
    }
    
    cell.textLabel.text = [data objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if ([cell.textLabel.text isEqualToString:@"退出登录"]) {
        cell.backgroundColor = [UIColor redColor];
        
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"退出登录"];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,str.length)];
        cell.textLabel.attributedText = str;
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else if ([cell.textLabel.text isEqualToString:@""]) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else if ([cell.textLabel.text isEqualToString:@"清除缓存"]) {
        cell.textLabel.text = [cell.textLabel.text stringByAppendingString:[NSString stringWithFormat:@"(%.2fM)", [TmpFileStorageModel tmpFileStorageSize]]];
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
