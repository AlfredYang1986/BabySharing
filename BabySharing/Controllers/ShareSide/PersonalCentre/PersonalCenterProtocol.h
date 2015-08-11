//
//  PersonalCenterProtocol.h
//  BabySharing
//
//  Created by Alfred Yang on 7/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#ifndef BabySharing_PersonalCenterProtocol_h
#define BabySharing_PersonalCenterProtocol_h

#import "ProfileViewDelegate.h"

@class OwnerQueryModel;

@protocol PersonalCenterProtocol <NSObject>
- (NSString*)getPhotoName;
- (NSInteger)getSharedCount;
- (NSInteger)getFriendsCount;
- (NSInteger)getCycleCount;
- (NSString*)getLocation;
- (NSString*)getSign;
- (NSString*)getRoleTag;
- (NSString*)getRelations;

- (OwnerQueryModel*)getOM;
@end

@protocol PersonalCenterCallBack <NSObject>
- (void)setDelegate:(id<PersonalCenterProtocol, ProfileViewDelegate>)delegate;
@end
#endif
