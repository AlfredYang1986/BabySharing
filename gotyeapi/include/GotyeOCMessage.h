//
//  GotyeMessage.h
//  GotyeAPI
//
//  Created by Peter on 14/12/3.
//  Copyright (c) 2014年 Ailiao Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GotyeOCMedia.h"
#import "GotyeOCChatTarget.h"

typedef enum
{
    GotyeMessageTypeText,       ///< 文本消息
    GotyeMessageTypeImage,      ///< 图片消息
    GotyeMessageTypeAudio,      ///< 语音消息
    GotyeMessageTypeUserData,   ///< 用户自定义数据消息
}GotyeMessageType;              ///< 消息类型枚举

typedef enum
{
    GotyeMessageStatusCreated,          ///< 已创建
    GotyeMessageStatusUnread,           ///< 未读
    GotyeMessageStatusRead,             ///< 已读
    GotyeMessageStatusSending,          ///< 发送中
    GotyeMessageStatusSent,             ///< 已发送
    GotyeMessageStatusSendingFailed     ///< 发送失败
}GotyeMessageStatus; ///< 消息状态枚举

typedef enum
{
	GotyeWhineModeDefault,              ///< 不变声
	GotyeWhineModeFatherChristmas,      ///< 圣诞老人
	GotyeWhineModeOptimus,              ///< 擎天柱
	GotyeWhineModeDolphine,             ///< 海豚
	GotyeWhineModeBaby,                 ///< 娃娃音
	GotyeWhineModeSubwoofer             ///< 低音炮
}GotyeWhineMode;	///< 变声模式枚举

/** 消息对象
 
 */
@interface GotyeOCMessage : NSObject

@property(nonatomic, assign) long long id;          ///< 服务器数据库id
@property(nonatomic, assign) unsigned date;         ///<  时间(自1970/1/1 00:00:00所经历的毫秒数)
@property(nonatomic, assign) long long dbID;        ///< 本地数据库id
@property(nonatomic, copy) NSString* text;          ///< 文本内容
@property(nonatomic, retain) GotyeOCMedia* media;   ///< 语音/图片/用户自定义数据
@property(nonatomic, retain) GotyeOCMedia* extra;   ///< 消息附加数据

@property(nonatomic, assign) GotyeMessageType type;         ///< 消息类型
@property(nonatomic, assign) GotyeMessageStatus status;     ///< 消息状态
@property(nonatomic, retain) GotyeOCChatTarget* sender;     ///< 发送者
@property(nonatomic, retain) GotyeOCChatTarget* receiver;   ///< 接收者


/**
 * @brief 判断是否存在媒体数据
 */
-(bool) hasMedia;
/**
 * @brief 判断是否存在附加数据
 */
-(bool) hasExtraData;

/**
 * @brief 获取用户自定义数据
 */
-(NSData*) getUserData;

/**
 * @brief 获取附加数据
 */
-(NSData*) getExtraData;


/**
 * @brief 创建消息对象
 * @param receiver: 接收者
 * @return 消息对象
 */
+(instancetype)createMessage:(GotyeOCChatTarget*)receiver;
/**
 * @brief 创建消息对象
 * @param sender: 发送者
 * @param receiver: 接收者
 * @return 消息对象
 */
+(instancetype)createMessage:(GotyeOCChatTarget*)sender  receiver:(GotyeOCChatTarget*)receiver;

/**
 * @brief 创建文本消息对象
 * @param text: 文本
 * @param receiver: 接收者
 * @return 消息对象
 */
+(instancetype)createTextMessage:(GotyeOCChatTarget*)receiver text:(NSString*)text;
/**
 * @brief 创建文本消息对象
 * @param sender: 发送者
 * @param receiver: 接收者
 * @param text: 文本
 * @return 消息对象
 */
+(instancetype)createTextMessage:(GotyeOCChatTarget*)sender receiver:(GotyeOCChatTarget*)receiver text:(NSString*)text;

/**
 * @brief 创建图片消息对象
 * @param imagePath:图片路径
 * @param receiver: 接收者
 * @return 消息对象
 */
+(instancetype)createImageMessage:(GotyeOCChatTarget*)receiver imagePath:(NSString*)imagePath;
/**
 * @brief 创建图片消息对象
 * @param sender: 发送者
 * @param receiver: 接收者
 * @param imagePath: 图片路径
 * @return 消息对象
 */
+(instancetype)createImageMessage:(GotyeOCChatTarget*)sender receiver:(GotyeOCChatTarget*)receiver imagePath:(NSString*)imagePath;

/**
 * @brief 创建语音消息对象
 * @param audioPath: 音频路径
 * @param receiver: 接收者
 * @param duration: 持续时间
 * @return 消息对象
 */
+(instancetype)createAudioMessage:(GotyeOCChatTarget*)receiver audioPath:(NSString*)audioPath duration:(unsigned )duration;
/**
 * @brief 创建语音消息对象
 * @param sender: 发送者
 * @param audioPath: 音频路径
 * @param receiver: 接收者
 * @param duration: 持续时间
 * @return 消息对象
 */
+(instancetype)createAudioMessage:(GotyeOCChatTarget*)sender receiver:(GotyeOCChatTarget*)receiver audioPath:(NSString*)audioPath duration:(unsigned )duration;
/**
 * @brief 创建用户自定义数据消息对象
 * @param dataPath: 数据路径
 * @param receiver: 接收者
 * @return 消息对象
 */
+(instancetype)createUserDataMessage:(GotyeOCChatTarget*)receiver dataPath:(NSString*)dataPath;
/**
 * @brief 创建用户自定义数据消息对象
 * @param sender: 发送者
 * @param dataPath: 数据路径
 * @param receiver: 接收者
 * @return 消息对象
 */
+(instancetype)createUserDataMessage:(GotyeOCChatTarget*)sender receiver:(GotyeOCChatTarget*)receiver dataPath:(NSString*)dataPath;
/**
 * @brief 创建用户自定义数据消息对象
 * @param data: 数据指针
 * @param receiver: 接收者
 * @param len: 数据长度
 * @return 消息对象
 */
+(instancetype)createUserDataMessage:(GotyeOCChatTarget*)receiver data:(const void*)data len:(unsigned)len;
/**
 * @brief 创建用户自定义数据消息对象
 * @param sender: 发送者
 * @param data: 数据指针
 * @param receiver: 接收者
 * @param len: 数据长度
 * @return 消息对象
 */
+(instancetype)createUserDataMessage:(GotyeOCChatTarget*)sender receiver:(GotyeOCChatTarget*)receiver data:(const void*)data len:(unsigned)len;

/**
 * @brief 添加附加数据
 * @param data: 数据指针
 * @param len: 数据长度
 */
-(void)putExtraData:(const void*) data  len:(unsigned)len;

/**
 * @brief 添加附加数据文件
 * @param extraPath: 数据路径
 */
-(void)putExtraData:(NSString*)extraPath;

@end
