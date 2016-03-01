//
//  PersonalCentreOthersDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 7/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//
#import "PersonalCentreOthersDelegate.h"
//#import "ProfileOthersOverview.h"
#import "OwnerQueryModel.h"
#import "QueryContent+ContextOpt.h"
#import "QueryContentItem.h"
#import "PersonalCenterDefines.h"

#import "profileOverView.h"

@interface PersonalCentreOthersDelegate ()

@end

@implementation PersonalCentreOthersDelegate

@synthesize delegate = _delegate;

#pragma mark -- UITableView Delegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        ProfileOverView* header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"Profile Others Overview"];
        
        if (header == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ProfileOverView" owner:self options:nil];
            header = [nib objectAtIndex:0];
        }
        
        [header setOwnerPhoto:[_delegate getPhotoName]];
        [header setLoation:[_delegate getLocation]];
//        [header setFriendsCount:[_delegate getFriendsCount]];
//        [header setShareCount:[_delegate getSharedCount]];
//        [header setCycleCount:[_delegate getCycleCount]];
        [header setPersonalSign:[_delegate getSign]];
        [header setNickName:[_delegate getNickName]];
        [header setRoleTag:[_delegate getRoleTag]];
        
        [header setRelations:[_delegate getRelations]];
        
        header.deleagate = _delegate;
        
        return header;
        
    } else return nil;
}

#pragma mark -- UITableView DataSource
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if (section == 0 && [view isKindOfClass:[UITableViewHeaderFooterView class]]) {
        ((UITableViewHeaderFooterView *)view).tintColor = [UIColor whiteColor];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
//        return [ProfileOthersOverView preferredHeight];
        return [ProfileOverView preferredHeight];
    } else return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    return width / 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    OwnerQueryModel* om = [_delegate getOM];
    return ((om.querydata.count) / PHOTO_PER_LINE) + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AlbumTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlbumTableViewCell"];
    
    if (cell == nil) {
        cell = [[AlbumTableCell alloc]init];
    }
    
    cell.delegate = _delegate;
    OwnerQueryModel* om = [_delegate getOM];
    NSInteger row = indexPath.row;
    @try {
        NSArray* arr_tmp = [om.querydata objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(row * PHOTO_PER_LINE, PHOTO_PER_LINE)]];
        NSMutableArray* arr_content = [[NSMutableArray alloc]initWithCapacity:PHOTO_PER_LINE];
        for (QueryContent* item in arr_tmp) {
            [arr_content addObject:((QueryContentItem*)item.items.allObjects.firstObject).item_name];
        }
        [cell setUpContentViewWithImageNames:arr_content atLine:row andType:AlbumControllerTypePhoto];
    }
    @catch (NSException *exception) {
        NSArray* arr_tmp = [om.querydata objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(row * PHOTO_PER_LINE, om.querydata.count - row * PHOTO_PER_LINE)]];
        NSMutableArray* arr_content = [[NSMutableArray alloc]initWithCapacity:PHOTO_PER_LINE];
        for (QueryContent* item in arr_tmp) {
            [arr_content addObject:((QueryContentItem*)item.items.allObjects.firstObject).item_name];
        }
        [cell setUpContentViewWithImageNames:arr_content atLine:row andType:AlbumControllerTypePhoto];
    }
    
    return cell;
}

#pragma mark -- Personal Center Callback 
- (void)setDelegate:(id<PersonalCenterProtocol, ProfileViewDelegate, AlbumTableCellDelegate>)delegate {
    _delegate = delegate;
}
@end