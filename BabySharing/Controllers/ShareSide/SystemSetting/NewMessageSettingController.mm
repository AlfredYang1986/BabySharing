//
//  NewMessageSettingController.m
//  BabySharing
//
//  Created by Alfred Yang on 3/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "NewMessageSettingController.h"
#include <vector>
#import "AppDelegate.h"
#import "SystemSettingModel.h"

@interface value_helper : NSObject 
@property (nonatomic, strong) NSNumber* val;
@end

@implementation value_helper
@synthesize val = _val;
@end

@interface NewMessageSettingController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *queryView;
@property (weak, nonatomic) SystemSettingModel* sm;
@end

@implementation NewMessageSettingController {
    NSArray* titles;
    NSArray* titles_cn;
    std::vector<SEL> titles_func;
    
    std::vector<SEL> titles_value;
}

@synthesize queryView = _queryView;
@synthesize sm = _sm;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    _sm = app.sm;
    
    _queryView.delegate = self;
    _queryView.dataSource = self;
    
    titles = @[@"mode_science", @"mode_voice", @"mode_viber", @"notify_cycle", @"notify_p2p", @"notify_notification", @"notify_dongda"];
    titles_cn = @[@"安静模式", @"声音", @"震动", @"圈子消息通知", @"私聊消息通知", @"互动消息通知", @"咚嗒提醒通知"];
    
    titles_func.push_back(@selector(mode_science:));
    titles_func.push_back(@selector(mode_voice:));
    titles_func.push_back(@selector(mode_viber:));
    titles_func.push_back(@selector(notify_cycle:));
    titles_func.push_back(@selector(notify_p2p:));
    titles_func.push_back(@selector(notify_notification:));
    titles_func.push_back(@selector(notify_dongda:));
    
    titles_value.push_back(@selector(get_mode_science:));
    titles_value.push_back(@selector(get_mode_voice:));
    titles_value.push_back(@selector(get_mode_viber:));
    titles_value.push_back(@selector(get_notify_cycle:));
    titles_value.push_back(@selector(get_notify_p2p:));
    titles_value.push_back(@selector(get_notify_notification:));
    titles_value.push_back(@selector(get_notify_dongda:));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- getting gunc
- (void)get_mode_science:(value_helper*)val {
    val.val = [NSNumber numberWithBool:[_sm isModeSilenceOn]];
}

- (void)get_mode_voice:(value_helper*)val {
    val.val = [NSNumber numberWithBool:[_sm isModeVoiceOn]];
}

- (void)get_mode_viber:(value_helper*)val {
    val.val = [NSNumber numberWithBool:[_sm isModeViberOn]];
}

- (void)get_notify_cycle:(value_helper*)val {
    val.val = [NSNumber numberWithBool:[_sm isNotifyCycleOn]];
}

- (void)get_notify_p2p:(value_helper*)val {
    val.val = [NSNumber numberWithBool:[_sm isNotifyP2POn]];
}

- (void)get_notify_notification:(value_helper*)val {
    val.val = [NSNumber numberWithBool:[_sm isNotifyNotificationOn]];
}

- (void)get_notify_dongda:(value_helper*)val {
    val.val = [NSNumber numberWithBool:[_sm isNotifyDongDaOn]];
}

#pragma mark -- setting func
- (void)mode_science:(NSNumber*)b {
    [_sm resetModeSilence:b.boolValue];
}

- (void)mode_voice:(NSNumber*)b {
    [_sm resetModeVoice:b.boolValue];
}

- (void)mode_viber:(NSNumber*)b {
    [_sm resetModeViber:b.boolValue];
}

- (void)notify_cycle:(NSNumber*)b {
    [_sm resetNotifyCycle:b.boolValue];
}

- (void)notify_p2p:(NSNumber*)b {
    [_sm resetNotifyP2P:b.boolValue];
}

- (void)notify_notification:(NSNumber*)b {
    [_sm resetNotifyNotification:b.boolValue];
}

- (void)notify_dongda:(NSNumber*)b {
    [_sm resetNotifyDongDa:b.boolValue];
}

- (void)switchValueChanged:(UISwitch*)sw {
    [self performSelector:titles_func[sw.tag] withObject:[NSNumber numberWithBool:sw.on]];
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
    return 2;
}

#pragma mark -- table data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) return 3;
    else return  4;
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
    } else {
        index = 3 + indexPath.row;
        cell.textLabel.text = [titles_cn objectAtIndex:3 + indexPath.row];
    }
 
    // there is a bug when more items
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
   
    UISwitch* sw = [[UISwitch alloc]initWithFrame:CGRectMake(width - 51 - 16, 6, 51, 31)];
    sw.tag = index;
    [sw setOn:[self getCurrentSettingAtIndex:indexPath]];
    [cell addSubview:sw];
    [sw addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];

    return cell;
}

- (BOOL)getCurrentSettingAtIndex:(NSIndexPath*)indexPath {
    
    NSInteger index = 0;
    if (indexPath.section == 0) {
        index = indexPath.row;
    } else {
        index = 3 + indexPath.row;
    }
  
    value_helper* result = [[value_helper alloc]init];
    [self performSelector:titles_value[index] withObject:result];
    return result.val.boolValue;
}
@end
