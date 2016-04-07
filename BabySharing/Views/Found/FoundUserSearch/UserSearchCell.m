//
//  UserSearchCell.m
//  BabySharing
//
//  Created by Alfred Yang on 9/12/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import "UserSearchCell.h"
#import "TmpFileStorageModel.h"

#import "MessageFriendsCell.h"
#import "AlbumTableCell.h"

#import "QueryContent.h"
#import "QueryContentItem.h"
#import "Define.h"
#import "HomeViewController.h"
#import "UserHomeViewDataDelegate.h"
#import "AppDelegate.h"

#define CELL_HEADER_HEIGHT  59
#define CELL_FOOTER_HEIGHT  10

#define PHOTO_PER_LINE      3


#define HEARDER_CELL_INDEX  0
#define CONTENT_CELL_INDEX  1
#define FOOTER_CELL_INDEX   2

#define CELL_COUNTS         3

@interface UserSearchCell () <UITableViewDataSource, UITableViewDelegate, AlbumTableCellDelegate, MessageFriendsCellDelegate> {
    UITableView* queryView;
//    UIView* marginView;
    
    NSString* screen_photo;
    NSString* screen_name;
//    NSInteger relations;
    NSString* role_tag;
//
    NSArray* contents;
    UIView *upline;
    UIView *downline;
}

@end

@implementation UserSearchCell

@synthesize delegate = _delegate;
@synthesize user_id = _user_id;
@synthesize screen_name = _screen_name;
@synthesize connections = _connections;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
    queryView = [[UITableView alloc] init];
    queryView.backgroundColor = [UIColor whiteColor];
    queryView.scrollEnabled = NO;
    queryView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:queryView];
    self.contentView.backgroundColor = Background;
    queryView.delegate = self;
    queryView.dataSource = self;

    downline = [[UIView alloc] init];
    downline.backgroundColor = DownLineColor;
    upline = [[UIView alloc] init];
    upline.backgroundColor = UpLineColor;
    [queryView registerNib: [UINib nibWithNibName:@"MessageFriendsCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Header Cell"];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    queryView.frame = CGRectMake(4, 0, self.bounds.size.width, self.bounds.size.height - 5);
    upline.frame = CGRectMake(0, CGRectGetHeight(queryView.frame) - 1, CGRectGetWidth(queryView.frame), 10);
    downline.frame = CGRectMake(0, 0, CGRectGetWidth(queryView.frame), 1);
    [queryView addSubview:upline];
    [queryView bringSubviewToFront:upline];
    [queryView addSubview:downline];
    [queryView bringSubviewToFront:downline];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUserHeaderWithScreenName:(NSString*)name roleTag:(NSString*)tag andScreenPhoto:(NSString*)photo {
    if (name.length > 0) {
        screen_name = name;
    } else {
        screen_name = @"";
    }
    
    if (tag.length > 0) {
        role_tag = tag;
    } else {
        role_tag = @"";
    }
    
    if (photo.length > 0) {
        screen_photo = photo;
    } else {
        screen_photo = @"";
    }
}

- (void)setUserContentImages:(NSArray*)arr {
    contents = arr;
}

+ (CGFloat)preferredHeight {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat img_height = width / PHOTO_PER_LINE;
    return CELL_HEADER_HEIGHT + img_height + CELL_FOOTER_HEIGHT + 5;
}

- (void)setConnections:(UserPostOwnerConnections)connections {
    _connections = connections;
    [queryView reloadData];
}

#pragma mark -- table view datasource and delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return CELL_HEADER_HEIGHT;
    } else if (indexPath.row == 1) {
        return ([UIScreen mainScreen].bounds.size.width - 64) / PHOTO_PER_LINE - 5;
    } else {
        return CELL_FOOTER_HEIGHT;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        MessageFriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Header Cell"];
        
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MessageFriendsCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
//        NSDictionary* tmp = [data_arr objectAtIndex:indexPath.row];
        cell.delegate = self;
        cell.cellHeight = CELL_HEADER_HEIGHT;
        [cell setUserScreenPhoto:screen_photo];
        [cell setRelationship:_connections];
        [cell setUserScreenName:screen_name];
        [cell setUserRoleTag:role_tag];
        cell.isHiddenLine = YES;
        
        return cell;
    } else if (indexPath.row == 1) {
        AlbumTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlbumTableViewCell"];
        
        if (cell == nil) {
            cell = [[AlbumTableCell alloc]init];
        }
        
        cell.delegate = self;
        NSInteger row = 0;//indexPath.row;
        if (contents.count > 0) {
            @try {
                NSArray* arr_tmp = [contents objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(row * PHOTO_PER_LINE, PHOTO_PER_LINE)]];
                NSMutableArray* arr_content = [[NSMutableArray alloc]initWithCapacity:PHOTO_PER_LINE];
                for (NSDictionary* item in arr_tmp) {
                    NSDictionary* dic = ((NSArray*)[item objectForKey:@"items"]).firstObject;
                    [arr_content addObject:[dic objectForKey:@"name"]];
                }
                [cell setUpContentViewWithImageNames:arr_content atLine:row andType:AlbumControllerTypePhoto];
                cell.cannot_selected = YES;
            }
            @catch (NSException *exception) {
                NSArray* arr_tmp = [contents objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(row * PHOTO_PER_LINE, contents.count - row * PHOTO_PER_LINE)]];
                NSMutableArray* arr_content = [[NSMutableArray alloc]initWithCapacity:PHOTO_PER_LINE];
                for (NSDictionary* item in arr_tmp) {
                    NSDictionary* dic = ((NSArray*)[item objectForKey:@"items"]).firstObject;
                    [arr_content addObject:[dic objectForKey:@"name"]];
                }
                [cell setUpContentViewWithImageNames:arr_content atLine:row andType:AlbumControllerTypePhoto];
                cell.cannot_selected = YES;
            }
        }
        
        return cell;
    
    } else {
    
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"default"];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"default"];
        }
        
//        if ([cell viewWithTag:1] == nil) {
//            UIView* bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 25)];
//            bgView.backgroundColor = [UIColor whiteColor];
//            [cell addSubview:bgView];
//        }
//        
//        if ([cell viewWithTag:2] == nil) {
//            UIView* marginView = [[UIView alloc]initWithFrame:CGRectMake(0, 25, [UIScreen mainScreen].bounds.size.width, 10)];
//            marginView.backgroundColor = [UIColor colorWithWhite:0.9490 alpha:1.f];
//            [cell addSubview:marginView];
//            
//            CALayer* layer = [CALayer layer];
//            layer.borderWidth = 1.f;
//            layer.borderColor = [UIColor colorWithWhite:0.5922 alpha:0.35].CGColor;
//            layer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 1);
//            [marginView.layer addSublayer:layer];
//            
//            CALayer* line = [CALayer layer];
//            line.borderWidth = 1.f;
//            line.borderColor = [UIColor colorWithWhite:0.5922 alpha:0.10].CGColor;
//            line.frame = CGRectMake(0, 10 - 1, [UIScreen mainScreen].bounds.size.width, 1);
//            [marginView.layer addSublayer:line];
//        }
        
        return cell;
    }
}

#pragma mark -- Album Cell Delegate
#pragma mark -- album cell delegate
- (NSInteger)getViewsCount {
    return PHOTO_PER_LINE;
}

- (NSInteger)indexByRow:(NSInteger)row andCol:(NSInteger)col {
    return row * PHOTO_PER_LINE + col;
}

- (BOOL)isSelectedAtIndex:(NSInteger)index {
    return NO;
}

- (BOOL)isAllowMultipleSelected {
    return NO;
}

- (void)didSelectOneImageAtIndex:(NSInteger)index {
    [_delegate didSelectedUserContentImages:0 andUserID:_user_id andUserScreenName:_screen_name];
}

- (void)didUnSelectOneImageAtIndex:(NSInteger)index {
}

#pragma mark -- message friend cell delegate
- (void)didSelectedScreenPhoto:(NSString *)user_id {
    [_delegate didSelectedUserScreenPhoto:_user_id];
}

//-(void)didSelectedRelationBtn:(NSString *)user_id andCurrentRelation:(UserPostOwnerConnections)connections origin:(NSObject *)cell

- (void)didSelectedRelationBtn:(NSString *)user_id andCurrentRelation:(UserPostOwnerConnections)connections origin:(NSObject *)cell{
//    [_delegate didSelectedUserContentImages:0 andUserID:user_id];
    NSLog(@"tags 01 --- %ld",(long)_connections);
    [_delegate didSelectedUserRelationsUserID:_user_id andCurrentConnection:_connections];
    
}

@end
