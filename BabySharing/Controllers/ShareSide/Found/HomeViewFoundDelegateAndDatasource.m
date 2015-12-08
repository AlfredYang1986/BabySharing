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

//#import "HomeDetailViewController.h"
#import "HomeViewController.h"
#import "UserHomeViewDataDelegate.h"
#import "QueryContentItem.h"
#import "QueryContent.h"

#import "SearchViewController.h"

#import "FoundMoreFriendCell.h"
#import "FoundMotherChoiceCell.h"
#import "FoundSearchController.h"

//#define FOUND_REF_INDEX             -2
//#define FOUND_IMG_INDEX             -1
#define FOUND_SEARCH_INDEX          0
#define FOUND_USER_PHOTO_INDEX      1
#define FOUND_TITLE_INDEX           2
#define FOUND_CONTENT_INDEX         3

#define FOUND_SECTION_COUNT         4

#define PHOTO_PER_LINE  3

@interface HomeViewFoundDelegateAndDatasource () <AlbumTableCellDelegate, UISearchBarDelegate>

@end

@implementation HomeViewFoundDelegateAndDatasource {
    NSArray* recommend_users;
}

@synthesize tableView = _tableView;
@synthesize container = _container;

- (id)initWithTableView:(UITableView*)tableView andContainer:(UIViewController*)container {
    self = [super init];
    if (self) {
        _tableView = tableView;
        _container = container;
        
        /**
         * regisiter pcg view
         */
        [tableView registerNib:[UINib nibWithNibName:@"FoundPCGCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Found PGC Cell"];
        
        /**
         * register for tags view
         */
        [tableView registerClass:[TagsRowCell class] forCellReuseIdentifier:@"Tags Row Cell"];
        
        /**
         * found more friends cell
         */
        [tableView registerNib:[UINib nibWithNibName:@"FoundMoreFriendCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Recommend Users"];
        
        /**
         * mother choice
         */
        [tableView registerNib:[UINib nibWithNibName:@"FoundMotherChoiceCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Mother Choice"];
        
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
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    NSInteger index = indexPath.row;
    NSInteger index = indexPath.section;
//    NSInteger total = [self tableView:tableView numberOfRowsInSection:0];
    
//    if (index == FOUND_REF_INDEX) {
//        return 44;
//    } else if (index == FOUND_IMG_INDEX) {
//        return [FoundPCGCell preferdHeight];
//    } else
    if (index == FOUND_SEARCH_INDEX) {
        return 44;
    }else if (index == FOUND_USER_PHOTO_INDEX) {
//        CGFloat width = [UIScreen mainScreen].bounds.size.width - 32;
//        return width / 5;
        return [FoundMoreFriendCell preferredHeight];
    } else if (index == FOUND_TITLE_INDEX) {
        return [FoundMotherChoiceCell preferredHeight];
    } else {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        return width / 3;
    }
}

#pragma mark -- table view datasource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

//    NSInteger index = indexPath.row;
    NSInteger index = indexPath.section;
//    NSArray* titles = @[@"refresh...", @"Mother's Choice", @"hottest sharing", @"hottest tags"];
//    NSInteger total = [self tableView:tableView numberOfRowsInSection:0];
    
//    if (index == FOUND_REF_INDEX) {
//        return [self queryDefaultCellWithTableView:tableView withTitle:[titles objectAtIndex:0]];
//    } else if (index == FOUND_IMG_INDEX) {
//        return [self queryPGCCellWithTableView:tableView];
    
//    } else
    if (index == FOUND_SEARCH_INDEX) {
        return [self querySearchCellWithTabelView:tableView];
    }else if (index == FOUND_USER_PHOTO_INDEX) {
        return [self queryRecommendUserCellWithTableView:tableView];
    } else if (index == FOUND_TITLE_INDEX) {
//        return [self queryDefaultCellWithTableView:tableView withTitle:[titles objectAtIndex:1]];
        return [self queryMotherChoiceCellWithTableView:tableView];
    } else {
        return [self queryTagsRowCellWithTableView:tableView atIndex:indexPath];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return FOUND_SECTION_COUNT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == FOUND_SEARCH_INDEX) {
        return 5;
    }else if (section == FOUND_USER_PHOTO_INDEX) {
        return 5;
    } else if (section == FOUND_TITLE_INDEX) {
        return 0;
    } else {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    return 4 + app.qm.querydata.count / PHOTO_PER_LINE + FOUND_REF_INDEX;
//    return 2 + app.qm.querydata.count / PHOTO_PER_LINE;
    
    if (section == FOUND_SEARCH_INDEX) {
        return 1;
    }else if (section == FOUND_USER_PHOTO_INDEX) {
        return 1;
    } else if (section == FOUND_TITLE_INDEX) {
        return 1;
    } else {
        return app.qm.querydata.count / PHOTO_PER_LINE;
    }
}

#pragma mark -- query cell
- (UITableViewCell*)queryMotherChoiceCellWithTableView:(UITableView*)tableView {
    FoundMotherChoiceCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Mother Choice"];
    
    if (cell == nil) {
        NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"FoundMotherChooiceCell" owner:self options:nil];
        cell = [nib firstObject];
    }
    
    return cell;
}


- (UITableViewCell*)queryDefaultCellWithTableView:(UITableView*)tableView withTitle:(NSString*)title {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"default"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"default"];
    }
   
//    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.backgroundColor = [UIColor colorWithRed:0.9019 green:0.9019 blue:0.9019 alpha:1.f];
    cell.textLabel.text = title;
    return cell;
}

- (UITableViewCell*)querySearchCellWithTabelView:(UITableView*)tableView {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"search cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"search cell"];
    }
    
    UIView* tmp = [cell viewWithTag:-1];
    if (tmp == nil) {
        UISearchBar* bar = [[UISearchBar alloc]init];
        bar.delegate = self;
        bar.tag = -1;
        [cell addSubview:bar];
        bar.placeholder = @"搜索标签和角色";
        
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat height = 44;
        bar.frame = CGRectMake(0, 0, width, height);
    }
    
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
//    NSInteger row = indexPath.row - (4 + FOUND_REF_INDEX);
//    NSInteger row = indexPath.row - 2;
    NSInteger row = indexPath.row;
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
    
    FoundMoreFriendCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Recommend Users"];
    
    if (cell == nil) {
        NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"FoundMoreFriendCell" owner:self options:nil];
        cell = [nib firstObject];
    }
   
    [cell setUserImages:recommend_users];
    return cell;
}

#pragma mark -- scroll view delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"scrolling ... ");
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
//    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    QueryContent* tmp = [app.qm.querydata objectAtIndex:index];
//    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    HomeDetailViewController* detail = [storyboard instantiateViewControllerWithIdentifier:@"DetailContent"];
//    detail.hidesBottomBarWhenPushed = YES;
//    
//    detail.qm = app.qm;
//    detail.current_content = tmp;
//    detail.current_user_id = [app.lm getCurrentUserID];
//    detail.current_auth_token = [app.lm getCurrentAuthToken];
//    
//    [_container.navigationController pushViewController:detail animated:YES];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HomeViewController* hv = [storyboard instantiateViewControllerWithIdentifier:@"HomeView"];
    hv.isPushed = YES;
    hv.delegate = [[UserHomeViewDataDelegate alloc]init];
    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [hv.delegate pushExistingData:app.qm.querydata];
    [hv.delegate setSelectIndex:index];
    hv.nav_title = @"Mother's Choice";
    [_container.navigationController pushViewController:hv animated:YES];
}

- (void)didUnSelectOneImageAtIndex:(NSInteger)index {
    // do nothing
}

#pragma mark -- searh bar delegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"FoundSearch" bundle:nil];
    FoundSearchController* svc = [storyboard instantiateViewControllerWithIdentifier:@"FoundSearch"];
    [_container.navigationController pushViewController:svc animated:NO];
    return NO;
}
@end
