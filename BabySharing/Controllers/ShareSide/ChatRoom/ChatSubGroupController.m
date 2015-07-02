//
//  ChatSubGroupController.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 7/06/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "ChatSubGroupController.h"
#import "CreateChatController.h"
#import "ChatViewController.h"
#import "Group.h"
#import "SubGroup.h"
#import "Group+ContextOpt.h"

@interface ChatSubGroupController () {
    NSArray* subGroups;
}

@end

@implementation ChatSubGroupController

@synthesize current_group = _current_group;
@synthesize subGroupView = _subGroupView;

- (void)setGroup:(Group*)g {
    _current_group = g;
    subGroups = _current_group.subGroups.allObjects;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(didSelectCreateChatRoomBtn:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didSelectCreateChatRoomBtn:(id)sender {
    [self performSegueWithIdentifier:@"CreateChatRoom" sender:_current_group];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"CreateChatRoom"]) {
        ((CreateChatController*)segue.destinationViewController).current_group = self.current_group;
        ((CreateChatController*)segue.destinationViewController).delegate = self;
        
    } else if ([segue.identifier isEqualToString:@"charRoom"]) {
        ((ChatViewController*)segue.destinationViewController).group = self.current_group;
        ((ChatViewController*)segue.destinationViewController).sub_group = [subGroups objectAtIndex:((NSIndexPath*)sender).row - 2];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -- table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"selet row");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger total = [self tableView:tableView numberOfRowsInSection:0];
    if (indexPath.row == 0) {
    
    } else if (indexPath.row == total - 1) {
    
    } else if (indexPath.row == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        // TODO: segue to the chat room
        [self performSegueWithIdentifier:@"charRoom" sender:indexPath];
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger total = [self tableView:tableView numberOfRowsInSection:0];
    if (indexPath.row == 0) {
        return NO;
    } else if (indexPath.row == total - 1) {
        return NO;
    } else if (indexPath.row == 1) {
        return YES;
    } else {
        return YES;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark -- table view datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    NSInteger total = [self tableView:tableView numberOfRowsInSection:0];
    if (indexPath.row == 0) {
        return [self queryDefaultCellWithTableView:tableView withTitle:@"refresh"];
    } else if (indexPath.row == total - 1) {
        return [self queryDefaultCellWithTableView:tableView withTitle:@"load more sub groups"];
    } else if (indexPath.row == 1) {
        return [self queryDefaultCellWithTableView:tableView withTitle:@"return to parents group"];
    } else {
        SubGroup * sb = [subGroups objectAtIndex:indexPath.row - 2];
        return [self queryDefaultCellWithTableView:tableView withTitle:sb.sub_group_name];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2 + 1 + subGroups.count;
}

#pragma mark -- query cell
- (UITableViewCell*)queryDefaultCellWithTableView:(UITableView*)tableView withTitle:(NSString*)title {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"default"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"default"];
    }
    
    cell.textLabel.text = title;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}

#pragma mark -- scroll view delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 假设偏移表格高度的20%进行刷新
    //    if (!_isLoading) { // 判断是否处于刷新状态，刷新中就不执行
    //        // 取内容的高度：
    //        // 如果内容高度大于UITableView高度，就取TableView高度
    //        // 如果内容高度小于UITableView高度，就取内容的实际高度
    //        float height = scrollView.contentSize.height > _queryView.frame.size.height ?_queryView.frame.size.height : scrollView.contentSize.height;
    //
    //        if ((height - scrollView.contentSize.height + scrollView.contentOffset.y) / height > 0.2) { // 调用上拉刷新方
    //            CGRect rc = _queryView.frame;
    //            rc.origin.y = rc.origin.y - 44;
    //            [_queryView setFrame:rc];
    //            [_qm appendQueryDataByUser:_current_user_id withToken:_current_auth_token andBeginIndex:_qm.querydata.count];
    //            rc.origin.y = rc.origin.y + 44;
    //            [_queryView setFrame:rc];
    //            [_queryView reloadData];
    //            return;
    //
    //        } else if (- scrollView.contentOffset.y / _queryView.frame.size.height > 0.2) { // 调用下拉刷新方法
    //            CGRect rc = _queryView.frame;
    //            rc.origin.y = rc.origin.y + 44;
    //            [_queryView setFrame:rc];
    //            [_qm refreshQueryDataByUser:_current_user_id withToken:_current_auth_token];
    //            rc.origin.y = rc.origin.y - 44;
    //            [_queryView setFrame:rc];
    //            [_queryView reloadData];
    //
    //            return;
    //        }
    //
    //
    //        // move and change
    //    }
    
}

#pragma mark -- sub view delegate
- (void)didCreateSubGroup:(Group *)g {
    self.current_group = g;
    [_subGroupView reloadData];
}
@end
