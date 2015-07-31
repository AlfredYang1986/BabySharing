//
//  HomeCommentsController.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 17/01/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "HomeCommentsController.h"
#import "QueryCommentsCell.h"
#import "QueryContent+ContextOpt.h"
#import "QueryComments.h"

#import "AppDelegate.h"

@interface HomeCommentsController () {
    NSArray* comments_array;
}
@property (weak, nonatomic) IBOutlet UITableView *queryView;
@property (nonatomic) BOOL isLoading;
@property (weak, nonatomic) IBOutlet UITextField *commentInputField;

@end

@implementation HomeCommentsController

@synthesize queryView = _queryView;
@synthesize isLoading = _isLoading;
@synthesize qm = _qm;
@synthesize commentInputField = _commentInputField;
@synthesize current_content = _current_content;
@synthesize current_user_id = _current_user_id;
@synthesize current_auth_token = _current_auth_token;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    comments_array = [_current_content.comments.allObjects sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if ([((QueryComments*)obj1).comment_date timeIntervalSince1970] <= [((QueryComments*)obj2).comment_date timeIntervalSince1970])
            return NSOrderedDescending;
        else
            return NSOrderedAscending;
    }];

//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(commentUpdate:) name:@"comments update" object:nil];
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
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger total = [self tableView:tableView numberOfRowsInSection:indexPath.section];
    if (indexPath.row == 0) {
        return 44;
    } else if (indexPath.row == total - 1){
        return 44;
    } else {
        return 133;
    }
}

#pragma mark -- table view datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    NSInteger total = [self tableView:tableView numberOfRowsInSection:indexPath.section];
    if (indexPath.row == 0) {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"default"];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"default"];
        }
        
        cell.textLabel.text = @"refreshing...";
        return cell;
    } else if (indexPath.row == total - 1){
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"default"];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"default"];
        }
        
        cell.textLabel.text = @"athena";
        return cell;
    } else {
        QueryCommentsCell* cell = [tableView dequeueReusableCellWithIdentifier:@"comments cell"];
        
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"QueryCommonsCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
//        QueryComments* item = [_current_content.comments.allObjects objectAtIndex:indexPath.row - 1];
        if (comments_array.count > 0) {
            QueryComments* item = [comments_array objectAtIndex:indexPath.row - 1];
            cell.current_comments = item;
        }
       
        return cell;
    }
}

- (NSInteger)enumResentCommentsCount {
    return _current_content.comments.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2 + [self enumResentCommentsCount];
}

#pragma mark -- scroll refresh
- (void)dealloc {
    ((UIScrollView*)_queryView).delegate = nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 假设偏移表格高度的20%进行刷新
    if (!_isLoading) { // 判断是否处于刷新状态，刷新中就不执行
        // 取内容的高度：
        // 如果内容高度大于UITableView高度，就取TableView高度
        // 如果内容高度小于UITableView高度，就取内容的实际高度
        float height = scrollView.contentSize.height > _queryView.frame.size.height ?_queryView.frame.size.height : scrollView.contentSize.height;
        if ((height - scrollView.contentSize.height + scrollView.contentOffset.y) / height > 0.2) { // 调用上拉刷新方

            NSInteger skip = _current_content.comments.count;
            // append comments
            CGRect rc = _queryView.frame;
            rc.origin.y = rc.origin.y - 44;
            [_queryView setFrame:rc];
            _current_content = [_qm appendCommentsByUser:_current_user_id withToken:_current_auth_token andBeginIndex:skip andPostID:_current_content.content_post_id];
            rc.origin.y = rc.origin.y + 44;
            [_queryView setFrame:rc];
//            [_queryView reloadData];
            [self commentUpdate:nil];
        }
        
        if (- scrollView.contentOffset.y / _queryView.frame.size.height > 0.2) { // 调用下拉刷新方法

            // refresh comments
            CGRect rc = _queryView.frame;
            rc.origin.y = rc.origin.y + 44;
            [_queryView setFrame:rc];
           
            _current_content = [_qm refreshCommentsByUser:_current_user_id withToken:_current_auth_token andPostID:_current_content.content_post_id];
            rc.origin.y = rc.origin.y - 44;
            [_queryView setFrame:rc];
//            [_queryView reloadData];
            [self commentUpdate:nil];
        }
    }
}

- (IBAction)postComment {
    NSLog(@"post Comment");
    /**
     * 1. check post is validate or not
     */
    /**
     * 2. post comment to the service
     */
    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    _current_content = [delegate.pm postCommentToServiceWithPostID:_current_content.content_post_id andCommentContent:_commentInputField.text];
    
    /**
     * 3. refresh local comment database via return value
     */
    [self commentUpdate:nil];
    [_queryView reloadData];
}

- (void)commentUpdate:(NSNotification*)sender {
    NSLog(@"update success");
//    _current_content = [QueryContent enumQueryContentByPostID:_current_content.content_post_id inContext:_qm.doc.managedObjectContext];

    comments_array = [_current_content.comments.allObjects sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if ([((QueryComments*)obj1).comment_date timeIntervalSince1970] <= [((QueryComments*)obj2).comment_date timeIntervalSince1970])
            return NSOrderedDescending;
        else
            return NSOrderedAscending;
    }];
    [_queryView reloadData];
}
@end
