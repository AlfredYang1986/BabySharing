//
//  Messages.h
//  BabySharing
//
//  Created by Alfred Yang on 8/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Targets;

@interface Messages : NSManagedObject

@property (nonatomic, retain) NSNumber * message_type;
@property (nonatomic, retain) NSString * messageContent;
@property (nonatomic, retain) NSDate * message_date;
@property (nonatomic, retain) Targets *messageFrom;

@end
