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

@protocol PersonalCenterProtocol <NSObject>
- (NSString*)getOwnerPhotoName;
- (NSInteger)getSharedCount;
- (NSInteger)getFriendsCount;
- (NSInteger)getCycleCount;
- (NSString*)getOwnerLocation;
- (NSString*)getOwnerSign;
- (NSString*)getOwnerRoleTag;

- (OwnerQueryModel*)getOM;
@end

@interface PersonalCenterOwnerDelegate : NSObject <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) id<PersonalCenterProtocol> delegate;
@end
