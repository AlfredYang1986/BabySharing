//
//  FriendsTableDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 4/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "FriendsTableDelegate.h"
#import "MessageViewCell.h"
#import "AppDelegate.h"
#import "LoginModel.h"
#import "TmpFileStorageModel.h"

#import "PersonalCentreTmpViewController.h"
#import "PersonalCentreOthersDelegate.h"
#import "MessageFriendsCell.h"

@interface FriendsTableDelegate ()
@property (nonatomic, weak, readonly) LoginModel* lm;
@end

@implementation FriendsTableDelegate {
    BOOL isLoading;
    
    NSMutableArray* data_arr;
    NSArray* data_origin;
}

@synthesize queryView = _queryView;
@synthesize lm = _lm;

- (id)init {
    self = [super init];
    if (self) {
        AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
        _lm = app.lm;
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
    NSDictionary* tmp = [data_arr objectAtIndex:indexPath.row];
    pc.owner_id = [tmp objectForKey:@"user_id"];
    [self.current.navigationController pushViewController:pc animated:YES];
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
    
    MessageFriendsCell* cell = [tableView dequeueReusableCellWithIdentifier:@"friend cell"];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MessageFriendsCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSDictionary* tmp = [data_arr objectAtIndex:indexPath.row];
    [cell setUserScreenPhoto:[tmp objectForKey:@"screen_photo"]];
    [cell setRelationship:2];
    [cell setUserRoleTag:[tmp objectForKey:@"role_tag"]];
    [cell setUserScreenName:[tmp objectForKey:@"screen_name"]];
    
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
@end
