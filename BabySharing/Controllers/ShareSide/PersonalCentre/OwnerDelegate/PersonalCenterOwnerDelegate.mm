//
//  PersonalCenterOwnerDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 1/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "PersonalCenterOwnerDelegate.h"
#import "ProfileOverview.h"
#import "OwnerQueryModel.h"
#import "OwnerQueryPushModel.h"
#import "QueryContent+ContextOpt.h"
#import "QueryContentItem.h"
#import "PersonalCenterDefines.h"
#include <vector>
#import "CellConstructParameters.h"
#import "CollectionQueryModel.h"
#import "Define.h"
#import "PostDefine.h"

@interface PersonalCenterOwnerDelegate ()

@end

@implementation PersonalCenterOwnerDelegate {
    std::vector<SEL> cell_constructor_func;
    std::vector<SEL> cell_constructor_height;
    std::vector<SEL> cell_constructor_count;
}

@synthesize delegate = _delegate;

- (id)init {
    self = [super init];
    if (self) {
        cell_constructor_func.push_back(@selector(gridViewConstructorFuncwithParameters:));
        cell_constructor_func.push_back(@selector(locationViewConstructorFuncwithParameters:));
        cell_constructor_func.push_back(@selector(tagViewConstructorFuncwithParameters:));
        cell_constructor_func.push_back(@selector(collectionViewConstructorFuncwithParameters:));

        cell_constructor_height.push_back(@selector(gridViewHeight:));
        cell_constructor_height.push_back(@selector(locationViewHeight:));
        cell_constructor_height.push_back(@selector(tagViewHeight:));
        cell_constructor_height.push_back(@selector(collectionViewHeight:));

        cell_constructor_count.push_back(@selector(gridViewCount:));
        cell_constructor_count.push_back(@selector(locationViewCount:));
        cell_constructor_count.push_back(@selector(tagViewCount:));
        cell_constructor_count.push_back(@selector(collectionViewCount:));
    }
    
    return self;
}

- (void)gridViewHeight:(CellHeightParameters *)para {
    
//    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    para.height = [AlbumTableCell prefferCellHeightWithMarginLeft:10.5f Right:10.5f Margin:2.f];
}

- (void)gridViewCount:(CellCountParameters *)para {
    if ([[_delegate getOwnerModel] isKindOfClass:[OwnerQueryModel class]]) {
        OwnerQueryModel *model = (OwnerQueryModel *)[_delegate getOwnerModel];
        para.count = (model.querydata.count / PHOTO_PER_LINE) + 1;
    } else if([[_delegate getOwnerModel] isKindOfClass:[OwnerQueryPushModel class]]) {
        OwnerQueryPushModel *model = (OwnerQueryPushModel *)[_delegate getOwnerModel];
        para.count = (model.querydata.count / PHOTO_PER_LINE) + 1;
    } else {
        para.count = -1;
    }
//    OwnerQueryModel* om = [_delegate getOM];
//    para.count = ((om.querydata.count) / PHOTO_PER_LINE) + 1;
}

- (void)gridViewConstructorFuncwithParameters:(CellConstructParameters *)para {
   
    UITableView* tableView = para.tableView;
    NSIndexPath* indexPath = para.indexPath;
    
    AlbumTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlbumTableViewCell"];
    
    if (cell == nil) {
        cell = [[AlbumTableCell alloc] init];
    }
    
    cell.margin_left = 10.5f;
    cell.margin_right = 10.5f;
    cell.cell_cor_radius = 3.f;
    cell.marign_between = 2.f;
    cell.delegate = _delegate;
    NSArray* querydata = [_delegate getQueryData];
    NSInteger row = indexPath.row;
    @try {
        NSArray* arr_tmp = [querydata objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(row * PHOTO_PER_LINE, PHOTO_PER_LINE)]];
        NSMutableArray* arr_content = [[NSMutableArray alloc] initWithCapacity:PHOTO_PER_LINE];
        for (QueryContent* item in arr_tmp) {
            for (QueryContentItem *aaa in item.items) {
                if (aaa.item_type.unsignedIntegerValue != PostPreViewMovie) {
                    [arr_content addObject:aaa.item_name];
                    break;
                }
            }
//            [arr_content addObject:((QueryContentItem*)item.items.allObjects.firstObject).item_name];
        }
        [cell setUpContentViewWithImageNames:arr_content atLine:row andType:AlbumControllerTypePhoto];
    } @catch (NSException *exception) {
        NSArray* arr_tmp = [querydata objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(row * PHOTO_PER_LINE, querydata.count - row * PHOTO_PER_LINE)]];
        NSMutableArray* arr_content = [[NSMutableArray alloc]initWithCapacity:PHOTO_PER_LINE];
        for (QueryContent* item in arr_tmp) {
            for (QueryContentItem *aaa in item.items) {
                if (aaa.item_type.unsignedIntegerValue != PostPreViewMovie) {
                    [arr_content addObject:aaa.item_name];
                    break;
                }
            }
//            [arr_content addObject:((QueryContentItem *)item.items.allObjects.firstObject).item_name];
        }
        [cell setUpContentViewWithImageNames:arr_content atLine:row andType:AlbumControllerTypePhoto];
    }
    para.cell = cell;
}

- (void)locationViewHeight:(CellHeightParameters*)para {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    para.height = width / 3;
}

- (void)locationViewCount:(CellCountParameters*)para {
    para.count = (([_delegate getQueryData].count) / PHOTO_PER_LINE) + 1;
}

- (void)locationViewConstructorFuncwithParameters:(CellConstructParameters*)para {
    UITableView* tableView = para.tableView;
    NSIndexPath* indexPath = para.indexPath;
    
    AlbumTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlbumTableViewCell"];
    
    if (cell == nil) {
        cell = [[AlbumTableCell alloc]init];
    }
   
    cell.margin_left = 10.5f;
    cell.margin_right = 10.5f;
    cell.cell_cor_radius = 3.f;
    cell.marign_between = 2.f;
    cell.delegate = _delegate;
    //    OwnerQueryModel* om = [_delegate getOM];
    NSArray* querydata = [_delegate getQueryData];
    NSInteger row = indexPath.row;
    @try {
        NSArray* arr_tmp = [querydata objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(row * PHOTO_PER_LINE, PHOTO_PER_LINE)]];
        NSMutableArray* arr_content = [[NSMutableArray alloc]initWithCapacity:PHOTO_PER_LINE];
        for (QueryContent* item in arr_tmp) {
            [arr_content addObject:((QueryContentItem*)item.items.allObjects.firstObject).item_name];
        }
        [cell setUpContentViewWithImageNames:arr_content atLine:row andType:AlbumControllerTypePhoto];
    }
    @catch (NSException *exception) {
        NSArray* arr_tmp = [querydata objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(row * PHOTO_PER_LINE, querydata.count - row * PHOTO_PER_LINE)]];
        NSMutableArray* arr_content = [[NSMutableArray alloc]initWithCapacity:PHOTO_PER_LINE];
        for (QueryContent* item in arr_tmp) {
            [arr_content addObject:((QueryContentItem*)item.items.allObjects.firstObject).item_name];
        }
        [cell setUpContentViewWithImageNames:arr_content atLine:row andType:AlbumControllerTypePhoto];
    }
    para.cell = cell;
}

- (void)tagViewHeight:(CellHeightParameters*)para {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    para.height = width / 3;
}

- (void)tagViewCount:(CellCountParameters*)para {
    //    OwnerQueryModel* om = [_delegate getOM];
    //    para.count = ((om.querydata.count) / PHOTO_PER_LINE) + 1;
    para.count = (([_delegate getQueryData].count) / PHOTO_PER_LINE) + 1;
}

- (void)tagViewConstructorFuncwithParameters:(CellConstructParameters*)para {
    UITableView* tableView = para.tableView;
    NSIndexPath* indexPath = para.indexPath;
    
    AlbumTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlbumTableViewCell"];
    
    if (cell == nil) {
        cell = [[AlbumTableCell alloc]init];
    }
    
    cell.delegate = _delegate;
    //    OwnerQueryModel* om = [_delegate getOM];
    NSArray* querydata = [_delegate getQueryData];
    NSInteger row = indexPath.row;
    @try {
        NSArray* arr_tmp = [querydata objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(row * PHOTO_PER_LINE, PHOTO_PER_LINE)]];
        NSMutableArray* arr_content = [[NSMutableArray alloc]initWithCapacity:PHOTO_PER_LINE];
        for (QueryContent* item in arr_tmp) {
            [arr_content addObject:((QueryContentItem*)item.items.allObjects.firstObject).item_name];
        }
        [cell setUpContentViewWithImageNames:arr_content atLine:row andType:AlbumControllerTypePhoto];
    }
    @catch (NSException *exception) {
        NSArray* arr_tmp = [querydata objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(row * PHOTO_PER_LINE, querydata.count - row * PHOTO_PER_LINE)]];
        NSMutableArray* arr_content = [[NSMutableArray alloc]initWithCapacity:PHOTO_PER_LINE];
        for (QueryContent* item in arr_tmp) {
            [arr_content addObject:((QueryContentItem*)item.items.allObjects.firstObject).item_name];
        }
        [cell setUpContentViewWithImageNames:arr_content atLine:row andType:AlbumControllerTypePhoto];
    }

    para.cell = cell;
}

- (void)collectionViewHeight:(CellHeightParameters*)para {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    para.height = width / 3;
}

- (void)collectionViewCount:(CellCountParameters*)para {
    CollectionQueryModel* cqm = [_delegate getCQM];
    para.count = ((cqm.querydata.count) / PHOTO_PER_LINE) + 1;
}

- (void)collectionViewConstructorFuncwithParameters:(CellConstructParameters*)para {
    UITableView* tableView = para.tableView;
    NSIndexPath* indexPath = para.indexPath;
    
    AlbumTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlbumTableViewCell"];
    
    if (cell == nil) {
        cell = [[AlbumTableCell alloc]init];
    }
    
    cell.delegate = _delegate;
    CollectionQueryModel* cqm = [_delegate getCQM];
    NSInteger row = indexPath.row;
    @try {
        NSArray* arr_tmp = [cqm.querydata objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(row * PHOTO_PER_LINE, PHOTO_PER_LINE)]];
        NSMutableArray* arr_content = [[NSMutableArray alloc]initWithCapacity:PHOTO_PER_LINE];
        for (QueryContent* item in arr_tmp) {
            [arr_content addObject:((QueryContentItem*)item.items.allObjects.firstObject).item_name];
        }
        [cell setUpContentViewWithImageNames:arr_content atLine:row andType:AlbumControllerTypePhoto];
    }
    @catch (NSException *exception) {
        NSArray* arr_tmp = [cqm.querydata objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(row * PHOTO_PER_LINE, cqm.querydata.count - row * PHOTO_PER_LINE)]];
        NSMutableArray* arr_content = [[NSMutableArray alloc]initWithCapacity:PHOTO_PER_LINE];
        for (QueryContent* item in arr_tmp) {
            [arr_content addObject:((QueryContentItem*)item.items.allObjects.firstObject).item_name];
        }
        [cell setUpContentViewWithImageNames:arr_content atLine:row andType:AlbumControllerTypePhoto];
    }

    para.cell = cell;
}

#pragma mark -- UITableView Delegate
#pragma mark -- UITableView DataSource 
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if (section == 0 && [view isKindOfClass:[UITableViewHeaderFooterView class]]) {
        ((UITableViewHeaderFooterView *)view).tintColor = [UIColor whiteColor];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
        return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = [_delegate getCurrentSegIndex];
    CellHeightParameters * para = [[CellHeightParameters alloc] init];
    SuppressPerformSelectorLeakWarning([self performSelector:cell_constructor_height[index] withObject:para]);
    return para.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger index = [_delegate getCurrentSegIndex];
    CellCountParameters* para = [[CellCountParameters alloc] init];
    SuppressPerformSelectorLeakWarning([self performSelector:cell_constructor_count[index] withObject:para]);
    UILabel *label = [tableView viewWithTag:-9];
    if (label == nil) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        label.textColor = TextColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.center = CGPointMake(CGRectGetWidth(tableView.frame) / 2, CGRectGetHeight(tableView.frame) / 2 - 20);
        label.tag = -9;
        [tableView addSubview:label];
    }
    
    if ([_delegate getQueryData].count == 0) {
        label.hidden = NO;
        if (index == 0) {
            label.text = @"您还没有发布任何照片\n快去发布吧";
        } else {
            label.text = @"您还没有推出任何照片\n快去推出吧";
        }
    } else {
        label.hidden = YES;
    }
    return para.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = [_delegate getCurrentSegIndex];
    CellConstructParameters* para = [[CellConstructParameters alloc] initWithTableView:tableView atIndex:indexPath];
    SuppressPerformSelectorLeakWarning([self performSelector:cell_constructor_func[index] withObject:para]);
    para.cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return para.cell;
}


#pragma mark -- Personal Center Callback
- (void)setDelegate:(id<PersonalCenterProtocol, ProfileViewDelegate, AlbumTableCellDelegate>)delegate {
    _delegate = delegate;
}
@end
