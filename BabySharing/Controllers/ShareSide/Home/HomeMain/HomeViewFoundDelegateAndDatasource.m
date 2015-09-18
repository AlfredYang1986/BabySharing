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

#import "AppDelegate.h"
#import "LoginModel.h"
#import "QueryModel.h"

#import "TmpFileStorageModel.h"
#import "AlbumTableCell.h"

#import "HomeDetailViewController.h"
#import "QueryContentItem.h"
#import "QueryContent.h"

@interface HomeViewFoundDelegateAndDatasource () <AlbumTableCellDelegate>

@end

@implementation HomeViewFoundDelegateAndDatasource {
    NSArray* recommend_users;
}

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
        
        /**
         * get recommend user
         */
        [self queryUserDataAsync];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
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
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger index = indexPath.row;
//    NSInteger total = [self tableView:tableView numberOfRowsInSection:0];
   
    if (index == 0) {
        return 44;
    } else if (index == 1) {
        return [FoundPCGCell preferdHeight];
    }else if (index == 2) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width - 32;
        return width / 5;
    } else if (index == 3) {
        return 44;
    } else {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        return width / 3;
    }
}

#define PHOTO_PER_LINE  3
#pragma mark -- table view datasource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSInteger index = indexPath.row;
    NSArray* titles = @[@"refresh...", @"精彩内容", @"hottest sharing", @"hottest tags"];
//    NSInteger total = [self tableView:tableView numberOfRowsInSection:0];
    
    if (index == 0) {
        return [self queryDefaultCellWithTableView:tableView withTitle:[titles objectAtIndex:0]];
    } else if (index == 1) {
        return [self queryPGCCellWithTableView:tableView];
    }else if (index == 2) {
        return [self queryRecommendUserCellWithTableView:tableView];
    } else if (index == 3) {
        return [self queryDefaultCellWithTableView:tableView withTitle:[titles objectAtIndex:1]];
    } else {
        return [self queryTagsRowCellWithTableView:tableView atIndex:indexPath];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    return 4 + app.qm.querydata.count / PHOTO_PER_LINE;
}

#pragma mark -- query cell
- (UITableViewCell*)queryDefaultCellWithTableView:(UITableView*)tableView withTitle:(NSString*)title {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"default"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"default"];
    }
   
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.backgroundColor = [UIColor colorWithRed:0.9019 green:0.9019 blue:0.9019 alpha:1.f];
    cell.textLabel.text = title;
    return cell;
}

- (FoundPCGCell*)queryPGCCellWithTableView:(UITableView*)tableView {
    FoundPCGCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Found PGC Cell"];
    
    if (cell == nil) {
        NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"FoundPCGCell" owner:self options:nil];
        cell = [nib firstObject];
    }
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    NSString * filePath = [resourceBundle pathForResource:[NSString stringWithFormat:@"RecommondUser"] ofType:@"png"];
    
    cell.imageView.image = [UIImage imageNamed:filePath];
    return cell;
}

- (AlbumTableCell*)queryTagsRowCellWithTableView:(UITableView*)tableView atIndex:(NSIndexPath*)indexPath {
    
    AlbumTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlbumTableViewCell"];
    
    if (cell == nil) {
        cell = [[AlbumTableCell alloc]init];
    }
    
    cell.delegate = self;
    NSInteger row = indexPath.row - 4;
    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    @try {
        NSArray* arr_tmp = [app.qm.querydata objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(row * PHOTO_PER_LINE, PHOTO_PER_LINE)]];
        NSMutableArray* arr_content = [[NSMutableArray alloc]initWithCapacity:PHOTO_PER_LINE];
        for (QueryContent* item in arr_tmp) {
            [arr_content addObject:((QueryContentItem*)item.items.allObjects.firstObject).item_name];
        }
        [cell setUpContentViewWithImageNames:arr_content atLine:row andType:AlbumControllerTypePhoto];
    }
    @catch (NSException *exception) {
        NSArray* arr_tmp = [app.qm.querydata objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(row * PHOTO_PER_LINE, app.qm.querydata.count - row * PHOTO_PER_LINE)]];
        NSMutableArray* arr_content = [[NSMutableArray alloc]initWithCapacity:PHOTO_PER_LINE];
        for (QueryContent* item in arr_tmp) {
            [arr_content addObject:((QueryContentItem*)item.items.allObjects.firstObject).item_name];
        }
        [cell setUpContentViewWithImageNames:arr_content atLine:row andType:AlbumControllerTypePhoto];
    }
    
    return cell;
}

- (UITableViewCell*)queryRecommendUserCellWithTableView:(UITableView*)tableView {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Recommend Users"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Recommend Users"];
    }
    
    for (int index = 0; index < recommend_users.count; ++index) {
        NSDictionary* iter = [recommend_users objectAtIndex:index];
        
        CGFloat offset = 16;
        CGFloat width = [UIScreen mainScreen].bounds.size.width - 32;
        CGFloat step = width / 5;
        
        UIImageView* tmp = [[UIImageView alloc]initWithFrame:CGRectMake(index * step + offset + 4, 4, step - 8, step - 8)];
        
        NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
        NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
        NSString * filePath = [resourceBundle pathForResource:[NSString stringWithFormat:@"User"] ofType:@"png"];
        
        NSString* photo_name = [iter objectForKey:@"screen_photo"];
        
        UIImage* userImg = [TmpFileStorageModel enumImageWithName:photo_name withDownLoadFinishBolck:^(BOOL success, UIImage *user_img) {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self) {
                        tmp.image = user_img;
                        NSLog(@"owner img download success");
                    }
                });
            } else {
                NSLog(@"down load owner image %@ failed", photo_name);
            }
        }];

        if (userImg == nil) {
            userImg = [UIImage imageNamed:filePath];
        }
        [tmp setImage:userImg];
        [cell addSubview:tmp];
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

- (void)queryUserDataAsync {
    dispatch_queue_t aq = dispatch_queue_create("query new user", nil);
    dispatch_async(aq, ^{
        AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
        [app.lm querRecommendUserProlfilesWithFinishBlock:^(BOOL success, NSArray *lst) {
            dispatch_async(dispatch_get_main_queue(), ^{
                recommend_users = lst;
                [_tableView reloadData];
            });
        }];
    });
}

- (void)queryPostDataAsync {
    [_tableView reloadData];
}

#pragma mark -- album cell delegate
- (NSInteger)getViewsCount {
    return PHOTO_PER_LINE;
}

- (NSInteger)indexByRow:(NSInteger)row andCol:(NSInteger)col {
    return row * PHOTO_PER_LINE + col;
}

- (BOOL)isSelectedAtIndex:(NSInteger)index {
    return false;
}

- (void)didSelectOneImageAtIndex:(NSInteger)index {
//    OwnerQueryModel* om = [self getOM];
//    QueryContent* tmp = [om.querydata objectAtIndex:index];
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    HomeDetailViewController* detail = [storyboard instantiateViewControllerWithIdentifier:@"DetailContent"];
//    detail.hidesBottomBarWhenPushed = YES;
//    
//    AppDelegate * app = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    detail.qm = app.qm;
//    detail.current_content = tmp;
//    detail.current_user_id = _current_user_id;
//    detail.current_auth_token = _current_auth_token;
//    
//    [self.navigationController pushViewController:detail animated:YES];
}
@end
