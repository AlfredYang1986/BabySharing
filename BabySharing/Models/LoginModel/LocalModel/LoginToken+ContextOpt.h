//
//  LoginToken+ContextOpt.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 29/12/2014.
//  Copyright (c) 2014 YY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginToken.h"

@interface LoginToken (ContextOpt)

#pragma mark -- enum users
+ (NSArray*)loginUsersWithContext:(NSManagedObjectContext*)context;
+ (NSArray*)enumAllLoginUsersWithContext: (NSManagedObjectContext*)context;

#pragma mark -- operation with phone number
+ (NSArray*)enumLoginUsersInContext:(NSManagedObjectContext*)context WithPhoneNo:(NSString*)phoneNo;
+ (void)removeTokenInContext:(NSManagedObjectContext*)context WithPhoneNum:(NSString*)phoneNo;
+ (void)unbindTokenInContext:(NSManagedObjectContext*)context WithPhoneNum:(NSString*)phoneNo;

#pragma mark -- operation with user id (primary key)
+ (LoginToken*)createTokenInContext:(NSManagedObjectContext*)context withUserID:(NSString*)user_id andAttrs:(NSDictionary*)dic;
+ (void)removeTokenInContext:(NSManagedObjectContext*)context withUserID:(NSString*)user_id;
+ (BOOL)updataLoginUserInContext:(NSManagedObjectContext*)context withUserID:(NSString*)user_id andAttrs:(NSDictionary*)dic;
+ (LoginToken*)enumLoginUserInContext:(NSManagedObjectContext*)context withUserID:(NSString*)user_id;

#pragma mark -- user attr
+ (NSDictionary*)userToken2Attr:(LoginToken*)user;
@end
