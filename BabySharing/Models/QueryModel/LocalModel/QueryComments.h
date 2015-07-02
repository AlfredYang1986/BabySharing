//
//  QueryComments.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 16/01/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class QueryContent;

@interface QueryComments : NSManagedObject

@property (nonatomic, retain) NSString * comment_owner_id;
@property (nonatomic, retain) NSString * comment_owner_name;
@property (nonatomic, retain) NSString * comment_owner_photo;
@property (nonatomic, retain) NSDate * comment_date;
@property (nonatomic, retain) NSString * comment_content;
@property (nonatomic, retain) QueryContent *commentTo;

@end
