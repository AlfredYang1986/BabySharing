//
//  GotyeOCGroupMsgConfig.h
//  GotyeIM
//
//  Created by ouyang on 15/4/17.
//  Copyright (c) 2015年 Gotye. All rights reserved.
//

/**
 群消息提醒设置的枚举值。
 此枚举中的每个值都是单独生效的
 */
typedef enum
{
    /**
     *  屏蔽群消息。不接收任何群消息
     */
    ShieldingGroupMsg = 0,
    
    /**
     *  接收群消息。如果单独设置的话，表示接收群消息，但是不接收离线推送。如果需要设置为接收群消息并提醒（离线推送），可以这么设置
     *  @code
     *  [GotyeOCAPI setChatTarget:groupTarget msgConfig:ReceivingGroupMsg | NotifyingGroupMsg];
     */
    ReceivingGroupMsg = 1 << 0,
    
    /**
     *  接收群离线推送。这个设置单独设置是无效的，需要配合ReceivingGroupMsg一起使用
     */
    NotifyingGroupMsg = 1 << 1
    
}GotyeGroupMsgConfig;