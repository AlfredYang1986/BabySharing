//
//  Followed.h
//  
//
//  Created by Alfred Yang on 5/08/2015.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NSManagedObject;

@interface Followed : NSManagedObject

@property (nonatomic, retain) NSString * user_id;
@property (nonatomic, retain) NSManagedObject *followedBy;

@end
