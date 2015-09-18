//
//  GotyeOCChatTarget.h
//  GotyeAPI
//
//  Created by Peter on 14/12/3.
//  Copyright (c) 2014年 Ailiao Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GotyeOCMedia.h"

typedef enum
{
    GotyeChatTargetTypeUser,    		///< 用户
    GotyeChatTargetTypeRoom,    		///< 聊天室
    GotyeChatTargetTypeGroup,   		///< 群组
    GotyeChatTargetTypeCustomerService	///< 客服
}GotyeChatTargetType;   ///< 聊天对象类型枚举

typedef enum
{
    GotyeUserGenderMale,    ///< 男
    GotyeUserGenderFemale,  ///< 女
    GotyeUserGenderNotSet   ///< 未设置
}GotyeUserGender;   ///< 用户性别枚举

/**
 *
 */
typedef enum {
    GotyeGroupTypePublic,       ///< 公开群(可被搜索)
    GotyeGroupTypePrivate       ///< 私有群(不能被搜索)
}GotyeGroupType;

/** 聊天对象父类
 
 */
@interface GotyeOCChatTarget : NSObject




@property(nonatomic, assign) GotyeChatTargetType type;   ///< 聊天对象类型(聊天室/群组/用户)

@property(nonatomic, assign) long long id;    ///< 聊天室/群组唯一标识,对用户无效
@property(nonatomic, copy) NSString* name;    ///< 聊天室/群组名字,对用户来说是唯一标识
@property(nonatomic, assign) unsigned tag;   ///< tag

@property(nonatomic, copy) NSString* info; ///< 附加信息
@property(nonatomic, assign) bool hasGotDetail; ///<是否已经从服务器获取到详情
@property(nonatomic, retain) GotyeOCMedia* icon;    ///< 头像信息

@end
/** 用户对象
 
 */
@interface GotyeOCUser : GotyeOCChatTarget



@property(nonatomic, copy) NSString* nickname;          ///< 昵称
@property(nonatomic, assign) GotyeUserGender gender;    ///< 性别

@property(nonatomic, assign) bool isBlocked;            ///< 是否在黑名单内
@property(nonatomic, assign) bool isFriend;             ///< 是否是好友

/**
 * @brief  通过账号生成用户对象
 * @param name: 用户名字
 * @return 用户对象
 */
+(instancetype)userWithName:(NSString*)name;

@end
/** 聊天室对象
 
 */
@interface GotyeOCRoom : GotyeOCChatTarget



@property(nonatomic, assign) bool isTop;                ///< 是否置顶

@property(nonatomic, assign) unsigned capacity;         ///< 成员人数上限
@property(nonatomic, assign) unsigned onlineNumber;     ///< 在线成员人数


/**
 * @brief  通过id生成聊天室对象
 * @param roomid: 聊天室id
 * @return 聊天室对象
 */
+(instancetype)roomWithId:(long long)roomid;


@end

/** 群组对象
 
 */

@interface GotyeOCGroup : GotyeOCChatTarget


@property(nonatomic, assign) GotyeGroupType ownerType; ///< 群组类型
@property(nonatomic, copy) NSString* ownerAccount;     ///< 拥有者
@property(nonatomic, assign) bool needAuthentication;  ///< 是否需要验证加入

@property(nonatomic, assign) unsigned capacity; ///< 群组人数上限

/**
 * @brief  通过id生成群组对象
 * @param groupid: 群id
 * @return 群组对象
 */

+(instancetype)groupWithId:(long long)groupid;  

@end

/**
 *  客服对象
 */
@interface GotyeOCCustomerService : GotyeOCChatTarget


/**
 *  通过id生成客服对象
 *
 *  @param groupId 客服对应的组的id
 *
 *  @return 客服对象
 */
+(instancetype)customerServiceWithGroupId:(int)groupId;

@end

