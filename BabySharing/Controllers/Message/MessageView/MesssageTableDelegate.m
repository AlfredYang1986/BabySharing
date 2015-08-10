//
//  MesssageTableDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 4/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "MesssageTableDelegate.h"
#import "messageViewCell.h"

#import "UIBadgeView.h"
#import "MessageModel.h"
#import "Targets.h"
#import "Messages.h"
#import "MessageNotificationCell.h"

@implementation MesssageTableDelegate {
    BOOL isLoading;
    
    NSArray* queryTargetData;
}

@synthesize queryView = _queryView;
@synthesize current = _current;
@synthesize mm = _mm;

- (void)resetTableData {
    queryTargetData = [_mm enumAllTargets];
}

#pragma mark -- table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"selet row");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    [self performSegueWithIdentifier:@"HomeDetailSegue" sender:indexPath];
    
    //    QueryContent* cur = [_qm.querydata objectAtIndex:indexPath.row - 1];
    //    [self performSegueWithIdentifier:@"HomeDetailSegue" sender:cur];
    [_current performSegueWithIdentifier:@"showNotifications" sender:nil];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [MessageViewCell getPreferredHeight];
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
   
    if (indexPath.row == 0) {
        
        MessageNotificationCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Notificaton View Cell"];
        
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MessageNotificationCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
      
        NSInteger unread_count = [_mm unReadNotificationCount];
        if (unread_count > 0) {
            [cell setBadgeValue:[NSString stringWithFormat:@"%d", unread_count]];
        }
        
        return cell;
        
    } else {
        MessageViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Message View Cell"];
        
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MessageViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
   
        Targets* tmp = [queryTargetData objectAtIndex:indexPath.row - 1];
        [cell setUserImage:tmp.target_photo];
        cell.nickNameLabel.text = tmp.target_name;
        cell.messageLabel.text = ((Messages*)tmp.messages.allObjects.lastObject).message_content;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.formatterBehavior = NSDateFormatterBehavior10_4;
        formatter.dateStyle = NSDateFormatterShortStyle;
        formatter.timeStyle = NSDateFormatterShortStyle;
        NSString *result = [formatter stringForObjectValue:tmp.last_time];
        cell.dateLabel.text = result;
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1 + queryTargetData.count;
}

#pragma mark -- scroll refresh
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 假设偏移表格高度的20%进行刷新
    if (!isLoading) { // 判断是否处于刷新状态，刷新中就不执行
        // 取内容的高度：
        // 如果内容高度大于UITableView高度，就取TableView高度
        // 如果内容高度小于UITableView高度，就取内容的实际高度
        float height = scrollView.contentSize.height > _queryView.frame.size.height ?_queryView.frame.size.height : scrollView.contentSize.height;
        
        if ((height - scrollView.contentSize.height + scrollView.contentOffset.y) / height > 0.2) { // 调用上拉刷新方
            //            CGRect rc = _queryView.frame;
            //            rc.origin.y = rc.origin.y - 44;
            //            [_queryView setFrame:rc];
            //            rc.origin.y = rc.origin.y + 44;
            //            [_queryView setFrame:rc];
            //            [_queryView reloadData];
            return;
            
        } else if (- scrollView.contentOffset.y / _queryView.frame.size.height > 0.2) { // 调用下拉刷新方法
            //            CGRect rc = _queryView.frame;
            //            rc.origin.y = rc.origin.y + 44;
            //            [_queryView setFrame:rc];
            //            rc.origin.y = rc.origin.y - 44;
            //            [_queryView setFrame:rc];
            //            [_queryView reloadData];
            
            return;
        }
        
        
        // move and change
    }
    
}
@end
