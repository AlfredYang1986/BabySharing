//
//  Messages.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 8/06/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SubGroup;

@interface Messages : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * owner;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) SubGroup *belongs;

@end
