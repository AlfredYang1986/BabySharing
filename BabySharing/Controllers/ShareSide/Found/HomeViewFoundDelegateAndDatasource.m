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
#import "UserSearchController.h"

#import "FoundViewController.h"

//#define FOUND_REF_INDEX             -2
//#define FOUND_IMG_INDEX             -1
//#define FOUND_SEARCH_INDEX          0
//#define FOUND_USER_PHOTO_INDEX      0
#define FOUND_TITLE_INDEX           0
#define FOUND_CONTENT_INDEX         1

#define FOUND_SECTION_COUNT         2

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
        _tableView.showsVerticalScrollIndicator = NO;
        _container = (FoundViewController*)container;
        
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
    
//    if (indexPath.section == 0 && indexPath.row == 0) {
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UserSearch" bundle:nil];
//        UserSearchController* svc = [storyboard instantiateViewControllerWithIdentifier:@"UserSearch"];
//        AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
//        svc.um = app.um;
//        [_container.navigationController pushViewController:svc animated:YES];
//    }
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
//    if (index == FOUND_SEARCH_INDEX) {
//        return 44;
//    }else
//    if (index == FOUND_USER_PHOTO_INDEX) {
//        return [FoundMoreFriendCell preferredHeight];
//    } else
    if (index == FOUND_TITLE_INDEX) {
        return [FoundMotherChoiceCell preferredHeight];
    } else {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        return width / 3;
    }
}

#pragma mark -- table view datasource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSInteger index = indexPath.section;
//    if (index == FOUND_SEARCH_INDEX) {
//        return [self querySearchCellWithTabelView:tableView];
//    }else
//    if (index == FOUND_USER_PHOTO_INDEX) {
//        return [self queryRecommendUserCellWithTableView:tableView];
//    } else
    if (index == FOUND_TITLE_INDEX) {
        return [self queryMotherChoiceCellWithTableView:tableView];
    } else {
        return [self queryTagsRowCellWithTableView:tableView atIndex:indexPath];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return FOUND_SECTION_COUNT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    if (section == FOUND_SEARCH_INDEX) {
//        return 10;
//    }else
//    if (section == FOUND_USER_PHOTO_INDEX) {
//        return 10;
//    } else
    if (section == FOUND_TITLE_INDEX) {
        return 0;
    } else {
        return 0;
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView* reVal = [[UIView alloc]init];

    CALayer* layer = [CALayer layer];
    layer.borderColor = [UIColor colorWithWhite:0.5922 alpha:0.25].CGColor;
    layer.borderWidth = 1.f;
    layer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 1);
    [reVal.layer addSublayer:layer];
    
    CALayer* line = [CALayer layer];
    line.borderColor = [UIColor colorWithWhite:0.5922 alpha:0.18].CGColor;
    line.borderWidth = 1.f;
    line.frame = CGRectMake(0, 10, [UIScreen mainScreen].bounds.size.width, 1);
    [reVal.layer addSublayer:line];
    
    return reVal;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    if (section == FOUND_SEARCH_INDEX) {
//        return 1;
//    }else
//    if (section == FOUND_USER_PHOTO_INDEX) {
//        return 1;
//    } else
    if (section == FOUND_TITLE_INDEX) {
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
        bar.frame = CGRectMake(0, 0, width, height);//    _friendsSearchBar.showsCancelButton = YES;
       
#define SEARCH_BAR_HEIGHT   44
        bar.backgroundColor = [UIColor clearColor];
        UIImageView* iv = [[UIImageView alloc] initWithImage:[self imageWithColor:[UIColor whiteColor] size:CGSizeMake(width, SEARCH_BAR_HEIGHT)]];
        [bar insertSubview:iv atIndex:1];
        for (UIView* v in bar.subviews.firstObject.subviews) {
            if ( [v isKindOfClass: [UITextField class]] ) {
                UITextField *tf = (UITextField *)v;
                tf.backgroundColor = [UIColor colorWithWhite:0.9490 alpha:1.f];
                tf.borderStyle = UITextBorderStyleRoundedRect;
                tf.clearButtonMode = UITextFieldViewModeWhileEditing;
            } else if ([v isKindOfClass:[UIButton class]]) {
                // UIButton* cancel_btn = (UIButton*)v;
                // [cancel_btn setTitle:@"test" forState:UIControlStateNormal];
                // [cancel_btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                // [cancel_btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
            }
        }
    }
    
    return cell;
}

//取消searchbar背景色
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
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
    NSInteger row = indexPath.row;
    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    @try {
        NSArray* arr_tmp = [app.qm.querydata objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(row * PHOTO_PER_LINE, PHOTO_PER_LINE)]];
        NSMutableArray* arr_content = [[NSMutableArray alloc]initWithCapacity:PHOTO_PER_LINE];
        for (QueryContent* item in arr_tmp) {
            for (QueryContentItem *aaa in item.items) {
    
                if (aaa.item_type.unsignedIntegerValue != PostPreViewMovie) {
                    [arr_content addObject:aaa.item_name];
                    break;
                }
            }
        }
        [cell setUpContentViewWithImageNames:arr_content atLine:row andType:AlbumControllerTypePhoto];
        cell.cannot_selected = YES;
    }
    @catch (NSException *exception) {
        NSArray* arr_tmp = [app.qm.querydata objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(row * PHOTO_PER_LINE, app.qm.querydata.count - row * PHOTO_PER_LINE)]];
        NSMutableArray* arr_content = [[NSMutableArray alloc] initWithCapacity:PHOTO_PER_LINE];
        for (QueryContent* item in arr_tmp) {
            for (QueryContentItem *aaa in item.items) {
                if (aaa.item_type.unsignedIntegerValue != PostPreViewMovie) {
                    [arr_content addObject:aaa.item_name];
                    break;
                }
            }
        }
        [cell setUpContentViewWithImageNames:arr_content atLine:row andType:AlbumControllerTypePhoto];
        cell.cannot_selected = YES;
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

- (BOOL)isAllowMultipleSelected {
    return NO;
}

- (void)didSelectOneImageAtIndex:(NSInteger)index {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HomeViewController* hv = [storyboard instantiateViewControllerWithIdentifier:@"HomeView"];
    hv.isPushed = YES;
    hv.delegate = [[UserHomeViewDataDelegate alloc]init];
    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [hv.delegate pushExistingData:app.qm.querydata];
    [hv.delegate setSelectIndex:index];
    hv.nav_title = @"发现更多内容";
    hv.current_index = index;
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

#pragma mark -- scroll view delegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    [_container scrollDidScroll:scrollView];
//
//}
@end
