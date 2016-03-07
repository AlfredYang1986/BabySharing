//
//  PersonalCenterOwnerDelegate.h
//  BabySharing
//
//  Created by Alfred Yang on 1/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "OwnerQueryModel.h"
#import "AlbumTableCell.h"
#import "PersonalCenterProtocol.h"
#import "ProfileViewDelegate.h"

@interface PersonalCenterOwnerDelegate : NSObject <UITableViewDelegate, UITableViewDataSource, PersonalCenterCallBack>

@property (nonatomic, weak) id<PersonalCenterProtocol, ProfileViewDelegate, AlbumTableCellDelegate> delegate;

@end
