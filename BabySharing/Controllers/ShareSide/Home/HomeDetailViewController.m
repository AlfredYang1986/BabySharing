//
//  HomeDetailViewController.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 12/01/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "HomeDetailViewController.h"
#import "QueryContent+ContextOpt.h"
#import "TmpFileStorageModel.h"
#import "QueryContentItem.h"
#import "HomeCommentsController.h"
#import "QueryComments.h"
#import "UserProfileViewController.h"

#pragma mark -- cells
#import "QueryCommentsCell.h"
#import "QueryDetailImageCell.h"
#import "QueryLikesCell.h"
#import "CommentsHeaderAndFooterCell.h"
#import "QueryOwnerCell.h"
#import "QueryDescriptionCell.h"
#import "CommentsHeader.h"

#pragma mark -- for animation
#import "INTUAnimationEngine.h"
#import "AppDelegate.h"

#pragma mark -- for tags
#import "QueryContentTag.h"
#import "HomeTagsController.h"

#pragma mark -- secter numbers
//#define REFERSH_HEADER                  0
#define OWNER_NAME_SECTOR               0
#define ITEM_SECTOR                     1
#define OWNER_DESCRIPTION_SECTOR        2
#define LIKES_SECTOR                    3
//#define HOT_COMMENTS_TITLE_SECTOR       4
//#define HOT_COMMENTS_SECTOR             5
//#define RESENT_COMMENTS_TITLE_SECTOR    6
//#define RESENT_COMMENTS_SECTOR          7
//#define APPEND_FOOTER                   8

#define TOTAL_SECTORS                   4

#define CHECK_SECTOR(lhs, rhs)        \
    if (lhs == rhs) break;

@interface HomeDetailViewController () {
    NSArray* comments_array;
    
    BOOL isLoading;
}
@property (weak, nonatomic) IBOutlet UITableView *queryView;
@property (weak, nonatomic) IBOutlet UITextField *inputView;

@property (weak, nonatomic) IBOutlet UIButton *commentsBtn;
@property (weak, nonatomic) IBOutlet UIButton *collectionBtn;
@property (weak, nonatomic) IBOutlet UIButton *pushBtn;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@end

@implementation HomeDetailViewController {
    NSInteger selected_tag_type;
    NSString* selected_tag_name;
    
    UIView* inputContainer;
    UITextField* input;
}

@synthesize queryView = _queryView;
@synthesize inputView = _inputView;

@synthesize qm = _qm;
@synthesize cm = _cm;
@synthesize current_content = _current_content;
@synthesize current_user_id = _current_user_id;
@synthesize current_auth_token = _current_auth_token;

#pragma mark -- only for move play
@synthesize player = _player;
@synthesize current_image = _current_image;

@synthesize commentsBtn = _commentsBtn;
@synthesize collectionBtn = _collectionBtn;
@synthesize pushBtn = _pushBtn;
@synthesize backBtn = _backBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    comments_array = [_current_content.comments.allObjects sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if ([((QueryComments*)obj1).comment_date timeIntervalSince1970] <= [((QueryComments*)obj2).comment_date timeIntervalSince1970])
            return NSOrderedDescending;
        else
            return NSOrderedAscending;
    }];
   
    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    _cm = app.cm;
    
    /**
     * comments header and footer
     */
//    [_queryView registerNib:[UINib nibWithNibName:@"CommentsHeaderAndFooterCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"comments header and footer"];
    
    /**
     * comments cell
     */
    [_queryView registerNib:[UINib nibWithNibName:@"QueryCommentsCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"comments cell"];
    
    /**
     * detail image cell
     */
    [_queryView registerNib:[UINib nibWithNibName:@"QueryDetailImageCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"detail image cell"];
    
    /**
     * owner cell
     */
    [_queryView registerNib:[UINib nibWithNibName:@"QueryOwnerCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"owner cell"];
    
    /**
     * likes cell
     */
    [_queryView registerNib:[UINib nibWithNibName:@"QueryLikesCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"likes photo cell"];
    
    /**
     * owner description cell
     */
    [_queryView registerNib:[UINib nibWithNibName:@"QueryDescriptionCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"owner description cell"];

    /**
     * header
     */
    [_queryView registerClass:[CommentsHeader class] forHeaderFooterViewReuseIdentifier:@"Comments Header"];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didFinishDownloadImage:) name:@"download finish" object:nil];
  
    _queryView.frame = CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    _inputView.delegate = self;
    isLoading = NO;
    
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    [_commentsBtn setImage:[UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"Comments"] ofType:@"png"]] forState:UIControlStateNormal];
    _commentsBtn.layer.borderWidth = 1.f;
    _commentsBtn.layer.borderColor = [UIColor blueColor].CGColor;
    _commentsBtn.layer.cornerRadius = 15.f;
    _commentsBtn.clipsToBounds = YES;
    
    [_collectionBtn setImage:[UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"Star"] ofType:@"png"]] forState:UIControlStateNormal];
    _collectionBtn.layer.borderWidth = 1.f;
    _collectionBtn.layer.borderColor = [UIColor blueColor].CGColor;
    _collectionBtn.layer.cornerRadius = 15.f;
    _collectionBtn.clipsToBounds = YES;
    
    [_pushBtn setImage:[UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"Push"] ofType:@"png"]] forState:UIControlStateNormal];
    _pushBtn.layer.borderWidth = 1.f;
    _pushBtn.layer.borderColor = [UIColor blueColor].CGColor;
    _pushBtn.layer.cornerRadius = 15.f;
    _pushBtn.clipsToBounds = YES;
    
    [_backBtn setImage:[UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"Previous_blue"] ofType:@"png"]] forState:UIControlStateNormal];
    _backBtn.layer.borderWidth = 1.f;
    _backBtn.layer.borderColor = [UIColor blueColor].CGColor;
    _backBtn.layer.cornerRadius = 15.f;
    _backBtn.clipsToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
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
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if (indexPath.section == 0) {
        NSInteger range = [self checkRangeNameWithIndex:indexPath.row];
        switch (range) {
    //        case REFERSH_HEADER:
    //        case APPEND_FOOTER:
    //            return 44;
                
            case OWNER_NAME_SECTOR:
                return 46;
                
            case ITEM_SECTOR:
                return [QueryDetailImageCell getPerferCellHeight];
                
            case OWNER_DESCRIPTION_SECTOR:
                return [QueryDescriptionCell preferHeightWithUserDescription:_current_content.content_description];
                
            case LIKES_SECTOR:
                return 44;
                
    //        case HOT_COMMENTS_TITLE_SECTOR:
    //            return 36;
    //            
    //        case RESENT_COMMENTS_TITLE_SECTOR:
    //            return 36;
    //            
    //        case HOT_COMMENTS_SECTOR:
    //        case RESENT_COMMENTS_SECTOR:
    //            return 101;
                
            default:
                NSLog(@"wrong with ranges");
                return -1;
        }
    } else {
        QueryComments* item = [comments_array objectAtIndex:indexPath.row];
        return [QueryCommentsCell preferredHeightWithComment:item.comment_content];
    }

}

#pragma mark -- table view datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }

    CommentsHeader* header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"Comments Header"];
    
    if (header == nil) {
        header = [[CommentsHeader alloc]initWithReuseIdentifier:@"Comments Header"];
    }
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else {
        return 44;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if ([view isKindOfClass:[UITableViewHeaderFooterView class]]) {
        ((UITableViewHeaderFooterView*)view).backgroundView.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.6];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        NSInteger range = [self checkRangeNameWithIndex:indexPath.row];
        
        switch (range) {
                //        case REFERSH_HEADER:
                //            return [self queryDefaultCellInitWithTableView:tableView withTitle:@"refreshing ..."];
//            case APPEND_FOOTER:
//                return [self queryDefaultCellInitWithTableView:tableView withTitle:@"more comments ..."];
                
            case OWNER_NAME_SECTOR:
                return [self queryOwnerCellInitWithTableView:tableView];
                
            case ITEM_SECTOR: {
                NSRange r = [self rangeOfSector:range];
                NSInteger item_index = indexPath.row - r.location;
                return [self queryImageCellInitWithTableView:tableView andIndex:item_index];
            }
                
            case OWNER_DESCRIPTION_SECTOR:
                return [self queryDescriptionCellInitWithTableView:tableView];
                
            case LIKES_SECTOR:
                return [self queryLikesCellInitWithTableView:tableView];
                
//            case HOT_COMMENTS_TITLE_SECTOR:
//                return [self queryCommentsTitleWithTableView:tableView andTitle:@"Hot Comments"];
//                
//            case HOT_COMMENTS_SECTOR: {
//                NSRange r = [self rangeOfSector:range];
//                NSInteger comment_index = indexPath.row - r.location;
//                return [self queryCommentsCellWithTableView:tableView andIndex:comment_index];
//            }
//                
//            case RESENT_COMMENTS_TITLE_SECTOR:
//                return [self queryCommentsTitleWithTableView:tableView andTitle:@"Resent Comments"];
//                
//            case RESENT_COMMENTS_SECTOR: {
//                NSRange r = [self rangeOfSector:range];
//                NSInteger comment_index = indexPath.row - r.location;
//                return [self queryCommentsCellWithTableView:tableView andIndex:comment_index];
//            }
                
            default:
                NSLog(@"wrong with ranges");
                return nil;
        }
    } else {
        NSInteger comment_index = indexPath.row;
        return [self queryCommentsCellWithTableView:tableView andIndex:comment_index];
    }
}

- (NSInteger)checkRangeNameWithIndex:(NSInteger)index {
    for (NSInteger tmp = 0; tmp < TOTAL_SECTORS; ++tmp) {
        NSRange tr = [self rangeOfSector:tmp];
        if (index >= tr.location && index < tr.location + tr.length) {
            return tmp;
        }
    }
    NSLog(@"error with range");
    return -1;
}

- (NSRange)rangeOfSector:(NSInteger)secter {
    NSRange result;
    
    switch (secter) {
//        case REFERSH_HEADER:
        case OWNER_NAME_SECTOR:
        case ITEM_SECTOR:
        case OWNER_DESCRIPTION_SECTOR:
        case LIKES_SECTOR:
//        case HOT_COMMENTS_TITLE_SECTOR:
//        case HOT_COMMENTS_SECTOR:
//        case RESENT_COMMENTS_TITLE_SECTOR:
//        case RESENT_COMMENTS_SECTOR:
//        case APPEND_FOOTER:
            result.location = 0;
//            result.length = 1;
//            CHECK_SECTOR(secter,REFERSH_HEADER);
//            
//            result.location += result.length;
            result.length = [self enumOwnerNameCount];
            CHECK_SECTOR(secter, OWNER_NAME_SECTOR);
            
            result.location += result.length;
            result.length = [self enumItemCount];
            CHECK_SECTOR(secter, ITEM_SECTOR);
            
            result.location += result.length;
            result.length = [self enumOwnerDescriptionCount];
            CHECK_SECTOR(secter, OWNER_DESCRIPTION_SECTOR);
            
            result.location += result.length;
            result.length = [self enumLikeColCount];
            CHECK_SECTOR(secter, LIKES_SECTOR);
           
//            result.location += result.length;
//            result.length = [self enumMostPopularTitleCount];
//            CHECK_SECTOR(secter, HOT_COMMENTS_TITLE_SECTOR);
//            
//            result.location += result.length;
//            result.length = [self enumMostPopularCommentsCount];
//            CHECK_SECTOR(secter, HOT_COMMENTS_SECTOR);
//           
//            result.location += result.length;
//            result.length = [self enumResentsCommentsTitleCount];
//            CHECK_SECTOR(secter, RESENT_COMMENTS_TITLE_SECTOR);
//           
//            result.location += result.length;
//            result.length = [self enumResentsCommentsCount];
//            CHECK_SECTOR(secter, RESENT_COMMENTS_SECTOR);
//
//            result.location += result.length;
//            result.length = 1;
//            CHECK_SECTOR(secter, APPEND_FOOTER);
      
        default:
            NSLog(@"wrong with ranges");
            break;
    }
    return result;
}

- (NSInteger)enumOwnerNameCount { return 1; }
- (NSInteger)enumItemCount { return _current_content.items.count; }
- (NSInteger)enumOwnerDescriptionCount { return 1; }
- (NSInteger)enumLikeColCount { return 1; }
- (NSInteger)enumMostPopularTitleCount { return 1; }
- (NSInteger)enumMostPopularCommentsCount {
    return MIN(2, _current_content.comments.count);
}
- (NSInteger)enumResentsCommentsTitleCount { return 1; }
- (NSInteger)enumResentsCommentsCount { return _current_content.comments.count; }

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 
    if (section == 0) {
        return //1 +        // refresh header
           [self enumOwnerNameCount] // Owner name Sector
         + [self enumItemCount] // item (photo or movie)
         + [self enumOwnerDescriptionCount] // owner description input
         + [self enumLikeColCount];      // like coloum
//         + [self enumMostPopularTitleCount]     // title says hot comments
//         + [self enumMostPopularCommentsCount]  // hot comment
//         + [self enumResentsCommentsTitleCount] // resent comments title
//         + [self enumResentsCommentsCount] + 1;      // all comments goes here
    } else {
//        return [self enumResentsCommentsCount] + 1;
        return [self enumResentsCommentsCount];
    }
}

- (void)dealloc {
    ((UIScrollView*)_queryView).delegate = nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 假设偏移表格高度的20%进行刷新
    // 假设偏移表格高度的20%进行刷新
    if (!isLoading) { // 判断是否处于刷新状态，刷新中就不执行
        // 取内容的高度：
        // 如果内容高度大于UITableView高度，就取TableView高度
        // 如果内容高度小于UITableView高度，就取内容的实际高度
        float height = scrollView.contentSize.height > _queryView.frame.size.height ?_queryView.frame.size.height : scrollView.contentSize.height;
        if ((height - scrollView.contentSize.height + scrollView.contentOffset.y) / height > 0.2) { // 调用上拉刷新方
            
            isLoading = YES;
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
            isLoading = NO;
        }
        
        if (- scrollView.contentOffset.y / _queryView.frame.size.height > 0.2) { // 调用下拉刷新方法
            
            // refresh comments
            isLoading = YES;
            CGRect rc = _queryView.frame;
            rc.origin.y = rc.origin.y + 44;
            [_queryView setFrame:rc];
            
            _current_content = [_qm refreshCommentsByUser:_current_user_id withToken:_current_auth_token andPostID:_current_content.content_post_id];
            rc.origin.y = rc.origin.y - 44;
            [_queryView setFrame:rc];
            //            [_queryView reloadData];
            [self commentUpdate:nil];
            isLoading = NO;
        }
    }
}

#pragma mark -- private
- (QueryDescriptionCell*)queryDescriptionCellInitWithTableView:(UITableView*)tableView {
    
    QueryDescriptionCell* cell = [tableView dequeueReusableCellWithIdentifier:@"owner description cell"];
    
    if (cell == nil) {
        NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"QueryDescriptionCell" owner:self options:nil];
        cell = [nib firstObject];
    }
   
    [cell setDescription:_current_content.content_description];
    [cell setTags:@"alfred tags"];
    [cell setTime:_current_content.content_post_date];
    
    return cell;
}

- (QueryDetailImageCell*)queryImageCellInitWithTableView:(UITableView*)tableView andIndex:(NSInteger)index {
    
    QueryDetailImageCell* cell = [tableView dequeueReusableCellWithIdentifier:@"detail image cell"];
   
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"QueryDetailImageCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    QueryContentItem* item = [_current_content.items.allObjects objectAtIndex:index];
    
    if (item.item_type.integerValue != PostPreViewMovie) {
        //    cell.imgView.image =[TmpFileStorageModel enumImageWithName:item.item_name withTableView:tableView inIndex:indexPath];
        cell.imgView.image =[TmpFileStorageModel enumImageWithName:item.item_name withDownLoadFinishBolck:^(BOOL success, UIImage *download_img) {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (cell) {
                        cell.imgView.image = download_img;
                        NSLog(@"change img success");
                    }
                });
            } else {
                NSLog(@"down load image %@ failed", item.item_name);
            }
        }];
        
        /**
         * only add tags on the first image item
         */
        if (index == 0) {
            for (QueryContentTag* tag in _current_content.tags.allObjects) {
                [cell addTagWithType:tag.tag_type.integerValue andContent:tag.tag_content withPositionX:tag.tag_offset_x.doubleValue andPositionY:tag.tag_offset_y.doubleValue];
            }
        }
    } else {
        cell.type = item.item_type.integerValue;
        cell.imgView.image = _current_image;
        cell.player = _player;
    }
        
    cell.delegate = self;
    return cell;
}

- (UITableViewCell*)queryDefaultCellInitWithTableView:(UITableView*)tableView withTitle:(NSString*)title {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"default"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"default"];
    }
    
    cell.textLabel.text = title;
    return cell;
}

- (QueryOwnerCell*)queryOwnerCellInitWithTableView:(UITableView*)tableView {
    QueryOwnerCell* cell = [tableView dequeueReusableCellWithIdentifier:@"owner cell"];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"QueryOwnerCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }

    [cell setUserName:_current_content.owner_name];
    [cell setUserPhoto:_current_content.owner_photo];
    [cell setLocation:@"中国 北京"];
    [cell setRoleTag:@"role tag"];
    UserPostOwnerConnections con = _current_content.relations.integerValue;
    [cell setConnections:con];
   
    dispatch_queue_t q = dispatch_queue_create("relation query", nil);
    dispatch_async(q, ^{
        [_qm queryRelationsWithPost:_current_content.content_post_id withFinishBlock:^{
            UserPostOwnerConnections con = _current_content.relations.integerValue;
            dispatch_async(dispatch_get_main_queue(), ^{
                [cell setConnections:con];
            });
        }];
    });
    
    cell.owner_id = _current_content.owner_id;
    
    cell.delegate = self;
    return cell;
}

- (QueryLikesCell*)queryLikesCellInitWithTableView:(UITableView*)tableView {
     QueryLikesCell* cell = [tableView dequeueReusableCellWithIdentifier:@"likes photo cell"];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"QueryLikesCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
   
    cell.likesLabel.text = [NSString stringWithFormat:@"%d likes", _current_content.likes_count.intValue];
    [cell setPhotoNameList:_current_content];
    cell.delegate = self;
    
    return cell;   
}

- (CommentsHeaderAndFooterCell*)queryCommentsTitleWithTableView:(UITableView*)tableView andTitle:(NSString*)title {
    
    CommentsHeaderAndFooterCell* cell = [tableView dequeueReusableCellWithIdentifier:@"comments header and footer"];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CommentsHeaderAndFooterCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
   
    cell.messageLabel.text = title;
    cell.state = CommentsHeaderAndFooterStatesHeader;
    return cell;
}

- (QueryCommentsCell*)queryCommentsCellWithTableView:(UITableView*)tableView andIndex:(NSInteger)index {
    QueryCommentsCell* cell = [tableView dequeueReusableCellWithIdentifier:@"comments cell"];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"QueryCommentsCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
   
//    QueryComments* item = [_current_content.comments.allObjects objectAtIndex:index];
    if (comments_array.count > 0) {

        QueryComments* item = [comments_array objectAtIndex:index];
        cell.current_comments = item;
        
        [cell setTime:item.comment_date];
        [cell setCommentOwnerName:item.comment_owner_name];
        [cell setCommentOwnerPhoto:item.comment_owner_photo];
        [cell setTags:@"tags test"];
        [cell setComments:item.comment_content];
    }
    
    return cell;
}


#pragma mark -- QueryDetailActionDelegate
- (void)didSelectDetialImageTagsWithContents:(NSString*)tag_name {
    NSLog(@"tag select with %@", tag_name);
}

- (void)didSelectDetialFollowOwner:(QueryOwnerCell*)cell {
    NSLog(@"folow");
    NSString* follow_user_id = _current_content.owner_id;
 
    switch (_current_content.relations.integerValue) {
        case UserPostOwnerConnectionsSamePerson:
            // my own post, do nothing
            break;
        case UserPostOwnerConnectionsNone:
        case UserPostOwnerConnectionsFollowed: {
            [_cm followOneUser:follow_user_id withFinishBlock:^(BOOL success, NSString *message) {
                if (success) {
                    NSLog(@"follow success");
                    if (_current_content.relations.integerValue == UserPostOwnerConnectionsNone) {
                        [_qm refreshLocalRelationsWithPost:_current_content.content_post_id withConnections:UserPostOwnerConnectionsFollowing];
                    } else {
                        [_qm refreshLocalRelationsWithPost:_current_content.content_post_id withConnections:UserPostOwnerConnectionsFriends];
                    }
                    UserPostOwnerConnections con = [_qm queryLocalRelationsWithPost:_current_content.content_post_id];
                    [cell setConnections:con];
                } else {
                    NSLog(@"follow error, %@", message);
                }
            }];}
            break;
        case UserPostOwnerConnectionsFollowing:
        case UserPostOwnerConnectionsFriends: {
            [_cm unfollowOneUser:follow_user_id withFinishBlock:^(BOOL success, NSString *message) {
                if (success) {
                    NSLog(@"follow success");
                    if (_current_content.relations.integerValue == UserPostOwnerConnectionsFollowing) {
                        [_qm refreshLocalRelationsWithPost:_current_content.content_post_id withConnections:UserPostOwnerConnectionsNone];
                    } else {
                        [_qm refreshLocalRelationsWithPost:_current_content.content_post_id withConnections:UserPostOwnerConnectionsFollowed];
                    }
                    UserPostOwnerConnections con = [_qm queryLocalRelationsWithPost:_current_content.content_post_id];
                    [cell setConnections:con];
                } else {
                    NSLog(@"follow error, %@", message);
                }
            }];}
            break;
        default:
            break;
    }
}

- (void)didSelectDetialOwnerNameOrImage:(NSString*)owner_id {
    NSLog(@"owner details with id: %@", owner_id);
    [self performSegueWithIdentifier:@"Detial2ProfileSegue" sender:owner_id];
}

- (void)didSelectDetialLikeBtn {
    NSLog(@"like this post");
}

- (void)didSelectDetialCommentDetailWithIndex:(NSInteger)index {
    NSLog(@"select %ld comments", (long)index);
}

- (void)didSelectDetialMoreComments {
    NSLog(@"show all comments");
    [self performSegueWithIdentifier:@"MoreCommentsSegue" sender:nil];
}

- (void)didSelectTagWithType:(NSInteger)type andName:(NSString*)name {
    NSLog(@"show all tags content");
    selected_tag_type = type;
    selected_tag_name = name;
    [self performSegueWithIdentifier:@"tagSegue" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"MoreCommentsSegue"]) {
        ((HomeCommentsController*)(segue.destinationViewController)).qm = self.qm;
        ((HomeCommentsController*)(segue.destinationViewController)).current_content = _current_content;
        ((HomeCommentsController*)(segue.destinationViewController)).current_user_id = _current_user_id;
        ((HomeCommentsController*)(segue.destinationViewController)).current_auth_token = _current_auth_token;
        
    } else if ([segue.identifier isEqualToString:@"Detial2ProfileSegue"]) {
       
        ((UserProfileViewController*)segue.destinationViewController).onwer_id = (NSString*)sender;
    } else if ([segue.identifier isEqualToString:@"tagSegue"]) {
        ((HomeTagsController*)segue.destinationViewController).tag_name = selected_tag_name;
        ((HomeTagsController*)segue.destinationViewController).tag_type = selected_tag_type;
    }
}

#pragma mark -- text field delegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag==0) {
        [self moveView:296];
    }
    
    if (textField.tag==1) {
        [self moveView:600];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (input && ![input.text isEqualToString:@""]) {
        [self postComment];
        input.text = @"";
    }
    [input resignFirstResponder];
    return NO;
}

- (void)moveView:(float)move {
    static const CGFloat kAnimationDuration = 0.30; // in seconds
    CGRect frame = inputContainer.frame;
    CGRect frameNew = CGRectMake(frame.origin.x, frame.origin.y + move, frame.size.width, frame.size.height);
    [INTUAnimationEngine animateWithDuration:kAnimationDuration
                                       delay:0.0
                                      easing:INTUEaseInOutQuadratic
                                     options:INTUAnimationOptionNone
                                  animations:^(CGFloat progress) {
                                      inputContainer.frame = INTUInterpolateCGRect(frame, frameNew, progress);
                                      
                                      // NSLog(@"Progress: %.2f", progress);
                                  }
                                  completion:^(BOOL finished) {
                                      // NOTE: When passing INTUAnimationOptionRepeat, this completion block is NOT executed at the end of each cycle. It will only run if the animation is canceled.
                                      NSLog(@"%@", finished ? @"Animation Completed" : @"Animation Canceled");
                                      //                                                         self.animationID = NSNotFound;
                                  }];
}

#pragma mark -- post comments
- (IBAction)postComment {
    NSLog(@"post Comment");
    /**
     * 1. check post is validate or not
     */
    /**
     * 2. post comment to the service
     */
    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    _current_content = [delegate.pm postCommentToServiceWithPostID:_current_content.content_post_id andCommentContent:input.text];
    
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

#pragma mark -- button actions
- (IBAction)collectionBtnSelected {
    NSLog(@"collect for this user");
     AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    _current_content = [delegate.pm postLikeToServiceWithPostID:_current_content.content_post_id];
    [_queryView reloadData];
}

- (IBAction)commentsBtnSelected {
    NSLog(@"start to add a comment");
    if (inputContainer == nil) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat height_offset = [UIScreen mainScreen].bounds.size.height;
    
        inputContainer = [[UIView alloc]initWithFrame:CGRectMake(0, height_offset, width, 44)];
        inputContainer.backgroundColor = [UIColor grayColor];
        
        input = [[UITextField alloc]initWithFrame:CGRectMake(8, 6, width - 100, 32)];
        input.layer.borderWidth = 1.f;
        input.layer.borderColor = [UIColor blackColor].CGColor;
        input.layer.cornerRadius = 4.f;
        input.clipsToBounds = YES;
        input.delegate = self;
        input.backgroundColor = [UIColor whiteColor];
        [inputContainer addSubview:input];
        
        UIButton* btn_emoji = [[UIButton alloc]initWithFrame:CGRectMake(width - 90, 6, 30, 30)];
        
        NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
        NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
        [btn_emoji setImage:[UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"Face"] ofType:@"png"]] forState:UIControlStateNormal];
        [inputContainer addSubview:btn_emoji];
       
       
        UIButton* btn_func = [[UIButton alloc]initWithFrame:CGRectMake(width - 40, 6, 30, 30)];
        [btn_func setImage:[UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"Plus"] ofType:@"png"]] forState:UIControlStateNormal];
        [inputContainer addSubview:btn_func];
        
        [self.view addSubview:inputContainer];
        [self.view bringSubviewToFront:inputContainer];
    }
 
    if (![input isFirstResponder]) {
        [input becomeFirstResponder];
        [self moveView:-296];
    }
}

- (IBAction)pushBtnSelected {
    NSLog(@"start to push");
}

- (IBAction)backBtnSelected {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
