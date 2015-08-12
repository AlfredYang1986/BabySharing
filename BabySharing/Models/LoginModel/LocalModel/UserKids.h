//
//  UserKids.h
//  
//
//  Created by Alfred Yang on 12/08/2015.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NSManagedObject;

@interface UserKids : NSManagedObject

@property (nonatomic, retain) NSNumber * age;
@property (nonatomic, retain) NSNumber * gender;
@property (nonatomic, retain) NSString * school;
@property (nonatomic, retain) NSDate * dob;
@property (nonatomic, retain) NSNumber * horoscope;
@property (nonatomic, retain) NSManagedObject *parent;

@end
