//
//  Friends.h
//  
//
//  Created by Alfred Yang on 7/08/2015.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ConnectionOwner;

@interface Friends : NSManagedObject

@property (nonatomic, retain) NSString * user_id;
@property (nonatomic, retain) ConnectionOwner *friendsWith;

@end
