//
//  Providers.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 9/01/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class LoginToken;

@interface Providers : NSManagedObject

@property (nonatomic, retain) NSString * provider_name;
@property (nonatomic, retain) NSString * provider_screen_name;
@property (nonatomic, retain) NSString * provider_token;
@property (nonatomic, retain) NSString * provider_user_id;
@property (nonatomic, retain) LoginToken *user;

@end
