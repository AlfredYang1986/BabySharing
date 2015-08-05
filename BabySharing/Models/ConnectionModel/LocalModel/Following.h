//
//  Following.h
//  
//
//  Created by Alfred Yang on 5/08/2015.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ConnectionOwner;

@interface Following : NSManagedObject

@property (nonatomic, retain) NSString * user_id;
@property (nonatomic, retain) ConnectionOwner *followingBy;

@end
