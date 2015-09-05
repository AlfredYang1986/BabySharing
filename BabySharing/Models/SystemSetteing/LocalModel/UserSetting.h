//
//  UserSetting.h
//  BabySharing
//
//  Created by Alfred Yang on 5/09/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MessageSetting, PrivacySetting;

@interface UserSetting : NSManagedObject

@property (nonatomic, retain) NSString * user_id;
@property (nonatomic, retain) MessageSetting *messageSetting;
@property (nonatomic, retain) PrivacySetting *privacySetting;

@end
