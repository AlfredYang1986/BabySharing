//
//  Messages+ContextOpt.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 8/06/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Messages.h"
#import "EnumDefines.h"

@interface Messages (ContextOpt)

+ (Messages*)addMessageWithData:(NSDictionary*)dic inContext:(NSManagedObjectContext*)context;
+ (NSArray*)enumAllMessageWithReceiverType:(MessageReceiverType)rt andReceiver:(NSString*)r_id andUser:(NSString*)u_id inContext:(NSManagedObjectContext*)context;
@end
