//
//  RegCurrentToken+ContextOpt.h
//  BabySharing
//
//  Created by Alfred Yang on 3/12/16.
//  Copyright © 2016 BM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RegCurrentToken.h"

@interface RegCurrentToken(ContextOpt)
+ (RegCurrentToken*)changeCurrentRegLoginUser:(LoginToken*)lgt inContext:(NSManagedObjectContext*)context;
+ (RegCurrentToken*)changeCurrentRegLoginUserWithUserID:(NSString*)user_id inContext:(NSManagedObjectContext*)context;
+ (RegCurrentToken*)enumCurrentRegLoginUserInContext:(NSManagedObjectContext*)context;
+ (BOOL)deleteCurrentRegUserInContext:(NSManagedObjectContext*)context;
@end
