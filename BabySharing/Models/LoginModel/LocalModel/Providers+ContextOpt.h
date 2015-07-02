//
//  Providers+ContextOpt.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 31/12/2014.
//  Copyright (c) 2014 YY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Providers.h"

@interface Providers (ContextOpt)

+ (Providers*)createProviderInContext:(NSManagedObjectContext*)context ByName:(NSString*)provider_name andProviderUserId:(NSString*)provider_user_id andProviderToken:(NSString*)provider_token andProviderScreenName:(NSString*)provider_screen_name;
@end
