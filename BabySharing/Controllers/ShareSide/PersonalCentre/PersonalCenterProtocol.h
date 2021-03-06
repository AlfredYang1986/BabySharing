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
@class OwnerQueryPushModel;
@class CollectionQueryModel;

@protocol PersonalCenterProtocol <NSObject>
- (NSString*)getPhotoName;
- (NSInteger)getSharedCount;
- (NSInteger)getFriendsCount;
- (NSInteger)getCycleCount;
- (NSString*)getLocation;
- (NSString*)getSign;
- (NSString*)getRoleTag;
- (NSInteger)getRelations;
- (NSString*)getNickName;

- (NSInteger)getLikesCount;
- (NSInteger)getBeenLikedCount;
- (NSInteger)getBeenPushCount;

- (OwnerQueryModel *)getOM;
- (OwnerQueryPushModel *)getOPM;
- (NSObject *)getOwnerModel;

- (NSArray*)getQueryData;


- (CollectionQueryModel*)getCQM;

- (NSInteger)getCurrentSegIndex;
@end

@protocol PersonalCenterCallBack <NSObject>
- (void)setDelegate:(id<PersonalCenterProtocol, ProfileViewDelegate>)delegate;
@end
#endif
