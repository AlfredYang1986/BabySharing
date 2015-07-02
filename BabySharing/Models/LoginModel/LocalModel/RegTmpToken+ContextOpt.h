//
//  RegTmpToken+ContextOpt.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 29/12/2014.
//  Copyright (c) 2014 YY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RegTmpToken.h"

@interface RegTmpToken (ContextOpt)

+ (RegTmpToken*)createRegTokenInContext:(NSManagedObjectContext*)context WithToken:(NSString*)reg_token andPhoneNumber:(NSString*)phoneNo;
+ (void)removeTokenInContext:(NSManagedObjectContext*)context WithToken:(NSString*)reg_token;
+ (RegTmpToken*)enumRegTokenINContext:(NSManagedObjectContext*)context WithToken:(NSString*)reg_token;
+ (RegTmpToken*)enumRegTokenINContext:(NSManagedObjectContext*)context WithPhoneNo:(NSString*)phoneNo;
@end
