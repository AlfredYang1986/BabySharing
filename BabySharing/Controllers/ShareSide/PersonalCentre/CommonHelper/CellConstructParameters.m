//
//  CellConstructParameters.m
//  BabySharing
//
//  Created by Alfred Yang on 1/09/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "CellConstructParameters.h"

@implementation CellConstructParameters

@synthesize tableView = _tableView;
@synthesize indexPath = _indexPath;

- (id)initWithTableView:(UITableView*)tb atIndex:(NSIndexPath*)path {
    self = [super init];
    if (self) {
        _tableView = tb;
        _indexPath = path;
    }
    
    return self;
}
@end


@implementation CellHeightParameters

@synthesize height = _height;
@end

@implementation CellCountParameters

@synthesize count = _count;
@end