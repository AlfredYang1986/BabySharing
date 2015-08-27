//
//  HomeViewController.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 9/01/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "HomeViewController.h"

#import "QueryModel.h"
#import "AppDelegate.h"
#import "QueryContent+ContextOpt.h"
#import "QueryContentItem.h"
#import "TmpFileStorageModel.h"
#import "HomeDetailViewController.h"
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "MoviePlayTrait.h"
#import "HomeViewFoundDelegateAndDatasource.h"
#import "INTUAnimationEngine.h"
#import "QueryCell.h"
#import "QueryHeader.h"
#import "INTUAnimationEngine.h"
#import "BWStatusBarOverlay.h"

#define VIEW_BOUNTDS        CGFloat screen_width = [UIScreen mainScreen].bounds.size.width; \
                            CGFloat screen_height = [UIScreen mainScreen].bounds.size.height; \
                            CGRect rc = CGRectMake(0, 0, screen_width, screen_height);


#define QUERY_VIEW_START    CGRectMake(0, -44, rc.size.width, rc.size.height)
#define QUERY_VIEW_SCROLL   CGRectMake(0, 0, rc.size.width, rc.size.height)
#define QUERY_VIEW_END      CGRectMake(-rc.size.width, -44, rc.size.width, rc.size.height)

#define FOUND_BOUNDS        CGRect rc1 = _foundView.bounds;
#define FOUND_VIEW_START    CGRectMake(rc.size.width, 19, rc.size.width, rc1.size.height)
#define FOUND_VIEW_END      CGRectMake(0, 19, rc.size.width, rc1.size.height)

#define BACK_TO_TOP_TIME    3.0

@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource, QueryCellActionProtocol>
    
@property (weak, nonatomic) IBOutlet UITableView *queryView;
@property (weak, nonatomic, readonly) NSString* current_user_id;
@property (weak, nonatomic, readonly) NSString* current_auth_token;
@property (weak, nonatomic, readonly) QueryModel* qm;
@property (nonatomic) BOOL isLoading;
@property (nonatomic) BOOL isHandleScrolling;

@property (weak, nonatomic) IBOutlet UITableView *foundView;
@end

@implementation HomeViewController {
    UISegmentedControl* sg;
    MoviePlayTrait* trait;
    
    HomeViewFoundDelegateAndDatasource* found_datasource;
    
    UIView* bkView;
    UITapGestureRecognizer* tap;
    BOOL showBack2Top;
    CGFloat offset_y;
}

@synthesize queryView = _queryView;
@synthesize current_auth_token = _current_auth_token;
@synthesize current_user_id = _current_user_id;
@synthesize qm = _qm;
@synthesize isLoading = _isLoading;
@synthesize isHandleScrolling = _isHandleScrolling;

@synthesize foundView = _foundView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    UINib* nib = [UINib nibWithNibName:@"QueryCell" bundle:[NSBundle mainBundle]];
    [_queryView registerNib:nib forCellReuseIdentifier:@"query cell"];
    [_queryView registerClass:[QueryHeader class] forHeaderFooterViewReuseIdentifier:@"query header"];
    
    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    _current_user_id = delegate.lm.current_user_id;
    _current_auth_token = delegate.lm.current_auth_token;
    _qm = delegate.qm;
    
//    [TmpFileStorageModel deleteBMTmpImageDir];
//    [TmpFileStorageModel deleteBMTmpMovieDir];
    _isLoading = NO;
    
    /**
     * set drop down list view
     */
    sg = [[UISegmentedControl alloc]initWithItems:@[@"推荐", @"发现"]];
    sg.backgroundColor = [UIColor greenColor];
    [sg addTarget:self action:@selector(segmentCanged:) forControlEvents:UIControlEventValueChanged];
    sg.selectedSegmentIndex = 0;
    self.navigationItem.titleView = sg;
    
    /**
     * search controller
     */
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    NSString * filePath = [resourceBundle pathForResource:[NSString stringWithFormat:@"Explore"] ofType:@"png"];
    UIImage *image = [UIImage imageNamed:filePath];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(didSelectSearchBtn:)];
    
    trait = [[MoviePlayTrait alloc]init];
   
    found_datasource = [[HomeViewFoundDelegateAndDatasource alloc]init];
    _foundView.delegate = found_datasource;
    _foundView.dataSource = found_datasource;

    [self layoutTableViews];
    
    BWStatusBarOverlay* tmp = [BWStatusBarOverlay shared];
    [tmp setBackgroundColor:[UIColor redColor]];
    [tmp.textLabel setTextColor:[UIColor whiteColor]];
    showBack2Top = YES;
    
    tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back2TopHandler:)];
    [tmp addGestureRecognizer:tap];
}

- (void)layoutTableViews {
    NSLog(@"layout the tableviews");
    VIEW_BOUNTDS
    FOUND_BOUNDS
    if (sg.selectedSegmentIndex == 0) {
        _queryView.frame = QUERY_VIEW_START;
        _foundView.frame = FOUND_VIEW_START;
    } else {
        _queryView.frame = QUERY_VIEW_END;
        _foundView.frame = FOUND_VIEW_END;
    }
//    [self changeViews];
    bkView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, 20)];
    bkView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bkView];
    [self.view bringSubviewToFront:bkView];
}

- (void)changeViews {
    static const CGFloat kAnimationDuration = 0.80; // in seconds
    VIEW_BOUNTDS
    FOUND_BOUNDS
    [INTUAnimationEngine animateWithDuration:kAnimationDuration
                                       delay:0.0
                                      easing:INTUEaseInOutQuadratic
                                     options:INTUAnimationOptionNone
                                  animations:^(CGFloat progress) {
                                      if (sg.selectedSegmentIndex == 0) {
                                          _queryView.frame = INTUInterpolateCGRect(QUERY_VIEW_END, QUERY_VIEW_START, progress);
                                          _foundView.frame = INTUInterpolateCGRect(FOUND_VIEW_END, FOUND_VIEW_START, progress);
                                      } else {
                                          _queryView.frame = INTUInterpolateCGRect(QUERY_VIEW_START, QUERY_VIEW_END, progress);
                                          _foundView.frame = INTUInterpolateCGRect(FOUND_VIEW_START, FOUND_VIEW_END, progress);
                                      }
                                      
                                      // NSLog(@"Progress: %.2f", progress);
                                  }
                                  completion:^(BOOL finished) {
                                      // NOTE: When passing INTUAnimationOptionRepeat, this completion block is NOT executed at the end of each cycle. It will only run if the animation is canceled.
                                      NSLog(@"%@", finished ? @"Animation Completed" : @"Animation Canceled");
                                      //                                                         self.animationID = NSNotFound;
                                  }];
}

- (void)segmentCanged:(id)sender {
    NSLog(@"segment changed");
//    [self viewDidLayoutSubviews];
    [self changeViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _isHandleScrolling = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _isHandleScrolling = NO;
}

- (void)back2TopHandler:(UITapGestureRecognizer*)gesture {
    [_queryView setContentOffset:CGPointZero animated:YES];
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
//    [self performSegueWithIdentifier:@"HomeDetailSegue" sender:indexPath];
    
//    QueryContent* cur = [_qm.querydata objectAtIndex:indexPath.row - 1];
//    [self performSegueWithIdentifier:@"HomeDetailSegue" sender:cur];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
//    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSInteger total = [self tableView:tableView numberOfRowsInSection:indexPath.section];
    NSInteger total = [self numberOfSectionsInTableView:tableView];
    if (indexPath.section == 0 || indexPath.section == total - 1) return 44;
    else {
        
        QueryContent* tmp = [self.qm.querydata objectAtIndex:indexPath.section - 1];
        return [QueryCell preferredHeightWithDescription:tmp.content_description];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if ([view isKindOfClass:[UITableViewHeaderFooterView class]]) {
        NSInteger total = [self numberOfSectionsInTableView:tableView];
        if (section == 0 || section == total - 1) return;
        else ((UITableViewHeaderFooterView *)view).backgroundView.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.6];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell isKindOfClass:[QueryCell class]]) {
        QueryCell* qc = (QueryCell*)cell;
        if (qc.movieURL) {
            [qc movieContentWithURL:qc.movieURL withTriat:trait];
        }
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell isKindOfClass:[QueryCell class]]) {
        QueryCell* qc = (QueryCell*)cell;
        [qc stopMovie];
//        [trait AvailableForPlayer:qc.player];
//        qc.player = nil;
        // TODO: remove the player layer
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSInteger total = [self numberOfSectionsInTableView:tableView];
    if (section == 0 || section == total - 1) {
        
        UITableViewHeaderFooterView* view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"default header"];
        
        if (view == nil) {
            view = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:@"default header"];
        }
        
        view.textLabel.text = @"alfred...";
        
        return view;
        
    } else {
        
        QueryHeader* header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"query header"];
        
        if (header == nil) {
            header = [[QueryHeader alloc]initWithReuseIdentifier:@"query header"];
        }

        [header setUpSubviews];
        QueryContent* tmp = [self.qm.querydata objectAtIndex:section - 1];
        [header setUserPhoto:tmp.owner_photo];
        [header setUserName:tmp.owner_name];
        [header setLocation:@"中国 北京"];
        [header setRoleTag:@"role tag"];
        [header setTimes:@"1000"];
        
        return header;
    }
}

#pragma mark -- table view datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
//    NSInteger total = [self tableView:tableView numberOfRowsInSection:indexPath.section];
    NSInteger total = [self numberOfSectionsInTableView:tableView];
//    if (indexPath.row == 0) {
    if (indexPath.section == 0) {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"default"];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"default"];
        }
        
        cell.textLabel.text = @"refreshing...";
        return cell;
        
//    } else if (indexPath.row == total - 1){
    } else if (indexPath.section == total - 1){
         UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"default"];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"default"];
        }
        
        cell.textLabel.text = @"athena";
        return cell;   
    } else {
        QueryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"query cell"];
    
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"QueryCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
     
//        QueryContent* tmp = [self.qm.querydata objectAtIndex:indexPath.row - 1];
        QueryContent* tmp = [self.qm.querydata objectAtIndex:indexPath.section - 1];
        QueryContentItem* tmp_item = [tmp.items.objectEnumerator nextObject];
        if (tmp_item.item_type.unsignedIntegerValue == PostPreViewPhote) {
            NSLog(@"photo field");
            NSLog(@"%@", tmp_item.item_name);
            UIImage* img =[TmpFileStorageModel enumImageWithName:tmp_item.item_name withDownLoadFinishBolck:^(BOOL success, UIImage* download_img) {
                if (success) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (cell) {
                            cell.imgView.image = download_img;
                            NSLog(@"change img success");
                        }
                    });
                } else {
                    NSLog(@"down load image %@ failed", tmp_item.item_name);
                }
            }];
            
            [cell.imgView setImage:img];
            
        } else if (tmp_item.item_type.unsignedIntegerValue == PostPreViewMovie) {
            NSLog(@"movie field");
            NSLog(@"%@", tmp_item.item_name);
            NSString* fullpath =[[TmpFileStorageModel BMTmpMovieDir]stringByAppendingPathComponent:tmp_item.item_name];
            NSURL* url = [TmpFileStorageModel enumFileWithName:tmp_item.item_name andType:tmp_item.item_type.unsignedIntegerValue withDownLoadFinishBlock:^(BOOL success, NSURL *path) {
                if (success) {
                    NSLog(@"down load movie %@ success", tmp_item.item_name);
                    [cell movieContentWithURL:path withTriat:trait];
//                    [cell playMovie];
                    AVAsset* asset = [AVAsset assetWithURL:path];
                    [asset loadValuesAsynchronouslyForKeys:@[@"duration"] completionHandler:^{
                        NSError* error = nil;
                        switch ([asset statusOfValueForKey:@"duration" error:&error]) {
                            case AVKeyValueStatusLoaded: {
                                AVAssetImageGenerator* gen = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
                                CMTime time = asset.duration;
                                time.value = 0.8 * time.timescale;
                                NSError* error = nil;
                                UIImage* download_img = [UIImage imageWithCGImage:[gen copyCGImageAtTime:time actualTime:&time error:&error]];
                                if (error) {
                                    NSLog(@"get thumbnails error: %@", error.description);
                                } else {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        cell.imgView.image = download_img;
                                        NSLog(@"change img success");
                                    });
                                }}
                                break;
                                
                            default: {
                                NSLog(@"load asset error: %@", error.description);
                                if ([[NSFileManager defaultManager] fileExistsAtPath:fullpath]) {
                                    NSLog(@"somethine wrong with the file you download, need to download again");
                                    [[NSFileManager defaultManager]removeItemAtPath:fullpath error:nil];
                                }}
                                break;
                        }
                    }];
                
                } else {
                    NSLog(@"down load movie %@ failed", tmp_item.item_name);
                }
            }];
            if (url) {
                [cell movieContentWithURL:[NSURL fileURLWithPath:fullpath] withTriat:trait];
//                [cell playMovie];
                AVAsset* asset = [AVAsset assetWithURL:[NSURL fileURLWithPath:fullpath]];
                AVAssetImageGenerator* gen = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
                CMTime time = asset.duration;
                time.value = 0.8 * time.timescale;
                NSError* error = nil;
                UIImage* download_img = [UIImage imageWithCGImage:[gen copyCGImageAtTime:time actualTime:&time error:&error]];
                if (error) {
                    NSLog(@"get thumbnails error: %@", error.description);
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.imgView.image = download_img;
                        NSLog(@"change img success");
                    });
                }
                
            }
            
        } else {
            NSLog(@"text field");
        }
     
        cell.delegate = self;
        cell.content = [_qm.querydata objectAtIndex:indexPath.section - 1];
//        cell.content = [_qm.querydata objectAtIndex:indexPath.row - 1];
        [cell setDescription:tmp.content_description];
        
        [cell setTime:tmp.content_post_date];
        [cell setTags:@"tags"];
        
        return cell;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {     // Default is 1 if not implemented
    return 2 + self.qm.querydata.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger total = [self numberOfSectionsInTableView:tableView];
    if (section == 0 || section == total - 1) {
        return 0;
    } else {
        return 1;
    }
//    return 2 + self.qm.querydata.count;
}

#pragma mark -- scroll refresh
- (void)dealloc {
    ((UIScrollView*)_queryView).delegate = nil;
    BWStatusBarOverlay* tmp = [BWStatusBarOverlay shared];
    [tmp removeGestureRecognizer:tap];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (!_isHandleScrolling) {
        return;
    }
    
    // 假设偏移表格高度的20%进行刷新
    if (!_isLoading) { // 判断是否处于刷新状态，刷新中就不执行
        // 取内容的高度：
        // 如果内容高度大于UITableView高度，就取TableView高度
        // 如果内容高度小于UITableView高度，就取内容的实际高度
        float height = scrollView.contentSize.height > _queryView.frame.size.height ?_queryView.frame.size.height : scrollView.contentSize.height;
       
        VIEW_BOUNTDS
        if (scrollView.contentOffset.y > [QueryCell preferredHeightWithDescription:@""] * 0.4) {
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            
            if (offset_y != 0 && offset_y - scrollView.contentOffset.y > 30) {
                showBack2Top = YES;
            }
            
            BWStatusBarOverlay* tmp = [BWStatusBarOverlay shared];
            if (tmp.isHidden && showBack2Top) {
                [[BWStatusBarOverlay shared] showSuccessWithMessage:@"back to top" duration:BACK_TO_TOP_TIME animated:YES];
                showBack2Top = NO;
            }
            _queryView.frame = QUERY_VIEW_SCROLL;
        } else {
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            showBack2Top = YES;
            BWStatusBarOverlay* tmp = [BWStatusBarOverlay shared];
            if (!tmp.isHidden) {
                [BWStatusBarOverlay dismissAnimated:YES];
            }
            _queryView.frame = QUERY_VIEW_START;
        }
       
        offset_y = scrollView.contentOffset.y;
        
        if ((height - scrollView.contentSize.height + scrollView.contentOffset.y) / height > 0.2) { // 调用上拉刷新方
            CGRect rc = _queryView.frame;
            rc.origin.y = rc.origin.y - 44;
            [_queryView setFrame:rc];
            [_qm appendQueryDataByUser:_current_user_id withToken:_current_auth_token andBeginIndex:_qm.querydata.count];
            rc.origin.y = rc.origin.y + 44;
            [_queryView setFrame:rc];
            [_queryView reloadData];
            return;
            
        } else if (- scrollView.contentOffset.y / _queryView.frame.size.height > 0.2) { // 调用下拉刷新方法
            _isLoading = YES;
            __block CGRect rc = _queryView.frame;
            rc.origin.y = rc.origin.y + 44;
            [_queryView setFrame:rc];
            [_qm refreshQueryDataByUser:_current_user_id withToken:_current_auth_token withFinishBlock:^{
                CGRect tmp = rc;
                rc.origin.y = rc.origin.y - 44;
//                [_queryView setFrame:rc];
                [_queryView reloadData];
                [self moveViewFromRect:tmp toRect:rc];
            }];

            return;
        }
        
        // move and change
    }

}

- (void)moveViewFromRect:(CGRect)begin toRect:(CGRect)end {
    static const CGFloat kAnimationDuration = 0.30; // in seconds
    [INTUAnimationEngine animateWithDuration:kAnimationDuration
                                       delay:0.0
                                      easing:INTUEaseInOutQuadratic
                                     options:INTUAnimationOptionNone
                                  animations:^(CGFloat progress) {
                                      _queryView.frame = INTUInterpolateCGRect(begin, end, progress);
                                      
                                      // NSLog(@"Progress: %.2f", progress);
                                  }
                                  completion:^(BOOL finished) {
                                      // NOTE: When passing INTUAnimationOptionRepeat, this completion block is NOT executed at the end of each cycle. It will only run if the animation is canceled.
                                      NSLog(@"%@", finished ? @"Animation Completed" : @"Animation Canceled");
                                      //                                                         self.animationID = NSNotFound;
                                      _isLoading = NO;
                                  }];
}


#pragma mark -- segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"HomeDetailSegue"]) {
        QueryCell* cell = (QueryCell*)sender;
        
        ((HomeDetailViewController*)(segue.destinationViewController)).qm = self.qm;
        ((HomeDetailViewController*)(segue.destinationViewController)).current_content = cell.content;
        ((HomeDetailViewController*)(segue.destinationViewController)).current_user_id = _current_user_id;
        ((HomeDetailViewController*)(segue.destinationViewController)).current_auth_token = _current_auth_token;

        if (cell && cell.type == PostPreViewMovie) {
            ((HomeDetailViewController*)(segue.destinationViewController)).player = cell.player;
            ((HomeDetailViewController*)(segue.destinationViewController)).current_image = cell.imgView.image;
        }
        self.tabBarController.tabBar.hidden = YES;
    } else if ([segue.identifier isEqualToString:@"search"]) {
        
    }
}

#pragma mark -- QueryCellActionProtocol
- (void)didSelectLikeBtn:(id)content {
//    QueryContent* cur = (QueryContent*)content;
//    NSLog(@"like post id: %@", cur.content_post_id);
//    
//    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    [delegate.pm postLikeToServiceWithPostID:cur.content_post_id];
}

- (void)didSelectShareBtn:(id)content {
//    QueryContent* cur = (QueryContent*)content;
    
}

- (void)didSelectCommentsBtn:(id)content {
//    QueryCell* cell = (QueryCell*)content;
//    
//    QueryContent* cur = cell.content;
//    NSLog(@"like post id: %@", cur.content_post_id);
    
//    [self performSegueWithIdentifier:@"HomeDetailSegue" sender:cell];
    [self performSegueWithIdentifier:@"HomeDetailSegue" sender:content];
}

- (void)didSelectCollectionBtn:(id)content {
    NSLog(@"collect for this user");
    QueryContent* cur = (QueryContent*)content;
    NSLog(@"like post id: %@", cur.content_post_id);

    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [delegate.pm postLikeToServiceWithPostID:cur.content_post_id withFinishBlock:^(BOOL success, QueryContent *content) {
        if (success) {
            NSLog(@"like post success");
            NSString* msg = @"like post success";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:msg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
            [alert show];
        }
    }];
}

- (void)didSelectNotLikeBtn:(id)content {
    
}

#pragma mark -- search controller
- (void)didSelectSearchBtn:(id)content {
    [self performSegueWithIdentifier:@"search" sender:nil];
}
@end
