//
//  HomeViewFoundDelegateAndDatasource.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 6/06/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "HomeViewFoundDelegateAndDatasource.h"
#import "FoundPCGCell.h"
#import "TagsRowCell.h"

@implementation HomeViewFoundDelegateAndDatasource

@synthesize tableView = _tableView;

- (id)initWithTableView:(UITableView *)tableView {
    self = [super init];
    if (self) {
        _tableView = tableView;
        
        /**
         * regisiter pcg view
         */
        [tableView registerNib:[UINib nibWithNibName:@"FoundPCGCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Found PGC Cell"];
        
        /**
         * register for tags view
         */
        [tableView registerClass:[TagsRowCell class] forCellReuseIdentifier:@"Tags Row Cell"];
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
    
    NSInteger index = indexPath.row;
//    NSInteger total = [self tableView:tableView numberOfRowsInSection:0];
   
    if (index == 0) {// || index == total - 1) {
        return 44;
    } else if (index % 2 == 0) {
        return 44;
    } else if (index == 1) {
        return [FoundPCGCell preferdHeight];
    } else
        return [TagsRowCell preferdHeight];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark -- table view datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSInteger index = indexPath.row;
    NSArray* titles = @[@"refresh...", @"first comming", @"hottest sharing", @"hottest tags"];
//    NSInteger total = [self tableView:tableView numberOfRowsInSection:0];
    
    if (index % 2 == 0) {
        return [self queryDefaultCellWithTableView:tableView withTitle:[titles objectAtIndex:index / 2]];
    } else if (index == 1) {
        return [self queryPGCCellWithTableView:tableView];
    } else
        return [self queryTagsRowCellWithTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1 /*2*/ + 1 + 3 + 3;
}

#pragma mark -- query cell
- (UITableViewCell*)queryDefaultCellWithTableView:(UITableView*)tableView withTitle:(NSString*)title {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"default"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"default"];
    }
    
    cell.textLabel.text = title;
    return cell;
}

- (FoundPCGCell*)queryPGCCellWithTableView:(UITableView*)tableView {
    FoundPCGCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Found PGC Cell"];
    
    if (cell == nil) {
        NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"FoundPCGCell" owner:self options:nil];
        cell = [nib firstObject];
    }
    
    return cell;
}

- (TagsRowCell*)queryTagsRowCellWithTableView:(UITableView*)tableView {
    TagsRowCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Tags Row Cell"];
    
    if (cell == nil) {
        cell = [[TagsRowCell alloc]init];
    }
    
    return cell;
}

#pragma mark -- scroll view delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"scrolling ... ");
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
@end
