//
//  HomeTagsController.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 19/06/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "HomeTagsController.h"
#import "AppDelegate.h"
#import "QueryModel.h"
#import "QueryContent.h"
//#import "TagQueryCell.h"
#import "FoundMoreFriendCell.h"
#import "AlbumTableCell.h"
#import "QueryContentItem.h"
#import "HomeViewController.h"
#import "UserHomeViewDataDelegate.h"
#import "Define.h"
//#define TAGED_USER_CELL                 0
#define TAGED_RESULT_COUNT_CELL         0

#define TAGED_OFFSET                    1

#define PHOTO_PER_LINE                  3


#define COUNT_CELL_CONTENT_HEIGHT       46
#define COUNT_CELL_MARGIN               10

@interface HomeTagsController () <AlbumTableCellDelegate>
//@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UITableView *queryView;

//@property (weak, nonatomic) IBOutlet UIButton *contentBtn;
//@property (weak, nonatomic) IBOutlet UIButton *userBtn;
@end

@implementation HomeTagsController {
    NSArray* content_arr;
    NSArray* recommend_users;
}

@synthesize tag_name = _tag_name;
@synthesize tag_type = _tag_type;

@synthesize isRoleTag = _isRoleTag;

//@synthesize imgView = _imgView;
@synthesize queryView = _queryView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
  
    dispatch_queue_t aq = dispatch_queue_create("query tag content queue", nil);
    dispatch_async(aq, ^{
        [self refreshTagData];
    });
    
    [self queryUserDataAsync];
   
    /**
     * comments header and footer
     */
//    [_queryView registerClass:[TagQueryCell class] forCellReuseIdentifier:@"tag cell"];
    [_queryView registerClass:[AlbumTableCell class] forCellReuseIdentifier:@"tag cell"];
    [_queryView registerNib:[UINib nibWithNibName:@"FoundMoreFriendCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"tag users"];
    
    UILabel* label_t = [[UILabel alloc]init];
    label_t.text = _tag_name;
    label_t.textColor = TextColor;
    [label_t sizeToFit];
    self.navigationItem.titleView = label_t;
   
    UIButton* barBtn = [[UIButton alloc]initWithFrame:CGRectMake(13, 32, 30, 25)];
    NSString* filepath = [resourceBundle pathForResource:@"dongda_back" ofType:@"png"];
    CALayer * layer = [CALayer layer];
    layer.contents = (id)[UIImage imageNamed:filepath].CGImage;
    layer.frame = CGRectMake(-7, 0, 25, 25);
    layer.position = CGPointMake(10, barBtn.frame.size.height / 2);
    [barBtn.layer addSublayer:layer];
//    [barBtn setBackgroundImage:[UIImage imageNamed:filepath] forState:UIControlStateNormal];
//    [barBtn setImage:[UIImage imageNamed:filepath] forState:UIControlStateNormal];
    [barBtn addTarget:self action:@selector(didPopControllerBtnSelected) forControlEvents:UIControlEventTouchDown];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:barBtn];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.9490 alpha:1.f];
    _queryView.backgroundColor = [UIColor whiteColor];
    _queryView.separatorStyle = UITableViewCellSeparatorStyleNone;
   
#define STATUS_HEIGHT               20
#define NAV_BAR_HEIGHT              44
#define TABVIEW_TOP_MARGIN          10
//    CALayer* line = [CALayer layer];
//    line.borderColor = [UIColor colorWithWhite:0.5922 alpha:0.10].CGColor;
//    line.borderWidth = 1.f;
//    line.frame = CGRectMake(0, STATUS_HEIGHT + NAV_BAR_HEIGHT + TABVIEW_TOP_MARGIN - 1, [UIScreen mainScreen].bounds.size.width, 1);
//    [self.view.layer addSublayer:line];
}

- (void)didPopControllerBtnSelected {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- query tag content
- (void)refreshTagData {
    
    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if (_isRoleTag) {
        
        
    } else {
        [app.tm queryTagContentsByUser:app.lm.current_user_id withToken:app.lm.current_auth_token andTagType:_tag_type andTagName:_tag_name withStartIndex:0 finishedBlock:^(BOOL success){
            if (success) {
                content_arr = app.tm.querydata;
                dispatch_async(dispatch_get_main_queue(), ^{
                    content_arr = app.tm.querydata;
                    [_queryView reloadData];
                });
            }
        }];       
    }
}

- (void)appendTagData {
    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    if (_isRoleTag) {
        
    } else {
        NSInteger cur_total = content_arr.count;
        [app.tm appendTagContentsByUser:app.lm.current_user_id withToken:app.lm.current_auth_token andTagType:_tag_type andTagName:_tag_name withStartIndex:cur_total finishedBlock:^(BOOL success){
            if (success) {
                content_arr = app.tm.querydata;
                dispatch_async(dispatch_get_main_queue(), ^{
                    content_arr = app.tm.querydata;
                    [_queryView reloadData];
                });
            }
        }];       
    }
}

- (void)queryUserDataAsync {
    dispatch_queue_t aq = dispatch_queue_create("query new user", nil);
    dispatch_async(aq, ^{
        AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
        [app.lm querRecommendUserProlfilesWithFinishBlock:^(BOOL success, NSArray *lst) {
            dispatch_async(dispatch_get_main_queue(), ^{
                recommend_users = lst;
                [_queryView reloadData];
            });
        }];
    });
}

#pragma mark -- table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"selet row");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (indexPath.row == TAGED_USER_CELL) {
//        return [FoundMoreFriendCell preferredHeight];
    
//    } else
    if (indexPath.row == TAGED_RESULT_COUNT_CELL) {
        return COUNT_CELL_CONTENT_HEIGHT + COUNT_CELL_MARGIN;
        
    } else {
        return [AlbumTableCell prefferCellHeight];
    }
}

#pragma mark -- table view datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

//    if (indexPath.row == TAGED_USER_CELL) {
//        FoundMoreFriendCell* cell = [tableView dequeueReusableCellWithIdentifier:@"tag users"];
//        
//        if (cell == nil) {
//            NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"FoundMoreFriendCell" owner:self options:nil];
//            cell = [nib firstObject];
//        }
//        
//        [cell setUserImages:recommend_users];
//        cell.des = @"最近有5个用户打过这个标签";
//        cell.isHiddenIcon = YES;
//        return cell;
//    
//    } else
    if (indexPath.row == TAGED_RESULT_COUNT_CELL) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"defatult"];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"default"];
        }
       
        if ([cell viewWithTag:-1] == nil) {
            UIView *margin = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, COUNT_CELL_MARGIN)];
            margin.backgroundColor = [UIColor colorWithWhite:0.9490 alpha:1.f];
            margin.tag = -1;
            [cell addSubview:margin];
            
            CALayer *layer = [CALayer layer];
            layer.borderColor = [UIColor colorWithWhite:0.5922 alpha:0.25].CGColor;
            layer.borderWidth = 1.f;
            layer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 1);
            [cell.layer addSublayer:layer];
            
            CALayer *line = [CALayer layer];
            line.borderColor = [UIColor colorWithWhite:0.5922 alpha:0.10].CGColor;
            line.borderWidth = 1.f;
            line.frame = CGRectMake(0, COUNT_CELL_MARGIN - 1, [UIScreen mainScreen].bounds.size.width, 1);
            [cell.layer addSublayer:line];
        }
       
        if ([cell viewWithTag:-2] == nil) {
            UILabel *label = [[UILabel alloc]init];
            label.tag = -2;
            label.textColor = [UIColor colorWithWhite:0.5059 alpha:1.f];
            label.font = [UIFont systemFontOfSize:14.f];
            
            [cell addSubview:label];
         }

        UILabel* label = (UILabel*)[cell viewWithTag:-2];
        label.text = [NSString stringWithFormat:@"%lu个分享", (unsigned long)content_arr.count];
        label.textColor = TextColor;
        [label sizeToFit];
        label.center = CGPointMake(10.5 + label.frame.size.width / 2, COUNT_CELL_MARGIN + COUNT_CELL_CONTENT_HEIGHT / 2);

        return cell;
        
    } else {
        
        AlbumTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tag cell"];
        
        if (cell == nil) {
            cell = [[AlbumTableCell alloc]init];
        }
        cell.delegate = self;
        NSInteger row = indexPath.row - TAGED_OFFSET;
        @try {
            NSArray* arr_tmp = [content_arr objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(row * PHOTO_PER_LINE, PHOTO_PER_LINE)]];
            NSMutableArray* arr_content = [[NSMutableArray alloc]initWithCapacity:PHOTO_PER_LINE];
            for (QueryContent* item in arr_tmp) {
                [arr_content addObject:((QueryContentItem*)item.items.allObjects.firstObject).item_name];
            }
            [cell setUpContentViewWithImageNames:arr_content atLine:row andType:AlbumControllerTypePhoto];
            cell.cannot_selected = YES;
        }
        @catch (NSException *exception) {
            NSArray* arr_tmp = [content_arr objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(row * PHOTO_PER_LINE, content_arr.count - row * PHOTO_PER_LINE)]];
            NSMutableArray* arr_content = [[NSMutableArray alloc]initWithCapacity:PHOTO_PER_LINE];
            for (QueryContent* item in arr_tmp) {
                [arr_content addObject:((QueryContentItem*)item.items.allObjects.firstObject).item_name];
            }
            [cell setUpContentViewWithImageNames:arr_content atLine:row andType:AlbumControllerTypePhoto];
            cell.cannot_selected = YES;
        }
        
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return content_arr.count == 0 ? 0 : content_arr.count / [TagQueryCell getRowItemCount] + 1;
    return TAGED_OFFSET + (content_arr.count == 0 ? 0 : content_arr.count / PHOTO_PER_LINE + 1);
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
    hv.nav_title = _tag_name;
    //    hv.nav_title = @"Mother's Choice";
    [self.navigationController pushViewController:hv animated:YES];
}

- (void)didUnSelectOneImageAtIndex:(NSInteger)index {
    // do nothing
}
@end
