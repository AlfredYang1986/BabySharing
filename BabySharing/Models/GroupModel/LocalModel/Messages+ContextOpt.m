//
//  Messages+ContextOpt.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 8/06/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "Messages+ContextOpt.h"
#import "Group+ContextOpt.h"
#import "SubGroup.h"

@implementation Messages (ContextOpt)

+ (Messages*)addMessageWithData:(NSDictionary*)dic inContext:(NSManagedObjectContext*)context {
    NSString* receive_id = [dic objectForKey:@"receiver"];
    MessageReceiverType type = ((NSNumber*)[dic objectForKey:@"receiver_type"]).integerValue;
    if (type == MessageReceiverTypeTmpGroup) {
       
     
        SubGroup* sb = [Group enumSubGroupBySubGroupID:receive_id inContext:context];
        if (sb != nil) {
            Messages * tmp = [NSEntityDescription insertNewObjectForEntityForName:@"Messages" inManagedObjectContext:context];
            tmp.type = [dic objectForKey:@"messeage_type"];
            tmp.owner = [dic objectForKey:@"sender"];
            tmp.content = [dic objectForKey:@"message_content"];
            tmp.status = [NSNumber numberWithInt:MessagesStatusReaded];
        
            NSNumber* mills = [dic objectForKey:@"date"];
            NSTimeInterval seconds = mills.longLongValue / 1000.0;
            tmp.date = [NSDate dateWithTimeIntervalSince1970:seconds];
            
            [sb addMessagesObject:tmp];
            
            return tmp;
        }
    }
    return nil;
}

+ (NSArray*)enumAllMessageWithReceiverType:(MessageReceiverType)rt andReceiver:(NSString*)r_id andUser:(NSString*)u_id inContext:(NSManagedObjectContext*)context {
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"Messages"];
    request.predicate = [NSPredicate predicateWithFormat:@"belongs.sub_group_id = %@", r_id];

    NSError* error = nil;
    return [context executeFetchRequest:request error:&error];
}
@end
