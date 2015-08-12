//
//  CurrentToken+ContextOpt.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 1/01/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "CurrentToken+ContextOpt.h"
#import "LoginToken+ContextOpt.h"
#import "DetailInfo.h"

@implementation CurrentToken (ContextOpt)

#pragma mark -- change current user
+ (CurrentToken*)changeCurrentLoginUser:(LoginToken*)lgt inContext:(NSManagedObjectContext*)context {
    
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"CurrentToken"];
    
    NSError* error = nil;
    NSArray* matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || matches.count > 1) {
        NSLog(@"should have one and only one current user");
        return nil;
    } else if (matches.count == 1) {
        CurrentToken* tmp = [matches lastObject];
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
        CurrentToken* tmp = [NSEntityDescription insertNewObjectForEntityForName:@"CurrentToken" inManagedObjectContext:context];
        tmp.last_login_data = [NSDate date];
        tmp.who = lgt;
        tmp.status = [NSNumber numberWithInt:1]; // 1 => online
        [context save:nil];
        return tmp;
    }
}

+ (CurrentToken*)changeCurrentLoginUserWithUserID:(NSString*)user_id inContext:(NSManagedObjectContext*)context {
    LoginToken* tmp = [LoginToken enumLoginUserInContext:context withUserID:user_id];
    return [CurrentToken changeCurrentLoginUser:tmp inContext:context];
}

#pragma mark -- enum current user
+ (CurrentToken*)enumCurrentLoginUserInContext:(NSManagedObjectContext*)context {
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"CurrentToken"];
    
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

#pragma mark -- log out
+ (BOOL)logOutCurrentLoginUserInContext:(NSManagedObjectContext*)context {
    
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"CurrentToken"];
    
    NSError* error = nil;
    NSArray* matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || matches.count > 1) {
        NSLog(@"should have one and only one current user");
        return NO;
        
    } else if (matches.count == 1) {
        CurrentToken* tmp = [matches lastObject];
        tmp.who = nil;
        [context deleteObject:tmp];
        return YES;
        
    } else {
        NSLog(@"nothing need to be delected");
        return NO;
    }
}

+ (BOOL)offlineCurrentLoginUserInContext:(NSManagedObjectContext*)context {
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"CurrentToken"];
    
    NSError* error = nil;
    NSArray* matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || matches.count > 1) {
        NSLog(@"should have one and only one current user");
        return NO;
        
    } else if (matches.count == 1) {
        CurrentToken* tmp = [matches lastObject];
        tmp.status = [NSNumber numberWithInt:-1]; // -1 => offline
        return YES;
        
    } else {
        NSLog(@"nothing need to be delected");
        return NO;
    }
}

+ (BOOL)onlineCurrentLoginUserInContext:(NSManagedObjectContext*)context {
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"CurrentToken"];
    
    NSError* error = nil;
    NSArray* matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || matches.count > 1) {
        NSLog(@"should have one and only one current user");
        return NO;
        
    } else if (matches.count == 1) {
        CurrentToken* tmp = [matches lastObject];
        tmp.status = [NSNumber numberWithInt:1]; // -1 => offline
        return YES;
        
    } else {
        NSLog(@"nothing need to be delected");
        return NO;
    }
}

+ (BOOL)isCurrentOfflineInContext:(NSManagedObjectContext*)context {
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"CurrentToken"];
    
    NSError* error = nil;
    NSArray* matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || matches.count > 1) {
        NSLog(@"should have one and only one current user");
        return NO;
        
    } else if (matches.count == 1) {
        CurrentToken* tmp = [matches lastObject];
        return tmp.status.integerValue == -1;
        
    } else {
        NSLog(@"nothing need to be delected");
        return NO;
    }
}

#pragma mark -- local detail info
+ (BOOL)isCurrentHasDetailInfoInContext:(NSManagedObjectContext*)context {
    LoginToken* current = [self enumCurrentLoginUserInContext:context].who;
    return current.detailInfo != nil;
}
@end
