//
//  AlbumViewController2.h
//  BabySharing
//
//  Created by Alfred Yang on 11/07/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlbumActionProtocol.h"

@interface AlbumViewController2 : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) AlbumControllerType type;
@end
