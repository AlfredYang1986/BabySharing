//
//  RegTmpToken.h
//  
//
//  Created by Alfred Yang on 12/08/2015.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface RegTmpToken : NSManagedObject

@property (nonatomic, retain) NSString * phoneNo;
@property (nonatomic, retain) NSString * reg_token;

@end
