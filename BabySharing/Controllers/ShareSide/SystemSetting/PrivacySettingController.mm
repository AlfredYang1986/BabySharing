//
//  PrivacySettingController.m
//  BabySharing
//
//  Created by Alfred Yang on 30/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "PrivacySettingController.h"
#include <vector>

@interface PrivacySettingController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *queryView;

@end

@implementation PrivacySettingController {
    NSArray* titles;
    NSArray* titles_cn;
    std::vector<SEL> titles_func;
}

@synthesize queryView = _queryView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    titles = @[@"language", @"fileLocalSave", @"fileCanBeSaved", @"allowAccessMyProfileViaAddressBook", @"onlyAllowFriendsP2PChat", @"allowHorocropeRecommend", @"allowKidsRecommend"];
    titles_cn = @[@"语言设置", @"保存照片到本地", @"允许其他人保存我的照片", @"允许通过手机通讯录加我为好友", @"只允许互相关注的人和我私聊", @"允许使用星座作为推荐条件", @"允许使用孩子信息昨天推荐条件"];
    
    titles_func.push_back(@selector(doNothing:));
    titles_func.push_back(@selector(fileLocalSave:));
    titles_func.push_back(@selector(fileCanBeSaved:));
    titles_func.push_back(@selector(allowAccessMyProfileViaAddressBook:));
    titles_func.push_back(@selector(onlyAllowFriendsP2PChat:));
    titles_func.push_back(@selector(allowHoroscorpeRecommend:));
    titles_func.push_back(@selector(allowKidsRecommend:));
    
    _queryView.scrollEnabled = NO;
    _queryView.delegate = self;
    _queryView.dataSource = self;
    
    UILabel* label = [[UILabel alloc]init];
    label.text = @"隐私&偏好";
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
}

- (void)didPopControllerSelected {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)switchValueChanged:(UISwitch*)sw {
    [self performSelector:titles_func[sw.tag] withObject:[NSNumber numberWithBool:sw.on]];
}

- (void)doNothing:(NSNumber*)b {
    NSLog(@"do nothing");
}

- (void)fileLocalSave:(NSNumber*)b {
    NSLog(@"file local save %@", b);
}

- (void)fileCanBeSaved:(NSNumber*)b {
    NSLog(@"file can be saved %@", b);
}

- (void)allowAccessMyProfileViaAddressBook:(NSNumber*)b {
    NSLog(@"allow access my profile via address book %@", b);
}

- (void)onlyAllowFriendsP2PChat:(NSNumber*)b {
    NSLog(@"only allow friends p22p chat %@", b);
}

- (void)allowHoroscorpeRecommend:(NSNumber*)b {
    NSLog(@"allow horsocorpe recommend %@", b);
}

- (void)allowKidsRecommend:(NSNumber*)b {
    NSLog(@"allow kids info recommend %@", b);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -- table delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

#pragma mark -- table data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) return 3;
    else if (section == 1) return  2;
    else return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"default"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"default"];
    }
   
    NSInteger index = -1;
    if (indexPath.section == 0) {
        index = indexPath.row;
        cell.textLabel.text = [titles_cn objectAtIndex:indexPath.row];
    } else if (indexPath.section == 1){
        index = 3 + indexPath.row;
        cell.textLabel.text = [titles_cn objectAtIndex:3 + indexPath.row];
    } else {
        index = 5 + indexPath.row;
        cell.textLabel.text = [titles_cn objectAtIndex:5 + indexPath.row];
    }
 
    // there is a bug when more items
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
  
    if (!(indexPath.section == 0 && indexPath.row == 0)) {
        UISwitch* sw = [[UISwitch alloc]initWithFrame:CGRectMake(width - 51 - 16, 6, 51, 31)];
        sw.tag = index;
        [cell addSubview:sw];
        [sw addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    
    cell.textLabel.textColor = [UIColor grayColor];
    
    return cell;
}
@end
