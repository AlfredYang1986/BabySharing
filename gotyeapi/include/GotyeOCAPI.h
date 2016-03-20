//
//  GotyeOCAPI.h
//  GotyeAPI
//
//  Created by Peter on 14/12/4.
//  Copyright (c) 2014年 Ailiao Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GotyeOCMessage.h"
#import "GotyeOCNotify.h"
#import "GotyeOCChatTarget.h"
#import "GotyeOCDeleget.h"
#import "GotyeOCGroupMsgConfig.h"

/** GotyeAPI接口集合封装类
 
 */
@interface GotyeOCAPI : NSObject




/**
 * @brief使用appKey和包名称 初始化API
 * @param appKey: 您在gotye管理系统注册生成的appKey
 * @param packageName: 应用程序包名
 * @return 状态 是否成功
 */
+(status)init:(NSString*)appKey packageName:(NSString*)packageName;

/**
 * @brief 初始化讯飞语音识别API
 */
+(void)initIflySpeechRecognition;


/**
 * @brief 终止API内部所有的子线程，同时销毁API所有模块组件, 注意只能在应用程序退出时才能调用
 */
+(void)exit;

/**
 * @brief 注册push服务,仅ios平台
 * @param deviceToken: 设备Token
 * @param certName: 证书名
 * @return 状态 是否成功
 */
+(bool)registerAPNS:(NSString*)deviceToken certName:(NSString*)certName;

/**
 * @brief 启用/禁用苹果推送服务
 * @param enabled: 是否开启推送服务
 * @return 状态 是否成功
 */
+(bool)enableAPNS:(bool)enabled;

/**
 * @brief 更新保存在亲加服务器中的未读消息数。
 * @param count: 未读消息条数
 */
+(void)updateUnreadMessageCount:(int)count;

/**
 * @brief 清除缓存（包括头像、缩略图、原始图片、音频，不包括历史消息记录）
 */
+(status)clearCache;

/**
 * @brief 注册/删除异步回调
 */
+(status)removeAllListeners;

/**
 * @brief 添加监听器，用于接收异步回调
 * @param listener: 要添加的监听器
 */
+(status)addListener:(id<GotyeOCDelegate>)listener;

/**
 * @brief 删除监听器，停止接收异步回调
 * @param listener: 要添加的监听器
 */
+(status)removeListener:(id<GotyeOCDelegate>)listener;

/**
 * @brief 使用指定的账号和密码登录服务器
 * @param username: 账号
 * @param password: 密码 如果没有密码传nil
 * @return GotyeStatusCodeWaitingCallback 回调 如果成功，结果将通过异步回调
 * @see callback: GotyeDelegate::onLogin
 */
+(status)login:(NSString*)username password:(NSString*)password;

/**
 * @brief 获取在线状态.
 * @return 参考 {NETSTATE_OFFLINE NETSTATE_BELOWLINE NETSTATE_ONLINE}
 */
+(int)isOnline;

/**
 * @brief 获取登录账号的详细信息
 * @return 详细信息
 */
+(GotyeOCUser*)getLoginUser;

/**
 * @brief 请求修改当前登录帐户的详细信息
 * @param user: 待修改的账号详细信息
 * @param imagePath: 新头像的文件完整路径,如果不修改传nil
 * @return 是否成功
 * @see callback: GotyeDelegate::onModifyUserInfo
 */
+(status)reqModifyUserInfo:(GotyeOCUser*)user imagePath:(NSString*)imagePath;

/**
 * @brief 退出登录
 * @return 是否成功
 * @see callback: GotyeDelegate::onLogout
 */
+(status)logout;

/**
 * @brief 重置用户搜索，将清除上次本地保存的用户搜索结果总列表和分页列表
 */
+(void)resetUserSearch;

/**
 * @brief 获取本地缓存用户搜索列表
 * @return 本地用户搜索列表
 */
+(NSArray*)getLocalUserSearchList;

/**
 * @brief 获取本地缓存当前页用户搜索列表
 * @return 当前页用户列表
 */
+(NSArray*)getLocalUserSearchCurPageList;

/**
 * @brief 根据指定用户名、昵称、性别搜索用户
 * @param pageIndex: 指定分页索引(每页固定16个用户)
 * @param username: 用户名，如果忽略传""
 * @param nickname: 昵称，如果忽略传""
 * @param gender: 性别，如果忽略传SEX_IGNORE
 * @return 是否成功
 * @see callback: GotyeDelegate::onSearchUserList
 */
+(status)reqSearchUserList:(unsigned)pageIndex username:(NSString*)username nickname:(NSString*)nickname gender:(GotyeUserGender)gender;

/**
 * @brief 根据指定聊天对象的基础信息,获取用户详细信息
 * @param target: 聊天对象
 * @param forceRequest: 该参数为true时先返回本地缓存数据，并从服务器获取最新数据通过回调返回；若为false，当存在本地缓存时只返回缓存数据， 若不存在则去服务器请求并通过回调返回
 * @return 用户详细信息
 * @see callback: GotyeDelegate::onGetUserDetail
 */
+(GotyeOCUser*)getUserDetail:(GotyeOCChatTarget*)target forceRequest:(bool)forceRequest;

/**
 * @brief 获取本地好友列表
 * @return 好友列表
 */
+(NSArray*)getLocalFriendList;

/**
 * @brief 获取本地黑名单列表
 * @return 黑名单列表
 */
+(NSArray*)getLocalBlockedList;

/**
 * @brief 向服务器请求好友列表,获取成功后本地好友列表也将被同步更新
 * @return 是否成功
 * @see callback: GotyeDelegate::onGetFriendList
 */
+(status)reqFriendList;

/**
 * @brief 向服务器请求黑名单列表,获取成功后本地黑名单列表也将被同步更新
 * @return 是否成功
 * @see callback: GotyeDelegate::onGetBlockedList
 */
+(status)reqBlockedList;

/**
 * @brief 请求添加指定用户为好友
 * @param who: 指定用户
 * @return 是否成功
 * @see callback: GotyeDelegate::onAddFriend
 */
+(status)reqAddFriend:(GotyeOCUser*)who;

/**
 * @brief 请求添加指定用户到黑名单
 * @param who: 指定用户
 * @return 是否成功
 * @see callback: GotyeDelegate::onAddBlocked
 */
+(status)reqAddBlocked:(GotyeOCUser*)who;

/**
 * @brief 请求删除指定好友
 * @param who: 指定好友
 * @return 是否成功
 * @see callback: GotyeDelegate::onRemoveFriend
 */
+(status)reqRemoveFriend:(GotyeOCUser*)who;

/**
 * @brief 请求从黑名单表中移除指定用户
 * @param who: 指定用户
 * @return 是否成功
 * @see callback: GotyeDelegate::onRemoveBlocked
 */
+(status)reqRemoveBlocked:(GotyeOCUser*)who;

/**
 * @brief 向服务器请求聊天室列表
 * @param pageIndex: 分页索引
 * @return 是否成功
 * @see callback: GotyeDelegate::onGetRoomList
 */
+(status)reqRoomList:(unsigned)pageIndex;

/**
 * @brief 获取本地聊天室列表
 * @return 聊天室列表
 */
+(NSArray*)getLocalRoomList;

/**
 * @brief 清空本地聊天室列表
 */
+(void)clearLocalRoomList;

/**
 * @brief 获取聊天室详细信息
 * @param target: 聊天室对象
 * @return 聊天室详细信息
 */
+(GotyeOCRoom*)getRoomDetail:(GotyeOCChatTarget*)target;

/**
 * @brief 判断是否已经进入指定的聊天室
 * @param room: 聊天室对象
 * @return true表示在房间中，false表示不在
 */
+(bool)isInRoom:(GotyeOCRoom*)room;

/**
 * @brief 请求进入指定的聊天室
 * @param room: 聊天室
 * @return 是否成功
 * @see callback: GotyeDelegate::onEnterRoom
 */
+(status)enterRoom:(GotyeOCRoom*)room;

/**
 * @brief 请求离开指定聊天室
 * @param room: 聊天室
 * @return 是否成功
 * @see callback: GotyeDelegate::onLeaveRoom
 */
+(status)leaveRoom:(GotyeOCRoom*)room;

/**
 * @brief 判断指定聊天室是否支持实时语音
 * @param room: 聊天室
 * @return 是否成功
 */
+(bool)supportRealtime:(GotyeOCChatTarget*)target;

/**
 * @brief 获取指定聊天室的成员列表
 * @param room: 聊天室
 * @param pageIndex: 分页索引
 * @return 是否成功
 * @see callback: GotyeDelegate::onGetRoomUserList
 */
+(status)reqRoomMemberList:(GotyeOCRoom*)room pageIndex:(unsigned)pageIndex;

/**
 * @brief 重置群组搜索 将清除上次本地保存的群组搜索结果总列表和分页列表
 */
+(void)resetGroupSearch;

/**
 * @brief 获取本地缓存群组搜索列表
 * @return 群组列表
 */
+(NSArray*)getLocalGroupSearchList;
/**
 * @brief 获取本地缓存当前页群组搜索列表
 * @return 当前页群组列表
 */
+(NSArray*)getLocalGroupSearchCurPageList;

/**
 * @brief 搜索包含指定名字的群组列表
 * @param groupname: 群组名字
 * @param pageIndex: 分页索引
 * @return 状态
 */
+(status)reqSearchGroup:(NSString*)groupname pageIndex:(unsigned)pageIndex;

/**
 * @brief 根据指定聊天对象的基础信息,获取群组详细信息
 * @param target: 群组对象
 * @param forceRequest: 该参数为true时先返回本地缓存数据，并从服务器获取最新数据通过回调返回；若为false，当存在本地缓存时只返回缓存数据， 若不存在则去服务器请求并通过回调返回
 * @return 群组详细信息
 * @see callback: GotyeDelegate::onGetGroupDetail
 */
+(GotyeOCGroup*)getGroupDetail:(GotyeOCChatTarget*)target forceRequest:(bool)forceRequest;

/**
 *  @brief 获取群组消息提醒设置
 *
 *  @param target       群组对象
 *  @param forceRequest 该参数为true时先返回本地设置，并从服务器获取最新数据通过回调返回；若为false，则直接返回本地的设置
 *
 *  @return 群组的消息提醒设置
 */
+(int)getChatTargetMsgConfig:(GotyeOCChatTarget *)target forceRequest:(bool)forceRequest;

/**
 *  设置群组消息提醒设置
 *
 *  @param target 群组对象
 *  @param config 群组消息提醒设置。具体的值请参照GotyeGroupMsgConfig
 *  @see GotyeGroupMsgConfig
 *  @return 是否成功
 */
+(status)setChatTarget:(GotyeOCChatTarget *)target msgConfig:(int)config;

/**
 * @brief 根据指定的群组信息创建群组
 * @param group: 群组信息
 * @return 是否成功
 * @see callback: GotyeDelegate::onCreateGroup
 */
+(status)createGroup:(GotyeOCGroup*)group;

/**
 * @brief 加入指定群组
 * @param group: 群组对象
 * @return 是否成功
 * @see callback: GotyeDelegate::onJoinGroup
 */
+(status)joinGroup:(GotyeOCGroup*)group;

/**
 * @brief 退出指定群组
 * @param group: 群组对象
 * @return 是否成功
 * @see callback: GotyeDelegate::onLeaveGroup
 */
+(status)leaveGroup:(GotyeOCGroup*)group;

/**
 * @brief 解散指定群组,需要拥有群主权限
 * @param group: 群组对象
 * @return 是否成功
 * @see callback: GotyeDelegate::onDismissGroup
 */
+(status)dismissGroup:(GotyeOCGroup*)group;

/**
 * @brief 踢出指定群组里面的指定成员
 * @param group: 群组对象
 * @param user: 成员对象
 * @return 是否成功
 * @see callback: GotyeDelegate::onKickoutGroupMember
 */
+(status)kickoutGroupMember:(GotyeOCGroup*)group user:(GotyeOCUser*)user;

/**
 * @brief 请求修改指定群组的群主
 * @param group: 群组对象
 * @param user: 新群主
 * @return 是否成功
 * @see callback: GotyeDelegate::onChangeGroupOwner
 */
+(status)changeGroupOwner:(GotyeOCGroup*)group user:(GotyeOCUser*)user;

/**
 * @brief 获取本地缓存群组列表
 * @return 群租列表
 */
+(NSArray*)getLocalGroupList;

/**
 * @brief 向服务器请求和自己相关联的群组列表
 * @see callback: GotyeDelegate::onGetGroupList
 */
+(status)reqGroupList;

/**
 * @brief 请求修改指定群组的详细信息
 * @param group: 群组对象
 * @param imagePath: 群组头像文件完整路径,如果不修改头像传nil
 * @see callback: GotyeDelegate::onModifyGroupInfo
 */
+(status)reqModifyGroupInfo:(GotyeOCGroup*)group imagePath:(NSString*)imagePath;

/**
 * @brief 请求获取指定群组的成员列表
 * @param group: 群组对象
 * @param pageIndex: 分页索引
 * @return 是否成功
 * @see callback: GotyeDelegate::onGetGroupMemberList
 */
+(status)reqGroupMemberList:(GotyeOCGroup*)group pageIndex:(unsigned)pageIndex;

/**
 * @brief 邀请指定用户加入指定群组
 * @param username: 被邀请用户对象
 * @param group: 群组对象
 * @param inviteMessage: 邀请信息
 * @return 是否成功
 * @see callback: GotyeDelegate::onReceiveNotify when receive other's invite
 */
+(status)inviteUserToGroup:(GotyeOCUser*)user group:(GotyeOCGroup*)group inviteMessage:(NSString*)inviteMessage;

/**
 * @brief 请求加入指定群组
 * @param group: 群组对象
 * @param applyMessage: 请求附加信息
 * @return 是否成功
 * @see callback: GotyeDelegate::onReceiveNotify when receive other's apply
 */
+(status)reqJoinGroup:(GotyeOCGroup*)group applyMessage:(NSString*)applyMessage;

/**
 * @brief 回复指定入群申请
 * @param applyNotify: 入群申请
 * @param respMessage: 回复信息
 * @param agree: 是否同意入群
 * @return 是否成功
 * @see callback: GotyeDelegate::onReceiveNotify when receive response of your apply
 */
+(status)replyJoinGroup:(GotyeOCNotify*)applyNotify respMessage:(NSString*)respMessage agree:(bool)agree;

/**
 * @brief 获取本地会话列表（最近联系人列表),该列表不上传服务器
 * @return 会话列表
 */
+(NSArray*)getSessionList;

/**
 * @brief 激活和指定聊天对象的会话，这样会话中接收到的消息将被自动标记为已读
 * @param target: 指定的聊天对象
 */
+(void)activeSession:(GotyeOCChatTarget*)target;

/**
 * @brief 取消激活和指定聊天对象的会话
 * @param target: 聊天对象
 */
+(void)deactiveSession:(GotyeOCChatTarget*)target;

/**
 * @brief 删除和指定聊天对象的会话
 * @param target: 聊天对象
 * @param remove: 是否同时删除关联消息
 */
+(void)deleteSession:(GotyeOCChatTarget*)target alsoRemoveMessages:(BOOL)remove;

/**
 * @brief 将和指定聊天对象的会话置顶/取消置顶
 * @param target: 聊天对象
 * @param isTop: 是否置顶
 */
+(void)markSessionIsTop:(GotyeOCChatTarget*)target :(bool)isTop;

/**
 * @brief 获取会话信息
 * @param target: 会话对象
 * @param messageList: 获取消息列表
 * @param memberList: 会话成员
 * @param curPageMemberList: 当前页的成员
 * @param pageIndex: 当前索引
 * @return 是否成功
 */
+(bool)getSessionInfo:(GotyeOCChatTarget*)target messageList:(NSMutableArray*)messageList memberList:(NSMutableArray*)memberList curPageMemberList:(NSMutableArray*)curPageMemberList  pageIndex:(unsigned*)pageIndex;

/**
 * @brief 获取通知列表
 * @return 通知列表
 */
+(NSArray*)getNotifyList;

/**
 * @brief 将指定通知标记为已读/未读
 * @param isRead: 是否已读
 */
+(bool)markNotifyIsRead:(GotyeOCNotify*)notify isRead:(bool)isRead;

/**
 * @brief 将未读通知数目置零
 */
+(void)clearNotifyUnreadStatus;

/**
 * @brief 删除指定通知列表
 * @param notifys: 通知列表
 */
+(void)deleteNotifys:(NSArray*)notifys;

/**
 * @brief 删除指定通知
 * @param notify: 通知对象
 */
+(void)deleteNotify:(GotyeOCNotify*)notify;

/**
 * @brief 获取未读通知数目
 * @return 未读通知数目
 */
+(int)getUnreadNotifyCount;



/**
 * @brief 启动/关闭指定聊天对象类型中的敏感词过滤功能
 * @param enabled: 是否启动
 * @param type: 类型对象
 */
+(void)enableTextFilter:(bool)enabled inType:(GotyeChatTargetType)type;

/**
 * @brief 设置每次调用getMessageList从本地数据库获取消息数目的增量
 * @param increment:增量值 默认值10
 */
+(void)setMessageReadIncrement:(unsigned)increment;

/**
 * @brief 设置每次调用getMessageList从服务器获取消息数目的增量
 * @param increment:增量值 默认值10
 */
+(void)setMessageRequestIncrement:(unsigned)increment;

/**
 * @brief 开始接收离线消息
 */
+(void)beginReceiveOfflineMessage;

/**
 *  开始接收客服离线消息
 */
+ (void)beginReceiveCSOfflineMessage;

/**
 * @brief 获取和指定聊天对象的本地消息列表(针对聊天室会向服务器请求历史消息)
 * @param target: 聊天对象
 * @param more: 是否获取更多
 * @return 消息列表
 */
+(NSArray *)getMessageList:(GotyeOCChatTarget *)target more:(bool)more;

/**
 * @brief 将和指定聊天对象的全部消息置为已读/未读
 * @param target: 聊天对象
 * @param isRead: 是否已读
 */
+(void)markMessagesAsRead:(GotyeOCChatTarget*)target isRead:(bool)isRead;

/**
 * @brief 将指定消息置为已读/未读
 * @param message: 消息
 * @param isRead: 是否已读
 * @return 操作是否成功
 */
+(bool)markOneMessageAsRead:(GotyeOCMessage*)message isRead:(bool)isRead;

/**
 * @brief 批量删除和指定聊天对象的消息
 * @param target: 聊体对象
 * @param msglist: 消息队列
 */
+(void)deleteMessages:(GotyeOCChatTarget*)target msglist:(NSArray*)msglist;

/**
 * @brief 删除指定消息
 * @param target: 聊天对象
 * @param msg: 消息
 */
+(void)deleteMessage:(GotyeOCChatTarget*)target msg:(GotyeOCMessage*)msg;

/**
 * @brief 清空和指定对象的所有消息
 * @param target: 聊天对象
 */
+(void)clearMessages:(GotyeOCChatTarget*)target;

/**
 * @brief 获取和指定聊天对象的未读消息数目
 * @param target: 聊天对象
 * @return 未读消息数目
 */
+(int)getUnreadMessageCount:(GotyeOCChatTarget*)target;

/**
 * @brief 获取总未读消息数目
 * @return 总未读消息数目
 */
+(int)getTotalUnreadMessageCount;

/**
 * @brief 获得指定聊天对象类型下未读消息的数目
 * @param types: 类型数组 (GotyeChatTargetTypeUser/GotyeChatTargetTypeRoom/GotyeChatTargetTypeGroup)
 * @return 未读消息数目
 */
+(int)getUnreadMessageCountOfTypes:(NSArray*)types;

/**
 * @brief 获取和指定聊天对象的最新一条消息
 * @param target: 聊天对象
 * @return 消息
 */
+(GotyeOCMessage*)getLastMessage:(GotyeOCChatTarget*)target;

/**
 * @brief 发送指定消息
 * @param message: 消息
 * @return 是否成功
 * @see callback: GotyeDelegate::onSendMessage
 */
+(status)sendMessage:(GotyeOCMessage*)message;

/**
 * @brief 下载指定语音/图片消息
 * @param message: 消息对象
 * @return 是否成功
 * @see callback: GotyeDelegate::onDownloadMediaInMessage
 */
+(status)downloadMediaInMessage:(GotyeOCMessage*)message;

/**
 * @brief 解码指定的语音消息
 * @param message: 消息对象
 * @return 是否成功
 * @see callback: GotyeDelegate::onDecodeMessage
 */
+(status)decodeAudioMessage:(GotyeOCMessage*)message;

/**
 * @brief 举报消息
 * @param type: 在gm后台定义的举报类型
 * @param content: 举报的文本
 * @param message: 举报的内容
 * @return 是否成功
 * @see callback: GotyeDelegate::onReport
 */
+(status)report:(int)type content:(NSString*)content message:(GotyeOCMessage*)message;

/**
 * @brief 播放语音消息
 * @return 返回是否成功
 * @see callback: GotyeDelegate::onPlayStart, GotyeDelegate::onPlaying, GotyeDelegate::onPlayStop
 */
+(status)playMessage:(GotyeOCMessage*)message;

/**
 * @brief 停止语音播放
 * @return GotyeStatusCodeOK if succeeded.
 */
+(status)stopPlay;

/**
 * @brief 下载用户/聊天室/群组头像
 * @param media: 媒体对象
 * @return 是否成功
 * @see callback: GotyeDelegate::onDownloadMedia
 */
+(status)downloadMedia:(GotyeOCMedia*)media;

/**
 * @brief 设定是否允许录制少于1秒的语音
 * @param enabled: 是否允许
 */
+(void)enableShortRecording:(bool)enabled;

/**
 * @brief 开始录制语音消息/请求发送实时语音
 * @param target: 聊天对象
 * @param mode: 变声模式
 * @param realtime: 是否实时语音
 * @param maxDuration: 最大录音时长(单位:毫秒)
 * @return 是否成功
 * @see callback: GotyeDelegate::onStartTalk
 */
+(status)startTalk:(GotyeOCChatTarget*)target mode:(GotyeWhineMode)mode realtime:(bool)realtime maxDuration:(unsigned)maxDuration;

/**
 * @brief 停止录音
 * @return 是否成功
 * @see callback: GotyeDelegate::onStopTalk
 */
+(status)stopTalk;

/**
 * @brief 获取录音时的实时声音大小
 * @return  声音大小，取值范围[0，255]
 */
+(int)getTalkingPower;

/**
 * @brief 获取版本号
 * @return 版本号
 */
+(NSString*)getVersion;

@end
