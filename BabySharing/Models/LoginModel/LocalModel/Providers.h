//
//  Providers.h
//  
//
//  Created by Alfred Yang on 4/09/2015.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class LoginToken;

@interface Providers : NSManagedObject

@property (nonatomic, retain) NSString * provider_name;
@property (nonatomic, retain) NSString * provider_screen_name;
@property (nonatomic, retain) NSString * provider_token;
@property (nonatomic, retain) NSString * provider_user_id;
@property (nonatomic, retain) NSString * provider_open_id;
@property (nonatomic, retain) LoginToken *user;

@end
