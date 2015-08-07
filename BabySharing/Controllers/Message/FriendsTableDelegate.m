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

@interface FriendsTableDelegate ()
@property (nonatomic, weak, readonly) LoginModel* lm;
@end

@implementation FriendsTableDelegate {
    BOOL isLoading;
    
    NSArray* data_arr;
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
    //    [self performSegueWithIdentifier:@"HomeDetailSegue" sender:indexPath];
    
    //    QueryContent* cur = [_qm.querydata objectAtIndex:indexPath.row - 1];
    //    [self performSegueWithIdentifier:@"HomeDetailSegue" sender:cur];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
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
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"friends cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"friends cell"];
    }
    
    cell.imageView.layer.cornerRadius = cell.imageView.bounds.size.width / 2;
    cell.imageView.clipsToBounds = YES;
   
    NSDictionary* tmp = [data_arr objectAtIndex:indexPath.row];
    cell.textLabel.text = [tmp objectForKey:@"screen_name"];
    cell.detailTextLabel.text = [tmp objectForKey:@"role_tag"];
    
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    NSString * filePath = [resourceBundle pathForResource:[NSString stringWithFormat:@"User"] ofType:@"png"];
    
    UIImage* userImg = [TmpFileStorageModel enumImageWithName:[tmp objectForKey:@"screen_photo"] withDownLoadFinishBolck:^(BOOL success, UIImage *user_img) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (cell) {
                    cell.imageView.image = user_img;
                    NSLog(@"owner img download success");
                }
            });
        } else {
            NSLog(@"down load owner image");
        }
    }];
    
    if (userImg == nil) {
        userImg = [UIImage imageNamed:filePath];
    }
    [cell.imageView setImage:userImg];
    
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
    data_arr = [_lm querMultipleProlfiles:[ma copy]];
    NSLog(@"%@", data_arr);
    [_queryView reloadData];
}
@end
