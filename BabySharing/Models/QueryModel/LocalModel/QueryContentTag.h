//
//  QueryContentTag.h
//  
//
//  Created by Alfred Yang on 14/06/2015.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class QueryContent;

@interface QueryContentTag : NSManagedObject

@property (nonatomic, retain) NSString * tag_content;
@property (nonatomic, retain) NSNumber * tag_type;
@property (nonatomic, retain) NSNumber * tag_offset_x;
@property (nonatomic, retain) NSNumber * tag_offset_y;
@property (nonatomic, retain) QueryContent *tagsTo;

@end
