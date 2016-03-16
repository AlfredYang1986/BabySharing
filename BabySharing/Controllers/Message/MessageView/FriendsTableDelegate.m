//
//  FriendsTableDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 4/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "FriendsTableDelegate.h"
#import "AppDelegate.h"
#import "LoginModel.h"
#import "ConnectionModel.h"
#import "TmpFileStorageModel.h"

#import "PersonalCentreTmpViewController.h"
#import "PersonalCentreOthersDelegate.h"
#import "MessageFriendsCell.h"

@interface FriendsTableDelegate () <MessageFriendsCellDelegate>
@property (nonatomic, weak, readonly) LoginModel* lm;
@property (nonatomic, weak, readonly) ConnectionModel* cm;
@end

@implementation FriendsTableDelegate {
    BOOL isLoading;
    
    NSMutableArray* data_arr;
    NSArray* data_origin;
}

@synthesize queryView = _queryView;
@synthesize lm = _lm;
@synthesize cm = _cm;

- (id)init {
    self = [super init];
    if (self) {
        AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
        _lm = app.lm;
        _cm = app.cm;
    }
    return self;
}

#pragma mark -- table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"selet row");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PersonalCentreTmpViewController* pc = [storyboard instantiateViewControllerWithIdentifier:@"PersonalCenter"];
    PersonalCentreOthersDelegate* delegate = [[PersonalCentreOthersDelegate alloc]init];
    pc.current_delegate = delegate;
    pc.isPushed = YES;
    NSDictionary* tmp = [data_arr objectAtIndex:indexPath.row];
    pc.owner_id = [tmp objectForKey:@"user_id"];
    [self.current.navigationController pushViewController:pc animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [MessageFriendsCell preferredHeight];
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
    
    MessageFriendsCell* cell = [tableView dequeueReusableCellWithIdentifier:@"friend cell"];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MessageFriendsCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSDictionary* tmp = [data_arr objectAtIndex:indexPath.row];
    cell.delegate = self;
    cell.user_id = [tmp objectForKey:@"user_id"];
    [cell setUserScreenPhoto:[tmp objectForKey:@"screen_photo"]];
    [cell setRelationship:((NSNumber*)[tmp objectForKey:@"relations"]).integerValue];
    [cell setUserScreenName:[tmp objectForKey:@"screen_name"]];
    [cell setUserRoleTag:[tmp objectForKey:@"role_tag"]];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return data_arr.count;
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

#pragma mark -- refresh user list
/**
 * user_lst is object, need to change it to string list
 */
- (void)refreshShowingListWithUserList:(NSArray*)user_lst {
    NSMutableArray* ma = [[NSMutableArray alloc]initWithCapacity:user_lst.count];
    for (NSManagedObject* iter in user_lst) {
        [ma addObject:[iter valueForKey:@"user_id"]];
    }
    data_origin = [_lm querMultipleProlfiles:[ma copy]];
    data_arr = [data_origin mutableCopy];
    NSLog(@"%@", data_arr);
    [_queryView reloadData];
}

- (void)filterDataWithPredicate:(NSPredicate*)pred {
  
    if (data_arr == nil) {
        data_arr = [[NSMutableArray alloc]initWithCapacity:data_origin.count];
    }
    
    [data_arr removeAllObjects];
 
    for (NSDictionary* tmp in data_origin) {
        if ([pred evaluateWithObject:[tmp objectForKey:@"screen_name"]]) {
            [data_arr addObject:tmp];
        }
    }
    NSLog(@"%@", data_arr);
    [_queryView reloadData];
}

- (BOOL)changeArrWithUserID:(NSString*)user_id andConnections:(UserPostOwnerConnections)new_connections {
    NSPredicate* p = [NSPredicate predicateWithBlock:^BOOL(id  _Nonnull evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        NSDictionary* iter = (NSDictionary*)evaluatedObject;
        return ![[iter objectForKey:@"user_id"] isEqualToString:user_id];
    }];
    
    data_origin = [data_origin filteredArrayUsingPredicate:p];
    data_arr = [data_origin mutableCopy];
    return YES;
}

#pragma mark -- Message friend cell delegate
- (void)didSelectedScreenPhoto:(NSString*)user_id {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PersonalCentreTmpViewController* pc = [storyboard instantiateViewControllerWithIdentifier:@"PersonalCenter"];
    PersonalCentreOthersDelegate* delegate = [[PersonalCentreOthersDelegate alloc]init];
    pc.current_delegate = delegate;
    pc.owner_id = user_id;
    pc.isPushed = YES;
    [_current.navigationController setNavigationBarHidden:NO];
    [_current.navigationController pushViewController:pc animated:YES];
}

- (void)didSelectedRelationBtn:(NSString*)user_id andCurrentRelation:(UserPostOwnerConnections)connections {
    NSLog(@"follow button selected");
    
    NSString* follow_user_id = user_id;
    NSNumber* relations = [NSNumber numberWithInteger:connections];
    
    switch (relations.integerValue) {
        case UserPostOwnerConnectionsSamePerson:
            // my own post, do nothing
            break;
        case UserPostOwnerConnectionsNone:
        case UserPostOwnerConnectionsFollowed: {
            [_cm followOneUser:follow_user_id withFinishBlock:^(BOOL success, NSString *message, UserPostOwnerConnections new_connections) {
                if (success && [self changeArrWithUserID:follow_user_id andConnections:new_connections]) {
                    NSLog(@"follow success");
                    [_queryView reloadData];
                    
                } else {
                    NSLog(@"follow error, %@", message);
                }
            }];}
            break;
        case UserPostOwnerConnectionsFollowing:
        case UserPostOwnerConnectionsFriends: {
            [_cm unfollowOneUser:follow_user_id withFinishBlock:^(BOOL success, NSString *message, UserPostOwnerConnections new_connections) {
                if (success && [self changeArrWithUserID:follow_user_id andConnections:new_connections]) {
                    NSLog(@"unfollow success");
                    [_queryView reloadData];
                    
                } else {
                    NSLog(@"follow error, %@", message);
                }
            }];}
            break;
        default:
            break;
    }
}
@end
