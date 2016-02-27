//
//  PostTableCell.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 1/01/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlbumActionProtocol.h"

@class AlbumGridCell;

@protocol AlbumTableCellDelegate <NSObject>

@required
- (NSInteger)indexByRow:(NSInteger)row andCol:(NSInteger)col;
- (NSInteger)getViewsCount;
- (BOOL)isSelectedAtIndex:(NSInteger)index;
- (BOOL)isAllowMultipleSelected;

@optional
- (void)didSelectOneImageAtIndex:(NSInteger)index;
- (void)didUnSelectOneImageAtIndex:(NSInteger)index;

@optional
- (void)didSelectCameraBtn;
- (void)didSelectMovieBtn;
- (void)didSelectCompareBtn;
@end

@interface AlbumTableCell : UITableViewCell {

    NSMutableArray* image_view;
    
    NSInteger views_count;
}

@property (nonatomic, strong) UIColor* grid_border_color;
@property (nonatomic) BOOL cannot_selected;
@property (nonatomic, weak) id<AlbumTableCellDelegate> delegate;

+ (CGFloat)prefferCellHeight;
- (void)setUpContentViewWithImageNames:(NSArray*)image_arr atLine:(NSInteger)row andType:(AlbumControllerType)type;
- (void)setUpContentViewWithImageURLs2:(NSArray*)image_arr atLine:(NSInteger)row andType:(AlbumControllerType)type;
- (void)setUpContentViewWithImageURLs:(NSArray*)image_arr atLine:(NSInteger)row andType:(AlbumControllerType)type;

- (void)didSelectCameraBtn;
- (AlbumGridCell*)queryGridCellByIndex:(NSInteger)index;

- (void)selectedAtIndex:(NSInteger)index;
@end
