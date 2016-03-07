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
#import "QueryContent+ContextOpt.h"
#import "QueryContentItem.h"
#import "PersonalCenterDefines.h"

#include <vector>
#import "CellConstructParameters.h"
#import "CollectionQueryModel.h"

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

- (void)gridViewHeight:(CellHeightParameters*)para {
    
//    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    para.height = [AlbumTableCell prefferCellHeightWithMarginLeft:10.5f Right:10.5f Margin:2.f];
}

- (void)gridViewCount:(CellCountParameters*)para {
    OwnerQueryModel* om = [_delegate getOM];
    para.count = ((om.querydata.count) / PHOTO_PER_LINE) + 1;
}

- (void)gridViewConstructorFuncwithParameters:(CellConstructParameters*)para {
   
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
    //    OwnerQueryModel* om = [_delegate getOM];
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

- (void)locationViewHeight:(CellHeightParameters*)para {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    para.height = width / 3;
}

- (void)locationViewCount:(CellCountParameters*)para {
    //    OwnerQueryModel* om = [_delegate getOM];
    //    para.count = ((om.querydata.count) / PHOTO_PER_LINE) + 1;
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
//    if (section == 0) {
//        return [ProfileOverView preferredHeight];
//    } else
        return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = [_delegate getCurrentSegIndex];
    CellHeightParameters * para = [[CellHeightParameters alloc]init];
    [self performSelector:cell_constructor_height[index] withObject:para];
    return para.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger index = [_delegate getCurrentSegIndex];
    CellCountParameters* para = [[CellCountParameters alloc]init];
    [self performSelector:cell_constructor_count[index] withObject:para];
    return para.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    NSInteger index = [_delegate getCurrentSegIndex];
    
    CellConstructParameters* para = [[CellConstructParameters alloc]initWithTableView:tableView atIndex:indexPath];
    [self performSelector:cell_constructor_func[index] withObject:para];
     return para.cell;
}


#pragma mark -- Personal Center Callback
- (void)setDelegate:(id<PersonalCenterProtocol, ProfileViewDelegate, AlbumTableCellDelegate>)delegate {
    _delegate = delegate;
}
@end
