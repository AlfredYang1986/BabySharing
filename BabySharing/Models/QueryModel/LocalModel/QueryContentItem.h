//
//  QueryContentItem.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 16/01/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class QueryContent;

@interface QueryContentItem : NSManagedObject

@property (nonatomic, retain) NSString * item_name;
@property (nonatomic, retain) NSNumber * item_type;
@property (nonatomic, retain) QueryContent *holdsBy;

@end
