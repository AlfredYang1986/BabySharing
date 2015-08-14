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
#import "UserKids.h"

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

+ (NSDictionary*)currentDetailInfoInContext:(NSManagedObjectContext*)context {
    LoginToken* current = [self enumCurrentLoginUserInContext:context].who;
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    if (current.detailInfo != nil) {
        [dic setObject:current.detailInfo.age forKey:@"age"];
        [dic setObject:current.role_tag forKey:@"role_tag"];
        [dic setObject:[NSNumber numberWithLongLong:[NSNumber numberWithDouble:current.detailInfo.dob.timeIntervalSince1970 * 1000].longLongValue] forKey:@"dob"];
        [dic setObject:current.detailInfo.horoscope forKey:@"horoscope"];
        [dic setObject:current.detailInfo.school forKey:@"school"];
        [dic setObject:0 forKey:@"gender"];
       
        NSMutableArray* arr = [[NSMutableArray alloc]initWithCapacity:current.detailInfo.kids.count];
        for (UserKids* uk in current.detailInfo.kids.allObjects) {
            NSMutableDictionary* kid_dic = [[NSMutableDictionary alloc]init];
            [kid_dic setObject:[NSNumber numberWithLongLong:[NSNumber numberWithDouble:uk.dob.timeIntervalSince1970 * 1000].longLongValue] forKey:@"dob"];
            [kid_dic setObject:uk.school forKey:@"school"];
            [kid_dic setObject:uk.horoscope forKey:@"horoscope"];
            [kid_dic setObject:uk.gender forKey:@"gender"];
            
            [arr addObject:[kid_dic copy]];
        }
        [dic setObject:arr forKey:@"kids"];
    }
    return [dic copy];
}

+ (void)clearAllKidsWithDetailInfo:(DetailInfo*)di inContext:(NSManagedObjectContext*)context {
    while (di.kids.count != 0) {
        UserKids* tmp = di.kids.anyObject;
        tmp.parent = nil;
        [di removeKidsObject:tmp];
        [context deleteObject:tmp];
    }
}

+ (UserKids*)updateCurrentDetailKidsWithAttr:(NSDictionary*)dic forDeatailInfo:(DetailInfo*)info inContext:(NSManagedObjectContext*)context {
    
    UserKids* tmp = [NSEntityDescription insertNewObjectForEntityForName:@"UserKids" inManagedObjectContext:context];
    NSEnumerator* enumerator = dic.keyEnumerator;
    id iter = nil;
    
    while ((iter = [enumerator nextObject]) != nil) {
        if ([iter isEqualToString:@"age"]) {
            tmp.age = [dic objectForKey:iter];
        } else if ([iter isEqualToString:@"dob"]) {
            tmp.dob = [NSDate dateWithTimeIntervalSince1970:((NSNumber*)[dic objectForKey:iter]).longLongValue / 1000.0];
        } else if ([iter isEqualToString:@"gender"]) {
            tmp.gender = [dic objectForKey:iter];
        } else if ([iter isEqualToString:@"school"]) {
            tmp.school = [dic objectForKey:iter];
        } else {
            // user id, do nothing
        }
    }
    
    tmp.parent = info;
    [info addKidsObject:tmp];
    
    return tmp;
}

+ (void)updateCurrentDetailInfoWithAttr:(NSDictionary*)dic InContext:(NSManagedObjectContext*)context {
    LoginToken* current = [self enumCurrentLoginUserInContext:context].who;
    DetailInfo* tmp = current.detailInfo;
    
    if (tmp == nil) {
        tmp = [NSEntityDescription insertNewObjectForEntityForName:@"DetailInfo" inManagedObjectContext:context];
        tmp.who = current;
        current.detailInfo = tmp;
    }
    
    NSEnumerator* enumerator = dic.keyEnumerator;
    id iter = nil;
    
    while ((iter = [enumerator nextObject]) != nil) {
        if ([iter isEqualToString:@"age"]) {
            tmp.age = [dic objectForKey:iter];
        } else if ([iter isEqualToString:@"role_tag"]) {
            current.role_tag = [dic objectForKey:iter];
        } else if ([iter isEqualToString:@"dob"]) {
            tmp.dob = [NSDate dateWithTimeIntervalSince1970:((NSNumber*)[dic objectForKey:iter]).longLongValue / 1000.0];
        } else if ([iter isEqualToString:@"gender"]) {
//            tmp.gender = [dic objectForKey:iter];
        } else if ([iter isEqualToString:@"school"]) {
            tmp.school = [dic objectForKey:iter];
        } else if ([iter isEqualToString:@"kids"]) {
  
            [self clearAllKidsWithDetailInfo:tmp inContext:context];
            NSArray* kids = [dic objectForKey:@"kids"];
            for (NSDictionary* iter in kids) {
                [self updateCurrentDetailKidsWithAttr:iter forDeatailInfo:tmp inContext:context];
            }
            
        } else {
            // user id, do nothing
        }
    }
}
@end
