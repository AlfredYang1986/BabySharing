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


+ (instancetype)getInstance:(UITableView *)talbeView indexPath:(NSIndexPath *)indexPath {
    
    static CellConstructParameters *cellConstruct;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cellConstruct = [[CellConstructParameters alloc] init];
    });
    cellConstruct.tableView = talbeView;
    cellConstruct.indexPath = indexPath;
    return cellConstruct;
}

@end


@implementation CellHeightParameters

@synthesize height = _height;
@end

@implementation CellCountParameters

@synthesize count = _count;
@end