//
//  EnumDefines.h
//  ChatModel
//
//  Created by Alfred Yang on 5/05/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#ifndef ChatModel_EnumDefines_h
#define ChatModel_EnumDefines_h

typedef NS_ENUM(NSInteger, MessageType) {
    MessageTypeNone,
    MessageTypeTextMessage,
    MessageTypeMovieMessage,
    MessageTypeImageMessage,
    MEssageTypeVoiceMessage,
};

typedef NS_ENUM(NSInteger, MessageStatus) {
    MessagesStatusUnread,
    MessagesStatusReaded,
    MessagesStatusUnSended,
    MessagesStatusSended,
};

typedef NS_ENUM(NSInteger, MessageReceiverType) {
    MessageReceiverTypeUser,
    MessageReceiverTypeChatGroup,
    MessageReceiverTypeUserGroup,
};

typedef NS_ENUM(NSInteger, NotificationActionType) {
    NotificationActionTypeFollow,
    NotificationActionTypeUnFollow,
    NotificationActionTypeLike,
    NotificationActionTypePush,
    NotificationActionTypeLoginOnOtherDevice,
    NotificationActionTypeMessage,
};
#endif
