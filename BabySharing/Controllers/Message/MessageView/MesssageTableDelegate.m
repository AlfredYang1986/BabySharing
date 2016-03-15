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
#import "LoginModel.h"
#import "Targets.h"
#import "Messages.h"
#import "MessageNotificationCell.h"

#import "GotyeOCChatTarget.h"
#import "RemoteInstance.h"
#import "ModelDefines.h"

#import "GotyeOCAPI.h"

@implementation MesssageTableDelegate {
    BOOL isLoading;
}

@synthesize queryView = _queryView;
@synthesize current = _current;
@synthesize mm = _mm;
@synthesize lm = _lm;

#pragma mark -- table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"selet row");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    [self performSegueWithIdentifier:@"HomeDetailSegue" sender:indexPath];
    
    //    QueryContent* cur = [_qm.querydata objectAtIndex:indexPath.row - 1];
    //    [self performSegueWithIdentifier:@"HomeDetailSegue" sender:cur];
    if (indexPath.row == 0) {
        [_current performSegueWithIdentifier:@"showNotifications" sender:nil];
    } else {
        [_current performSegueWithIdentifier:@"startChat" sender:indexPath];
    }
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
//-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return @"删除";
//}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0) {

    NSMutableArray* arr = [[NSMutableArray alloc]init];
    UITableViewRowAction * act = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"清除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [tableView.dataSource tableView:tableView commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:indexPath];
    }];
    act.backgroundColor = [UIColor colorWithRed:0.3126 green:0.7529 blue:0.6941 alpha:1.f];
    [arr addObject:act];
    
    return [arr copy];
}


/*删除用到的函数*/
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete && indexPath.row > 0) {
        NSLog(@"delete one row");
        GotyeOCChatTarget* gotTarget = [_mm getTargetByIndex:indexPath.row - 1];
        [GotyeOCAPI deleteSession:gotTarget alsoRemoveMessages:YES];
        [tableView reloadData];
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
            [cell setBadgeValue:[NSString stringWithFormat:@"%ld", (long)unread_count]];
        }
        
        return cell;
        
    } else {
        MessageViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Message View Cell"];
        
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MessageViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
   
        GotyeOCChatTarget* gotTarget = [_mm getTargetByIndex:indexPath.row - 1];
        Targets* tmp = [_mm enumAllTargetWithTargetID:gotTarget.name];
        if (tmp != nil) {
            [cell setUserImage:tmp.target_photo];
            cell.nickNameLabel.text = tmp.target_name;
            cell.messageLabel.text = [_mm getLastestMessageWith:gotTarget];
            cell.dateLabel.text = [_mm getLastestMessageDateWith:gotTarget];
        } else {
            dispatch_queue_t up = dispatch_queue_create("Get Profile Details", nil);
            dispatch_async(up, ^{
                
                NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
//                [dic setValue:_lm.current_auth_token forKey:@"query_auth_token"];
//                [dic setValue:_lm.current_user_id forKey:@"query_user_id"];
                [dic setValue:_lm.current_auth_token forKey:@"auth_token"];
                [dic setValue:_lm.current_user_id forKey:@"user_id"];
                [dic setValue:gotTarget.name forKey:@"owner_user_id"];
                
                NSError * error = nil;
                NSData* jsonData =[NSJSONSerialization dataWithJSONObject:[dic copy] options:NSJSONWritingPrettyPrinted error:&error];
                
                NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:[PROFILE_HOST_DOMAIN stringByAppendingString:PROFILE_QUERY_DETAILS]]];
                
                if ([[result objectForKey:@"status"] isEqualToString:@"ok"]) {
                    NSDictionary* dic_profile_details = [result objectForKey:@"result"];
                    Targets* t = [_mm addTarget:dic_profile_details];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [cell setUserImage:t.target_photo];
                        cell.nickNameLabel.text = t.target_name;
                        cell.messageLabel.text = [_mm getLastestMessageWith:gotTarget];
                        cell.dateLabel.text = [_mm getLastestMessageDateWith:gotTarget];
                    });
                    
                } else {
                    NSDictionary* reError = [result objectForKey:@"error"];
                    NSString* msg = [reError objectForKey:@"message"];
                    
                    NSLog(@"query user profile failed");
                    NSLog(@"%@", msg);
                }
            });
        }
        
        
        NSInteger unread_count = [_mm getUnreadMessageCount:gotTarget];
        if (unread_count > 0) {
            [cell setBadgeValue:[NSString stringWithFormat:@"%ld", unread_count]];
        }

        
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        formatter.formatterBehavior = NSDateFormatterBehavior10_4;
//        formatter.dateStyle = NSDateFormatterShortStyle;
//        formatter.timeStyle = NSDateFormatterShortStyle;
//        NSString *result = [formatter stringForObjectValue:tmp.last_time];
//        cell.dateLabel.text = result;
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1 + [_mm getMesssageSessionCount];
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
