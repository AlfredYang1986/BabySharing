//
//  DONNotificationDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 10/12/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import "DONNotificationDelegate.h"
#import "MessageModel.h"
#import "LoginModel.h"
#import "AppDelegate.h"
#import "EnumDefines.h"
#import "Notifications.h"
#import "PersonalCentreTmpViewController.h"
#import "PersonalCentreOthersDelegate.h"
#import "HomeViewController.h"
#import "UserHomeViewDataDelegate.h"

@interface DONNotificationDelegate ()
@property (nonatomic, weak) MessageModel* mm;
@property (nonatomic, weak) LoginModel* lm;
@end

@implementation DONNotificationDelegate {
    NSArray* queryData;
}

@synthesize mm = _mm;
@synthesize lm = _lm;
@synthesize queryView = _queryView;
@synthesize controller = _controller;

- (id)init {
    self = [super init];
    if (self) {
        [self setQueryData];
    }
   
    return self;
}

- (void)setQueryData {
    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    _mm = app.mm;
    _lm = app.lm;
    
    queryData = [_mm enumNotifications];
    [_mm markAllNotificationsAsReaded];
}

- (void)reloadData {
    queryData = [_mm enumNotifications];
}
#pragma mark -- table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"selet row");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    [self performSegueWithIdentifier:@"HomeDetailSegue" sender:indexPath];
    
    //    QueryContent* cur = [_qm.querydata objectAtIndex:indexPath.row - 1];
    //    [self performSegueWithIdentifier:@"HomeDetailSegue" sender:cur];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [MessageNotificationDetailCell preferedHeight];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

/*改变删除按钮的title*/
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

/*删除用到的函数*/
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSLog(@"delete one row");
    }
}

#pragma mark -- table view datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MessageNotificationDetailCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Notificaton Detail View Cell"];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MessageNotificationDetailCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    Notifications* tmp = [queryData objectAtIndex:indexPath.row];
 
    cell.delegate = self;
    cell.notification = tmp;
    [cell setUserImage:tmp.sender_screen_photo];
//    cell.detailView.text = [cell getActtionTmplate:tmp.type.integerValue];//, tmp.sender_screen_name];
//    cell.nameLabel.text = tmp.sender_screen_name;
    [cell setDetailTarget:tmp.sender_screen_name andActionType:tmp.type.integerValue andConnectContent:nil];
    [cell setTimeLabel:tmp.date];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return queryData.count;
}

#pragma mark --  notify delegate
- (void)didSelectedSender:(Notifications*)notify {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PersonalCentreTmpViewController* pc = [storyboard instantiateViewControllerWithIdentifier:@"PersonalCenter"];
    PersonalCentreOthersDelegate* delegate = [[PersonalCentreOthersDelegate alloc]init];
    pc.current_delegate = delegate;
    pc.owner_id = notify.sender_id;
    [self.controller.navigationController setNavigationBarHidden:NO];
    [self.controller.navigationController pushViewController:pc animated:YES];
}

- (void)didSelectedReceiver:(Notifications*)notify {
    
}

- (void)didselectedPostContent:(Notifications*)notify {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HomeViewController* hv = [storyboard instantiateViewControllerWithIdentifier:@"HomeView"];
    hv.isPushed = YES;
    hv.delegate = [[UserHomeViewDataDelegate alloc]init];
    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [hv.delegate pushExistingData:app.qm.querydata];
    [hv.delegate setSelectIndex:0];
    hv.nav_title = @"赞了";
    [self.controller.navigationController pushViewController:hv animated:YES];
}

- (void)didselectedRelationsBtn:(Notifications*)notify {
    NSLog(@"relations button pushed");
}
@end
