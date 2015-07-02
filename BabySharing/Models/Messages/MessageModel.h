//
//  MessageModel.h
//  ChatModel
//
//  Created by Alfred Yang on 3/05/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Targets;
@class AppDelegate;

@interface MessageModel : NSObject

@property (nonatomic, weak, readonly) AppDelegate* delegate;
@property (weak, nonatomic, readonly) UIManagedDocument* doc;

#pragma mark -- constructor
- (id)initWithDelegate:(AppDelegate*)delegate;

- (void)addMessageWithData:(NSDictionary*)data;
- (NSArray*)queryAllMessagesWithReceiver:(NSString*)receiver andUser:(NSString*)user_id;
@end
