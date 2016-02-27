//
//  AlbumViewController2.h
//  BabySharing
//
//  Created by Alfred Yang on 11/07/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlbumActionProtocol.h"
#import "AlbumTableCell.h"

#import "CameraActionProtocol.h"

@class ALAsset;

@interface AlbumViewController2 : UIViewController <UITableViewDelegate, UITableViewDataSource, AlbumTableCellDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic) AlbumControllerType type;
@property (nonatomic, weak) id<CameraActionProtocol> delegate;

@end
