//
//  Notifications.h
//  
//
//  Created by Alfred Yang on 9/08/2015.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NotificationOwner;

@interface Notifications : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * sender_id;
@property (nonatomic, retain) NSString * sender_screen_name;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSString * sender_screen_photo;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NotificationOwner *beNotified;

@end
