//
//  Notifications+CoreDataProperties.m
//  BabySharing
//
//  Created by Alfred Yang on 1/28/16.
//  Copyright © 2016 BM. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Notifications+CoreDataProperties.h"

@implementation Notifications (CoreDataProperties)

@dynamic date;
@dynamic sender_id;
@dynamic sender_screen_name;
@dynamic sender_screen_photo;
@dynamic status;
@dynamic type;
@dynamic receiver_id;
@dynamic receiver_screen_name;
@dynamic receiver_screen_photo;
@dynamic action_post_id;
@dynamic beNotified;

@end
