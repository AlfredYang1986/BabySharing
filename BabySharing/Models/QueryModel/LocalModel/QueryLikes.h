//
//  QueryLikes.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 17/01/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class QueryContent;

@interface QueryLikes : NSManagedObject

@property (nonatomic, retain) NSString * like_owner_id;
@property (nonatomic, retain) NSString * like_owner_name;
@property (nonatomic, retain) NSString * like_owner_photo;
@property (nonatomic, retain) NSDate * like_date;
@property (nonatomic, retain) QueryContent *likeTo;

@end
