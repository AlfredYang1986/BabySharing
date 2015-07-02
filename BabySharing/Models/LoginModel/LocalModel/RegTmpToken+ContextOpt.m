//
//  RegTmpToken+ContextOpt.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 29/12/2014.
//  Copyright (c) 2014 YY. All rights reserved.
//

#import "RegTmpToken+ContextOpt.h"

@implementation RegTmpToken (ContextOpt)

+ (RegTmpToken*)createRegTokenInContext:(NSManagedObjectContext*)context WithToken:(NSString*)reg_token andPhoneNumber:(NSString *)phoneNo {
   
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"RegTmpToken"];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"phoneNo = %@", phoneNo];
    request.predicate = predicate;
    
    NSSortDescriptor* des = [NSSortDescriptor sortDescriptorWithKey:@"reg_token" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObjects: des, nil];
   
    NSError* error = nil;
    NSArray* matches = [context executeFetchRequest:request error:&error];
   
    if (!matches || matches.count > 1) {
        NSLog(@"error with primary key");
        return nil;
    } else if (matches.count == 1) {
        RegTmpToken* tmp = [matches lastObject];
        tmp.reg_token = reg_token;
        tmp.phoneNo = phoneNo;
        [context save:nil];
        return tmp;
    } else {
        RegTmpToken* tmp = [NSEntityDescription insertNewObjectForEntityForName:@"RegTmpToken" inManagedObjectContext:context];
        tmp.reg_token = reg_token;
        tmp.phoneNo = phoneNo;
        [context save:nil];
        return tmp;
    }
}

+ (void)removeTokenInContext:(NSManagedObjectContext*)context WithToken:(NSString*)reg_token {
 
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"RegTmpToken"];

    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"reg_token = %@", reg_token];
    request.predicate = predicate;
    
    NSSortDescriptor* des = [NSSortDescriptor sortDescriptorWithKey:@"reg_token" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObjects: des, nil];
    
    NSError* error = nil;
    NSArray* matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || matches.count > 1) {
        NSLog(@"error with primary key");
    } else if (matches.count == 1) {
        RegTmpToken* tmp = [matches lastObject];
        [context deleteObject:tmp];
        [context performBlock:^{   //or performBlockAndWait:
            // do stuff with context
            BOOL b = [context save:nil];
            if (b) {
                NSLog(@"save success");
            } else {
                NSLog(@"save failed");
            }
        }];
    } else {
        NSLog(@"nothing need to be delected");
    }
}

+ (RegTmpToken*)enumRegTokenINContext:(NSManagedObjectContext*)context WithToken:(NSString*)reg_token {
    
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"RegTmpToken"];

    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"reg_token = %@", reg_token];
    request.predicate = predicate;
    
    NSSortDescriptor* des = [NSSortDescriptor sortDescriptorWithKey:@"reg_token" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObjects:des, nil];
    
    NSError* error = nil;
    NSArray* matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || matches.count > 1) {
        NSLog(@"error with primary key");
        return nil;
    } else if (matches.count == 1) {
        return [matches lastObject];
    } else {
        NSLog(@"nothing need to be delected");
        return nil;
    }
}

+ (RegTmpToken*)enumRegTokenINContext:(NSManagedObjectContext*)context WithPhoneNo:(NSString*)phoneNo {
    
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"RegTmpToken"];

    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"phoneNo = %@", phoneNo];
    request.predicate = predicate;
    
    NSSortDescriptor* des = [NSSortDescriptor sortDescriptorWithKey:@"reg_token" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObjects:des, nil];
    
    NSError* error = nil;
    NSArray* matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || matches.count > 1) {
        NSLog(@"error with primary key");
        return nil;
    } else if (matches.count == 1) {
        return [matches lastObject];
    } else {
        NSLog(@"nothing need to be delected");
        return nil;
    }   
}
@end
