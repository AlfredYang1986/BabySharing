//
//  MessageModel.m
//  ChatModel
//
//  Created by Alfred Yang on 3/05/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "MessageModel.h"
#import "ModelDefines.h"
#import <CoreData/CoreData.h>
#import "RemoteInstance.h"
#import "Messages+ContextOpt.h"
#import "AppDelegate.h"
#import "Messages+ContextOpt.h"
#import "EnumDefines.h"

@implementation MessageModel

@synthesize delegate = _delegate;
@synthesize doc = _doc;

- (id)initWithDelegate:(AppDelegate*)delegate {
    self = [super init];
    if (self) {
        _delegate = delegate;
        _doc = _delegate.gm.doc;
    }
    return self;
}

- (void)addMessageWithData:(NSDictionary*)data {
    [Messages addMessageWithData:data inContext:_doc.managedObjectContext];
}

- (NSArray*)queryAllMessagesWithReceiver:(NSString*)receiver andUser:(NSString*)user_id {
    return [Messages enumAllMessageWithReceiverType:MessageReceiverTypeTmpGroup andReceiver:receiver andUser:user_id inContext:_doc.managedObjectContext];
}
@end
