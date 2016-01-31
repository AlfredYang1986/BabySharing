//
//  ChatGroupUserInfoTableDelegateAndDatasource.m
//  BabySharing
//
//  Created by Alfred Yang on 1/28/16.
//  Copyright © 2016 BM. All rights reserved.
//

#import "ChatGroupUserInfoTableDelegateAndDatasource.h"
#import "MessageFriendsCell.h"
#import "MessageChatGroupInfoCell.h"

@implementation ChatGroupUserInfoTableDelegateAndDatasource

@synthesize delegate = _delegate;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
//        return [MessageFriendsCell preferredHeight];
        return 55;
    } else {
        return [MessageChatGroupInfoCell preferredHeight];
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0) {
        
        MessageFriendsCell* cell = [tableView dequeueReusableCellWithIdentifier:@"user info header"];
        
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MessageFriendsCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        [cell setUserScreenPhoto:[_delegate getFounderScreenPhoto]];
        [cell setRelationship:[_delegate getFounderRelations]];
        [cell setUserScreenName:[_delegate getFounderScreenName]];
        [cell setUserRoleTag:[_delegate getFounderRoleTag]];
      
        cell.cellHeight = 55.f;
        cell.lineMargin = 10.f;
        cell.backgroundColor = [UIColor clearColor];
        return cell;
        
    } else {
   
        MessageChatGroupInfoCell* cell = [tableView dequeueReusableCellWithIdentifier:@"user info cell"];
        
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MessageChatGroupInfoCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        [cell setChatGroupJoinerNumber:[_delegate getGroupJoinNumber]];
        [cell setChatGroupUserList:[_delegate getGroupJoinNumberList]];
      
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
}

- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
