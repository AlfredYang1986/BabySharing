//
//  DetailInfo.h
//  
//
//  Created by Alfred Yang on 12/08/2015.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class LoginToken, UserKids;

@interface DetailInfo : NSManagedObject

@property (nonatomic, retain) NSNumber * age;
@property (nonatomic, retain) NSNumber * horoscope;
@property (nonatomic, retain) NSString * home;
@property (nonatomic, retain) NSString * school;
@property (nonatomic, retain) NSDate * dob;
@property (nonatomic, retain) NSSet *kids;
@property (nonatomic, retain) LoginToken *who;

@end

@interface DetailInfo (CoreDataGeneratedAccessors)

- (void)addKidsObject:(UserKids *)value;
- (void)removeKidsObject:(UserKids *)value;
- (void)addKids:(NSSet *)values;
- (void)removeKids:(NSSet *)values;

@end
