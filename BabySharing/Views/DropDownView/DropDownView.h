//
//  DropDownView.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 4/01/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DropDownView;

@protocol DropDownDatasource <NSObject>
- (NSInteger)itemCount;
- (UITableViewCell*)cellForRow:(NSInteger)row inTableView:(UITableView*)tableview;
- (NSString*)titleForCellAtRow:(NSInteger)row inTableView:(UITableView*)tableview;
@end

@protocol DropDownDelegate <NSObject>
- (void)didSelectCell:(UITableViewCell*)cell;
- (void)showContentsTableView:(UITableView*)tableview;
@end

@interface DropDownView : UIButton <UITableViewDataSource, UITableViewDelegate> {
    UITableView* items;
}

@property (nonatomic, weak) id<DropDownDatasource> datasource;
@property (nonatomic, weak) id<DropDownDelegate> delegate;

- (id)init;
- (id)initWithCoder:(NSCoder *)aDecoder;
- (id)initWithFrame:(CGRect)frame;
@end
