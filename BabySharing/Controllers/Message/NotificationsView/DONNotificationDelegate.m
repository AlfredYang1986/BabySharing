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
#import "MessageNotificationDetailCell.h"
#import "Notifications.h"

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
    return YES;
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
@end
