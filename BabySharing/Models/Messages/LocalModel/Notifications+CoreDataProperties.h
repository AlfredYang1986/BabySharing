//
//  Notifications+CoreDataProperties.h
//  BabySharing
//
//  Created by Alfred Yang on 1/28/16.
//  Copyright © 2016 BM. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Notifications.h"

NS_ASSUME_NONNULL_BEGIN

@interface Notifications (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) NSString *sender_id;
@property (nullable, nonatomic, retain) NSString *sender_screen_name;
@property (nullable, nonatomic, retain) NSString *sender_screen_photo;
@property (nullable, nonatomic, retain) NSNumber *status;
@property (nullable, nonatomic, retain) NSNumber *type;
@property (nullable, nonatomic, retain) NSString *receiver_id;
@property (nullable, nonatomic, retain) NSString *receiver_screen_name;
@property (nullable, nonatomic, retain) NSString *receiver_screen_photo;
@property (nullable, nonatomic, retain) NSString *action_post_id;
@property (nullable, nonatomic, retain) NotificationOwner *beNotified;

@end

NS_ASSUME_NONNULL_END
