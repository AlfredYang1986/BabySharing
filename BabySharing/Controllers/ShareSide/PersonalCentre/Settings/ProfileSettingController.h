//
//  PrfileSettingController.h
//  BabySharing
//
//  Created by Alfred Yang on 3/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonalCenterDefines.h"

@interface ProfileSettingController : UIViewController
@property (weak, nonatomic) NSString* current_user_id;
@property (weak, nonatomic) NSString* current_auth_token;

@property (weak, nonatomic) NSDictionary* dic_profile_details;

@property (weak, nonatomic) id<personalDetailChanged> delegate;
@end