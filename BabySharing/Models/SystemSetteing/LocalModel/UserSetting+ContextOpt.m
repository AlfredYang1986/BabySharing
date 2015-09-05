//
//  UserSetting+ContextOpt.m
//  BabySharing
//
//  Created by Alfred Yang on 5/09/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "UserSetting+ContextOpt.h"
#import "MessageSetting.h"

@implementation UserSetting (ContextOpt)

+ (UserSetting*)enumUserSettingByUserID:(NSString*)user_id inContext:(NSManagedObjectContext*)context {
    
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"UserSetting"];
    request.predicate = [NSPredicate predicateWithFormat:@"user_id = %@", user_id];
//    NSSortDescriptor* des = [NSSortDescriptor sortDescriptorWithKey:@"user_id" ascending:YES];
//    request.sortDescriptors = [NSArray arrayWithObjects: des, nil];
    
    NSError* error = nil;
    NSArray* matches = [context executeFetchRequest:request error:&error];

    if (!matches || matches.count > 1) {
        NSLog(@"should have one and only one current user");
        return nil;
    } else if (matches.count == 1) {
        return [matches lastObject];
    } else {
        UserSetting* tmp = [NSEntityDescription insertNewObjectForEntityForName:@"UserSetting" inManagedObjectContext:context];
        tmp.user_id = user_id;
        return tmp;
    }
}

+ (void)refreshMessageSettingWithUserID:(NSString*)user_id andSetting:(NSDictionary*)dic inContext:(NSManagedObjectContext*)context {
    UserSetting* cur = [self enumUserSettingByUserID:user_id inContext:context];
    if (cur) {
       
        MessageSetting* tmp = cur.messageSetting;
        if (!tmp) {
            tmp = [NSEntityDescription insertNewObjectForEntityForName:@"MessageSetting" inManagedObjectContext:context];
            
            tmp.mode_silence = [NSNumber numberWithBool:NO];
            tmp.mode_voice = [NSNumber numberWithBool:YES];
            tmp.mode_viber = [NSNumber numberWithBool:NO];
            
            tmp.notify_cycle = [NSNumber numberWithBool:YES];
            tmp.notify_p2p = [NSNumber numberWithBool:YES];
            tmp.notify_notification = [NSNumber numberWithBool:YES];
            tmp.notify_dongda = [NSNumber numberWithBool:YES];

            cur.messageSetting = tmp;
            tmp.who = cur;
        }
        
        NSEnumerator* enumerator = dic.keyEnumerator;
        id iter = nil;
        
        while ((iter = [enumerator nextObject]) != nil) {
            if ([iter isEqualToString:@"mode_silence"]) {
                tmp.mode_silence = [dic objectForKey:iter];
            } else if ([iter isEqualToString:@"mode_voice"]) {
                tmp.mode_voice = [dic objectForKey:iter];
            } else if ([iter isEqualToString:@"mode_viber"]) {
                tmp.mode_viber = [dic objectForKey:iter];
            } else if ([iter isEqualToString:@"notify_cycle"]) {
                tmp.notify_cycle = [dic objectForKey:iter];
            } else if ([iter isEqualToString:@"notify_p2p"]) {
                tmp.notify_p2p = [dic objectForKey:iter];
            } else if ([iter isEqualToString:@"notify_notification"]) {
                tmp.notify_notification = [dic objectForKey:iter];
            } else if ([iter isEqualToString:@"notify_dongda"]) {
                tmp.notify_dongda = [dic objectForKey:iter];
            } else {
                // user id, do nothing
            }
        }
        
    }
    [context save:nil];
}

+ (MessageSetting*)queryMessageSettingWithUserID:(NSString*)user_id inContext:(NSManagedObjectContext*)context {
    
    UserSetting* cur = [self enumUserSettingByUserID:user_id inContext:context];
    MessageSetting* tmp = cur.messageSetting;
    if (tmp == nil) {
        tmp = [NSEntityDescription insertNewObjectForEntityForName:@"MessageSetting" inManagedObjectContext:context];
            
        tmp.mode_silence = [NSNumber numberWithBool:NO];
        tmp.mode_voice = [NSNumber numberWithBool:YES];
        tmp.mode_viber = [NSNumber numberWithBool:NO];
        
        tmp.notify_cycle = [NSNumber numberWithBool:YES];
        tmp.notify_p2p = [NSNumber numberWithBool:YES];
        tmp.notify_notification = [NSNumber numberWithBool:YES];
        tmp.notify_dongda = [NSNumber numberWithBool:YES];

        cur.messageSetting = tmp;
        tmp.who = cur;
    }
    
    return tmp;
}
@end
