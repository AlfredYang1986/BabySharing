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
//@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UITableView *settingView;

@end

@implementation AboutViewController {
    NSArray* titles;
}

@synthesize logoImg = _logoImg;
//@synthesize versionLabel = _versionLabel;
@synthesize settingView = _settingView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    titles = @[@"用户协议", @"隐私政策", @"版本更新介绍"];
//    titles = @[@"用户协议", @"隐私政策"];
    titles = @[@"用户协议"];

    UIButton* barBtn = [[UIButton alloc]initWithFrame:CGRectMake(13, 32, 30, 25)];
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    _logoImg.image = [UIImage imageNamed:[resourceBundle pathForResource:@"profile_about_dongda" ofType:@"png"]];
//    _logoImg.layer.cornerRadius = 8.f;
//    _logoImg.clipsToBounds = YES;
    
    _settingView.scrollEnabled = NO;
    _settingView.delegate = self;
    _settingView.dataSource = self;
   
//    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    _versionLabel.text = [app.sm getCurrentVersion];

    UILabel* label = [[UILabel alloc]init];
    label.text = @"关于咚哒";
    label.textColor = [UIColor colorWithWhite:0.5922 alpha:1.f];
    label.font = [UIFont systemFontOfSize:20.f];
    [label sizeToFit];
    self.navigationItem.titleView = label;

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
    
    CALayer* line = [CALayer layer];
    line.borderWidth = 1.f;
    line.borderColor = [UIColor colorWithWhite:0.5922 alpha:0.10].CGColor;
    line.frame = CGRectMake(0, 73, [UIScreen mainScreen].bounds.size.width, 1);
    [self.view.layer addSublayer:line];
    
    _settingView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    return [titles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"default"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"default"];
    }
    
    cell.textLabel.text = [titles objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.textColor = [UIColor colorWithWhite:0.3059 alpha:1.f];
    
    CALayer* line = [CALayer layer];
    line.borderWidth = 1.f;
    line.borderColor = [UIColor colorWithWhite:0.5922 alpha:0.10].CGColor;
    line.frame = CGRectMake(8, 44 - 1, tableView.frame.size.width, 1);
    [cell.layer addSublayer:line];
    
    return cell;
}
@end
