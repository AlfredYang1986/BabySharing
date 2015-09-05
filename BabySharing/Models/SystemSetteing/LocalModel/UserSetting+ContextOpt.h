//
//  UserSetting+ContextOpt.h
//  BabySharing
//
//  Created by Alfred Yang on 5/09/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserSetting.h"

@class MessageSetting;

@interface UserSetting (ContextOpt)

+ (UserSetting*)enumUserSettingByUserID:(NSString*)user_id inContext:(NSManagedObjectContext*)context;

+ (void)refreshMessageSettingWithUserID:(NSString*)user_id andSetting:(NSDictionary*)setting inContext:(NSManagedObjectContext*)context;
+ (MessageSetting*)queryMessageSettingWithUserID:(NSString*)user_id inContext:(NSManagedObjectContext*)context;
@end
