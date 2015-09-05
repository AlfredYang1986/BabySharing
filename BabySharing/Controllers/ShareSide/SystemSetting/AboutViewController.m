//
//  AboutViewController.m
//  BabySharing
//
//  Created by Alfred Yang on 30/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "AboutViewController.h"
#import "UserPrivacyController.h"
#import "AppDelegate.h"
#import "SystemSettingModel.h"

@interface AboutViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *logoImg;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UITableView *settingView;

@end

@implementation AboutViewController {
    NSArray* titles;
}

@synthesize logoImg = _logoImg;
@synthesize versionLabel = _versionLabel;
@synthesize settingView = _settingView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    titles = @[@"用户协议", @"隐私政策", @"版本更新介绍"];
   
    _logoImg.image = [UIImage imageNamed:@"icon.png"];
    _logoImg.layer.cornerRadius = 8.f;
    _logoImg.clipsToBounds = YES;
    
    _settingView.scrollEnabled = NO;
    _settingView.delegate = self;
    _settingView.dataSource = self;
   
    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    _versionLabel.text = [app.sm getCurrentVersion];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"VersionChanges"]) {
        
    }
}

#pragma mark -- table delegate
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"selet row");
    if (indexPath.row == 0) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UserPrivacyController* pri = [storyboard instantiateViewControllerWithIdentifier:@"UserPrivacy"];
        [self.navigationController pushViewController:pri animated:YES];

    } else if (indexPath.row == 1) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UserPrivacyController* pri = [storyboard instantiateViewControllerWithIdentifier:@"UserPrivacy"];
        [self.navigationController pushViewController:pri animated:YES];
        
    } else {
        [self performSegueWithIdentifier:@"VersionChanges" sender:nil];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -- table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"default"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"default"];
    }
    
    cell.textLabel.text = [titles objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}
@end
