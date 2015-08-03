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

- (void)didSelectOneImageAtIndex:(NSInteger)index;
- (void)didUnSelectOneImageAtIndex:(NSInteger)index;
- (NSInteger)indexByRow:(NSInteger)row andCol:(NSInteger)col;
- (NSInteger)getViewsCount;
- (BOOL)isSelectedAtIndex:(NSInteger)index;

@optional
- (void)didSelectCameraBtn;
- (void)didSelectMovieBtn;
- (void)didSelectCompareBtn;
@end

@interface AlbumTableCell : UITableViewCell {
//    UIView* left_image_view;
//    UIView* center_image_view;
//    UIView* right_image_view;
//    
    NSMutableArray* image_view;
    
    NSInteger views_count;
}

@property (nonatomic, weak) id<AlbumTableCellDelegate> delegate;

- (CGFloat)prefferCellHeight;
- (void)setUpContentViewWithImageNames:(NSArray*)image_arr atLine:(NSInteger)row andType:(AlbumControllerType)type;
- (void)setUpContentViewWithImageURLs2:(NSArray*)image_arr atLine:(NSInteger)row andType:(AlbumControllerType)type;
- (void)setUpContentViewWithImageURLs:(NSArray*)image_arr atLine:(NSInteger)row andType:(AlbumControllerType)type;

- (void)didSelectCameraBtn;

- (AlbumGridCell*)queryGridCellByIndex:(NSInteger)index;
@end
