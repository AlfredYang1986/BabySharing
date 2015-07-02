//
//  LoginToken.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 25/01/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CurrentToken, Providers;

@interface LoginToken : NSManagedObject

@property (nonatomic, retain) NSString * auth_token;
@property (nonatomic, retain) NSString * phoneNo;
@property (nonatomic, retain) NSString * screen_image;
@property (nonatomic, retain) NSString * screen_name;
@property (nonatomic, retain) NSString * user_id;
@property (nonatomic, retain) NSSet *connectWith;
@property (nonatomic, retain) CurrentToken *logined;
@end

@interface LoginToken (CoreDataGeneratedAccessors)

- (void)addConnectWithObject:(Providers *)value;
- (void)removeConnectWithObject:(Providers *)value;
- (void)addConnectWith:(NSSet *)values;
- (void)removeConnectWith:(NSSet *)values;

@end
