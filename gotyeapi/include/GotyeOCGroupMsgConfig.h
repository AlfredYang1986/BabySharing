//
//  GotyeOCGroupMsgConfig.h
//  GotyeIM
//
//  Created by ouyang on 15/4/17.
//  Copyright (c) 2015年 Gotye. All rights reserved.
//

typedef enum
{
    ShieldingGroupMsg = 0,
    ReceivingGroupMsg = 1 << 0,
    NotifyingGroupMsg = 1 << 1
}GotyeGroupMsgConfig;