//
//  CurrentToken.h
//  
//
//  Created by Alfred Yang on 12/08/2015.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class LoginToken;

@interface CurrentToken : NSManagedObject

@property (nonatomic, retain) NSDate * last_login_data;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) LoginToken *who;

@end
