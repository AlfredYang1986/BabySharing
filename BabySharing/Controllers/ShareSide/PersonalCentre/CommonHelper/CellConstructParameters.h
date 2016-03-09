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

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) NSIndexPath *indexPath;
@property (nonatomic, strong) UITableViewCell *cell;

- (id)initWithTableView:(UITableView *)tb atIndex:(NSIndexPath *)path;

// 我推荐写成单例
+ (instancetype)getInstance:(UITableView *)talbeView indexPath:(NSIndexPath *)indexPath;

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
