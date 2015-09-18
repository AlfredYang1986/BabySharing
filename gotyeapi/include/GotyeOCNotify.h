//
//  GotyeOCNotify.h
//  GotyeAPI
//
//  Created by Peter on 14/12/4.
//  Copyright (c) 2014年 Ailiao Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GotyeOCChatTarget.h"

typedef enum {
    GotyeNotifyTypeGroupInvite,             ///< 邀请入群
    GotyeNotifyTypeJoinGroupRequest,        ///< 申请入群
    GotyeNotifyTypeJoinGroupReply           ///< 入群回复
}GotyeNotifyType;                           ///< 通知类型枚举
/** 消息通知
 
 */
@interface GotyeOCNotify : NSObject

@property(nonatomic, assign) long dbID;                     ///< 本地数据库ID
@property(nonatomic, assign) long date;                     ///< 时间(自1970/1/1 00:00:00所经历的毫秒数)
@property(nonatomic, assign) bool isRead;                   ///< 是否已读
@property(nonatomic, retain) GotyeOCChatTarget* sender;     ///< 发送者
@property(nonatomic, retain) GotyeOCChatTarget* receiver;   ///< 接收者
@property(nonatomic, retain) GotyeOCChatTarget* from;       ///< 通知来源
@property(nonatomic, assign) bool agree;                    ///< 是否同意

@property(nonatomic, assign) bool isSystemNotify;           ///< 是否是系统通知
@property(nonatomic, assign) GotyeNotifyType type;          ///< 通知类型
@property(nonatomic, copy)   NSString* text;                ///< 文本内容

@end
