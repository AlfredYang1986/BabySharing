//
//  Notifications.h
//  BabySharing
//
//  Created by Alfred Yang on 8/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NotificationOwner;

@interface Notifications : NSManagedObject

@property (nonatomic, retain) NSString * from;
@property (nonatomic, retain) NSDate * data;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSString * to;
@property (nonatomic, retain) NotificationOwner *beNotified;

@end
