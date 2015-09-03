//
//  Providers+ContextOpt.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 31/12/2014.
//  Copyright (c) 2014 YY. All rights reserved.
//

#import "Providers+ContextOpt.h"
#import "LoginToken+ContextOpt.h"

@implementation Providers (ContextOpt)

+ (Providers*)createProviderInContext:(NSManagedObjectContext*)context ByName:(NSString*)provider_name andProviderUserId:(NSString*)provider_user_id andProviderToken:(NSString*)provider_token andProviderScreenName:(NSString*)provider_screen_name {
   
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"Providers"];
    request.predicate = [NSPredicate predicateWithFormat:@"provider_user_id = %@", provider_user_id];
    NSSortDescriptor* des = [NSSortDescriptor sortDescriptorWithKey:@"provider_user_id" ascending:YES];
    
    request.sortDescriptors = [NSArray arrayWithObjects: des, nil];
    
    NSError* error = nil;
    NSArray* matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || matches.count > 1) {
        NSLog(@"error with primary key");
        return nil;
    } else if (matches.count == 1) {
        Providers* tmp = [matches lastObject];
        tmp.provider_user_id = provider_user_id;
        tmp.provider_token = provider_token;
        tmp.provider_name = provider_name;
        tmp.provider_screen_name = provider_screen_name;
//        [context save:nil];
        return tmp;
    } else {
        Providers* tmp =[NSEntityDescription insertNewObjectForEntityForName:@"Providers" inManagedObjectContext:context];
        tmp.provider_user_id = provider_user_id;
        tmp.provider_token = provider_token;
        tmp.provider_name = provider_name;
        tmp.provider_screen_name = provider_screen_name;
//        [context save:nil];
        return tmp;
    }
}

+ (Providers*)enumProvideInContext:(NSManagedObjectContext*)context ByName:(NSString*)provider_name andCurrentUserID:(NSString*)user_id {
    Providers* result = nil;
    LoginToken* cur = [LoginToken enumLoginUserInContext:context withUserID:user_id];
    for (Providers* p in cur.connectWith.allObjects) {
        if ([p.provider_name isEqualToString:provider_name]) {
            result = p;
            break;
        }
    }
    return result;
}
@end
