//
//  PrivacySetting.h
//  BabySharing
//
//  Created by Alfred Yang on 5/09/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NSManagedObject;

@interface PrivacySetting : NSManagedObject

@property (nonatomic, retain) NSManagedObject *who;

@end
