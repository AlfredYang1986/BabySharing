//
//  RegTmpToken.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 29/12/2014.
//  Copyright (c) 2014 YY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface RegTmpToken : NSManagedObject

@property (nonatomic, retain) NSString * reg_token;
@property (nonatomic, retain) NSString * phoneNo;

@end
