//
//  RegCurrentToken+ContextOpt.m
//  BabySharing
//
//  Created by Alfred Yang on 3/12/16.
//  Copyright © 2016 BM. All rights reserved.
//

#import "RegCurrentToken+ContextOpt.h"
#import "LoginToken.h"
#import "LoginToken+ContextOpt.h"

@implementation RegCurrentToken(ContextOpt)
+ (RegCurrentToken*)changeCurrentRegLoginUser:(LoginToken*)lgt inContext:(NSManagedObjectContext*)context {
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"RegCurrentToken"];
    
    NSError* error = nil;
    NSArray* matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || matches.count > 1) {
        NSLog(@"should have one and only one current user");
        return nil;
    } else if (matches.count == 1) {
        RegCurrentToken* tmp = [matches lastObject];
        if ([tmp.who.user_id isEqualToString:lgt.user_id]) {
            tmp.last_login_data = [NSDate date];
            tmp.status = [NSNumber numberWithInt:1]; // 1 => online
        } else {
            tmp.who = lgt;
            tmp.status = [NSNumber numberWithInt:1]; // 1 => online
        }
        [context save:nil];
        return tmp;
    } else {
        NSLog(@"nothing need to be delected");
        RegCurrentToken* tmp = [NSEntityDescription insertNewObjectForEntityForName:@"RegCurrentToken" inManagedObjectContext:context];
        tmp.last_login_data = [NSDate date];
        tmp.who = lgt;
        tmp.status = [NSNumber numberWithInt:1]; // 1 => online
        [context save:nil];
        return tmp;
    }
}

+ (RegCurrentToken*)changeCurrentRegLoginUserWithUserID:(NSString*)user_id inContext:(NSManagedObjectContext*)context {
    LoginToken* tmp = [LoginToken enumLoginUserInContext:context withUserID:user_id];
    return [RegCurrentToken changeCurrentRegLoginUser:tmp inContext:context];
}

#pragma mark -- enum current user
+ (RegCurrentToken*)enumCurrentRegLoginUserInContext:(NSManagedObjectContext*)context {
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"RegCurrentToken"];
    
    NSError* error = nil;
    NSArray* matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || matches.count > 1) {
        NSLog(@"should have one and only one current user");
        return nil;
    } else if (matches.count == 1) {
        return [matches lastObject];
    } else {
        NSLog(@"nothing need to be delected");
        return nil;
    }
}

#pragma mark -- delect current reg user
+ (BOOL)deleteCurrentRegUserInContext:(NSManagedObjectContext*)context {
    
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"RegCurrentToken"];
    
    NSError* error = nil;
    NSArray* matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || matches.count > 1) {
        NSLog(@"should have one and only one current user");
        return NO;
        
    } else if (matches.count == 1) {
        RegCurrentToken* tmp = [matches lastObject];
        tmp.who = nil;
        [context deleteObject:tmp];
        return YES;
        
    } else {
        NSLog(@"nothing need to be delected");
        return NO;
    }
}
@end
