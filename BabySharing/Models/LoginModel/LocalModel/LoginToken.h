//
//  LoginToken.h
//  
//
//  Created by Alfred Yang on 12/08/2015.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CurrentToken, DetailInfo, Providers;

@interface LoginToken : NSManagedObject

@property (nonatomic, retain) NSString * auth_token;
@property (nonatomic, retain) NSString * phoneNo;
@property (nonatomic, retain) NSString * role_tag;
@property (nonatomic, retain) NSString * screen_image;
@property (nonatomic, retain) NSString * screen_name;
@property (nonatomic, retain) NSString * user_id;
@property (nonatomic, retain) NSSet *connectWith;
@property (nonatomic, retain) CurrentToken *logined;
@property (nonatomic, retain) DetailInfo *detailInfo;

@end

@interface LoginToken (CoreDataGeneratedAccessors)

- (void)addConnectWithObject:(Providers *)value;
- (void)removeConnectWithObject:(Providers *)value;
- (void)addConnectWith:(NSSet *)values;
- (void)removeConnectWith:(NSSet *)values;

@end
