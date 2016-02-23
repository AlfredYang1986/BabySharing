//
//  ConnectionOwner.h
//  BabySharing
//
//  Created by Alfred Yang on 2/23/16.
//  Copyright © 2016 BM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Followed, Following, Friends;

NS_ASSUME_NONNULL_BEGIN

@interface ConnectionOwner : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "ConnectionOwner+CoreDataProperties.h"
