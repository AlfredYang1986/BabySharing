//
//  MessageSetting.h
//  BabySharing
//
//  Created by Alfred Yang on 5/09/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NSManagedObject;

@interface MessageSetting : NSManagedObject

@property (nonatomic, retain) NSNumber * mode_silence;
@property (nonatomic, retain) NSNumber * mode_voice;
@property (nonatomic, retain) NSNumber * mode_viber;
@property (nonatomic, retain) NSNumber * notify_cycle;
@property (nonatomic, retain) NSNumber * notify_p2p;
@property (nonatomic, retain) NSNumber * notify_notification;
@property (nonatomic, retain) NSNumber * notify_dongda;
@property (nonatomic, retain) NSManagedObject *who;

@end
