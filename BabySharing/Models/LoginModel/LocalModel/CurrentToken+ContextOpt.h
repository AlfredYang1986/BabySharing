//
//  CurrentToken+ContextOpt.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 1/01/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CurrentToken.h"

@interface CurrentToken (ContextOpt)

#pragma mark -- change current user
+ (CurrentToken*)changeCurrentLoginUser:(LoginToken*)lgt inContext:(NSManagedObjectContext*)context;
+ (CurrentToken*)changeCurrentLoginUserWithUserID:(NSString*)user_id inContext:(NSManagedObjectContext*)context;

#pragma mark -- enum current user
+ (CurrentToken*)enumCurrentLoginUserInContext:(NSManagedObjectContext*)context;

#pragma mark -- log out
+ (BOOL)logOutCurrentLoginUserInContext:(NSManagedObjectContext*)context;
+ (BOOL)offlineCurrentLoginUserInContext:(NSManagedObjectContext*)context;
+ (BOOL)onlineCurrentLoginUserInContext:(NSManagedObjectContext*)context;
+ (BOOL)isCurrentOfflineInContext:(NSManagedObjectContext*)context;

#pragma mark -- local detail info
+ (BOOL)isCurrentHasDetailInfoInContext:(NSManagedObjectContext*)context;
@end