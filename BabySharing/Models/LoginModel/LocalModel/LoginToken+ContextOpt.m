//
//  LoginToken+ContextOpt.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 29/12/2014.
//  Copyright (c) 2014 YY. All rights reserved.
//

#import "LoginToken+ContextOpt.h"

@implementation LoginToken (ContextOpt)

#pragma mark -- enum users
+ (NSArray*)loginUsersWithContext:(NSManagedObjectContext*)context  {
    return nil;
}

+ (NSArray*)enumAllLoginUsersWithContext: (NSManagedObjectContext*)context {

    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"LoginToken"];
    NSSortDescriptor* des = [NSSortDescriptor sortDescriptorWithKey:@"auth_token" ascending:YES];
    
    request.sortDescriptors = [NSArray arrayWithObjects: des, nil];
   
    NSError* error = nil;
    NSArray* matches = [context executeFetchRequest:request error:&error];
   
    return matches;
}

#pragma mark -- operation with phone number
+ (NSArray*)enumLoginUsersInContext:(NSManagedObjectContext*)context WithPhoneNo:(NSString*)phoneNo {
    
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"LoginToken"];
    request.predicate = [NSPredicate predicateWithFormat:@"phoneNo = %@", phoneNo];
    NSSortDescriptor* des = [NSSortDescriptor sortDescriptorWithKey:@"auth_token" ascending:YES];
    
    request.sortDescriptors = [NSArray arrayWithObjects: des, nil];
    
    NSError* error = nil;
    return [context executeFetchRequest:request error:&error];
}

+ (void)removeTokenInContext:(NSManagedObjectContext*)context WithPhoneNum:(NSString*)phoneNo {
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"LoginToken"];
    request.predicate = [NSPredicate predicateWithFormat:@"phoneNo = %@", phoneNo];
    NSSortDescriptor* des = [NSSortDescriptor sortDescriptorWithKey:@"user_id" ascending:YES];
    
    request.sortDescriptors = [NSArray arrayWithObjects: des, nil];
    
    NSError* error = nil;
    NSArray* matches = [context executeFetchRequest:request error:&error];
   
   
    for (LoginToken* tmp in matches) {
        [context deleteObject:tmp];
    }
}

+ (void)unbindTokenInContext:(NSManagedObjectContext*)context WithPhoneNum:(NSString*)phoneNo {
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"LoginToken"];
    request.predicate = [NSPredicate predicateWithFormat:@"phoneNo = %@", phoneNo];
    NSSortDescriptor* des = [NSSortDescriptor sortDescriptorWithKey:@"user_id" ascending:YES];
    
    request.sortDescriptors = [NSArray arrayWithObjects: des, nil];
    
    NSError* error = nil;
    NSArray* matches = [context executeFetchRequest:request error:&error];
    
    
    for (LoginToken* tmp in matches) {
        tmp.phoneNo = @"";
    }
}

#pragma mark -- user attr
+ (NSDictionary*)userToken2Attr:(LoginToken*)user {
    NSMutableDictionary* reVal = [[NSMutableDictionary alloc]init];
   
    [reVal setValue:user.user_id forKey:@"user_id"];
    [reVal setValue:user.auth_token forKey:@"auth_token"];
    [reVal setValue:user.phoneNo forKey:@"phoneNo"];
    [reVal setValue:user.screen_name forKey:@"screen_name"];
    [reVal setValue:user.screen_image forKey:@"screen_photo"];
    [reVal setValue:user.role_tag forKey:@"role_tag"];
    
    return [reVal copy];
}

#pragma mark -- operation with user id (primary key)
+ (void)handlerAttrInLoginToken:(LoginToken*)tmp withAttrs:(NSDictionary*)dic {
    NSEnumerator* enumerator = dic.keyEnumerator;
    id iter = nil;
    
    while ((iter = [enumerator nextObject]) != nil) {
        if ([iter isEqualToString:@"auth_token"]) {
            tmp.auth_token = [dic objectForKey:iter];
        } else if ([iter isEqualToString:@"phoneNo"]) {
            tmp.phoneNo = [dic objectForKey:iter];
        } else if ([iter isEqualToString:@"screen_name"]) {
//        } else if ([iter isEqualToString:@"name"]) {
            tmp.screen_name = [dic objectForKey:iter];
        } else if ([iter isEqualToString:@"screen_photo"]) {
            tmp.screen_image = [dic objectForKey:iter];
        } else if ([iter isEqualToString:@"connectWith"]) {
            tmp.connectWith = [dic objectForKey:iter];
        } else if ([iter isEqualToString:@"role_tag"]) {
            tmp.role_tag = [dic objectForKey:iter];
        } else if ([iter isEqualToString:@"user_id"]) {
            if (tmp.user_id == nil) {
                tmp.user_id = [dic objectForKey:iter];
            }
        } else {
            // user id, do nothing
        }
    }
}

+ (LoginToken *)createTokenInContext:(NSManagedObjectContext*)context withUserID:(NSString*)user_id andAttrs:(NSDictionary*)dic {
    
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"LoginToken"];
    request.predicate = [NSPredicate predicateWithFormat:@"user_id = %@", user_id];
    NSSortDescriptor* des = [NSSortDescriptor sortDescriptorWithKey:@"user_id" ascending:YES];
    
    request.sortDescriptors = [NSArray arrayWithObjects: des, nil];
    
    NSError* error = nil;
    NSArray* matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || matches.count > 1) {
        NSLog(@"error with primary key");
        return nil;
    } else if (matches.count == 1) {
        LoginToken *tmp = [matches lastObject];
        [LoginToken handlerAttrInLoginToken:tmp withAttrs:dic];
        return tmp;
    } else {
        LoginToken* tmp = [NSEntityDescription insertNewObjectForEntityForName:@"LoginToken" inManagedObjectContext:context];
        [LoginToken handlerAttrInLoginToken:tmp withAttrs:dic];
        return tmp;
    }
}

+ (void)removeTokenInContext:(NSManagedObjectContext*)context withUserID:(NSString*)user_id {
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"LoginToken"];
    request.predicate = [NSPredicate predicateWithFormat:@"user_id = %@", user_id];
    NSSortDescriptor* des = [NSSortDescriptor sortDescriptorWithKey:@"user_id" ascending:YES];
    
    request.sortDescriptors = [NSArray arrayWithObjects: des, nil];
    
    NSError* error = nil;
    NSArray* matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || matches.count > 1) {
        NSLog(@"error with primary key");
    } else if (matches.count == 1) {
        LoginToken* tmp = [matches lastObject];
        [context deleteObject:tmp];
    } else {
        NSLog(@"nothing need to be delected");
    }
}

+ (BOOL)updataLoginUserInContext:(NSManagedObjectContext*)context withUserID:(NSString*)user_id andAttrs:(NSDictionary*)dic {
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"LoginToken"];
    request.predicate = [NSPredicate predicateWithFormat:@"user_id = %@", user_id];
    NSSortDescriptor* des = [NSSortDescriptor sortDescriptorWithKey:@"user_id" ascending:YES];
    
    request.sortDescriptors = [NSArray arrayWithObjects: des, nil];
    
    NSError* error = nil;
    NSArray* matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || matches.count > 1) {
        NSLog(@"error with primary key");
        return NO;
    } else if (matches.count == 1) {
        LoginToken* tmp = [matches lastObject];
        [LoginToken handlerAttrInLoginToken:tmp withAttrs:dic];
        //        [context save:&error];
        return YES;
    } else {
        NSLog(@"nothing need to be delected");
        return NO;
    }
}

+ (LoginToken*)enumLoginUserInContext:(NSManagedObjectContext*)context withUserID:(NSString*)user_id {
    
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"LoginToken"];
    request.predicate = [NSPredicate predicateWithFormat:@"user_id = %@", user_id];
    NSSortDescriptor* des = [NSSortDescriptor sortDescriptorWithKey:@"user_id" ascending:YES];
    
    request.sortDescriptors = [NSArray arrayWithObjects: des, nil];
    
    NSError* error = nil;
    NSArray* matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || matches.count > 1) {
        NSLog(@"error with primary key");
        return nil;
    } else if (matches.count == 1) {
        return [matches lastObject];
    } else {
        NSLog(@"user not exist");
        return nil;
    }
}
@end
