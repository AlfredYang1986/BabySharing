//
//  Messages.h
//  
//
//  Created by Alfred Yang on 10/08/2015.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Targets;

@interface Messages : NSManagedObject

@property (nonatomic, retain) NSDate * message_date;
@property (nonatomic, retain) NSNumber * message_type;
@property (nonatomic, retain) NSString * message_content;
@property (nonatomic, retain) NSNumber * message_status;
@property (nonatomic, retain) Targets *messageFrom;

@end
