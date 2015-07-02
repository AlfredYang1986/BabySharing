//
//  CurrentToken.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 9/01/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class LoginToken;

@interface CurrentToken : NSManagedObject

@property (nonatomic, retain) NSDate * last_login_data;
@property (nonatomic, retain) LoginToken *who;

@end
