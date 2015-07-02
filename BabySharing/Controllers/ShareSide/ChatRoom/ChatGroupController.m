//
//  ChatGroupController.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 6/06/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "ChatGroupController.h"
#import "GroupModel.h"
#import "AppDelegate.h"
#import "Group.h"

#import "ChatSubGroupController.h"

@interface ChatGroupController ()
@property (nonatomic, weak, readonly) GroupModel* gm;
@property (weak, nonatomic) IBOutlet UITableView *queryView;
@end

@implementation ChatGroupController {
    BOOL isLoading;
}

@synthesize gm = _gm;
@synthesize queryView = _queryView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    _gm = delegate.gm;
   
    isLoading = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    if ([self tableView:tableView shouldHighlightRowAtIndexPath:indexPath]) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        Group* g = [_gm.groupdata objectAtIndex:indexPath.row - 2];
        [self performSegueWithIdentifier:@"showSubGroup" sender:g];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showSubGroup"]) {
        // TODO: pass group to next controller
        ((ChatSubGroupController*)segue.destinationViewController).current_group = sender;
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row != 0 && indexPath.row != 1 && indexPath.row != [self tableView:tableView numberOfRowsInSection:0] - 1;
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
   
    if (indexPath.row == 0) {
        return [self queryDefaultCellWithTableView:tableView withTitle:@"refreshing ..." andImage:nil];
    } else if (indexPath.row == 1) {
        UITableViewCell* cell = [self queryDefaultCellWithTableView:tableView withTitle:@"choose a group" andImage:nil];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        return cell;
    } else if (indexPath.row == [self tableView:tableView numberOfRowsInSection:0] - 1) {
        UITableViewCell* cell = [self queryDefaultCellWithTableView:tableView withTitle:@"drag to load more" andImage:nil];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        return cell;
    } else {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"default_with_title"];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"default_with_title"];
        }
        NSInteger index = indexPath.row - 2;
        Group* g = [_gm.groupdata objectAtIndex:index];
        NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
        NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
        NSString * filePath = [resourceBundle pathForResource:@"Talk" ofType:@"png"];
        UIImage *image = [UIImage imageNamed:filePath];
       
        cell.imageView.image = image;
        cell.textLabel.text = g.group_name;
        cell.detailTextLabel.text = @"description";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.detailTextLabel.textAlignment = NSTextAlignmentCenter;
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _gm.groupdata.count + 2 + 1;
}

#pragma mark -- query cell
- (UITableViewCell*)queryDefaultCellWithTableView:(UITableView*)tableView withTitle:(NSString*)title andImage:(UIImage*)img {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"default"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"default"];
    }
    
    cell.textLabel.text = title;
    cell.imageView.image = img;
    return cell;
}

#pragma mark -- scroll view delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 假设偏移表格高度的20%进行刷新
    if (!isLoading) { // 判断是否处于刷新状态，刷新中就不执行
        // 取内容的高度：
        // 如果内容高度大于UITableView高度，就取TableView高度
        // 如果内容高度小于UITableView高度，就取内容的实际高度
        float height = scrollView.contentSize.height > _queryView.frame.size.height ?_queryView.frame.size.height : scrollView.contentSize.height;
    
        if ((height - scrollView.contentSize.height + scrollView.contentOffset.y) / height > 0.2) { // 调用上拉刷新方
            CGRect rc = _queryView.frame;
            rc.origin.y = rc.origin.y - 44;
            [_queryView setFrame:rc];
//            [_qm appendQueryDataByUser:_current_user_id withToken:_current_auth_token andBeginIndex:_qm.querydata.count];
            [_gm refreshGroups];
            rc.origin.y = rc.origin.y + 44;
            [_queryView setFrame:rc];
            [_queryView reloadData];
            isLoading = YES;
            return;
    
        } else if (- scrollView.contentOffset.y / _queryView.frame.size.height > 0.2) { // 调用下拉刷新方法
            CGRect rc = _queryView.frame;
            rc.origin.y = rc.origin.y + 44;
            [_queryView setFrame:rc];
            [_gm refreshGroups];
//            [qm refreshQueryDataByUser:_current_user_id withToken:_current_auth_token];
            rc.origin.y = rc.origin.y - 44;
            [_queryView setFrame:rc];
            [_queryView reloadData];
            isLoading = YES;
    
            return;
        }
        // move and change
    }
}

@end
