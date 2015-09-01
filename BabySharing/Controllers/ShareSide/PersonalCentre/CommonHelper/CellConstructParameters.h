//
//  CellConstructParameters.h
//  BabySharing
//
//  Created by Alfred Yang on 1/09/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 * construct cell
 */
@interface CellConstructParameters : NSObject
@property (nonatomic, weak, readonly) UITableView* tableView;
@property (nonatomic, weak, readonly) NSIndexPath* indexPath;
@property (nonatomic, strong) UITableViewCell* cell;

- (id)initWithTableView:(UITableView*)tb atIndex:(NSIndexPath*)path;
@end

/**
 * cell height
 */
@interface CellHeightParameters : NSObject 
@property (nonatomic) CGFloat height;
@end

/**
 * cell count
 */
@interface CellCountParameters : NSObject 
@property (nonatomic) NSInteger count;
@end
