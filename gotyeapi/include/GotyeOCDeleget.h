//
//  GotyeDelegetOC.h
//  GotyeAPI
//
//  Created by Peter on 14/12/4.
//  Copyright (c) 2014年 Ailiao Technologies. All rights reserved.
//

#ifndef GotyeAPI_GotyeDelegetOC_h
#define GotyeAPI_GotyeDelegetOC_h

#import "GotyeOCChatTarget.h"
#import "GotyeOCMessage.h"
#import "GotyeOCNotify.h"
#import "GotyeOCStatusCode.h"
#import "GotyeOCGroupMsgConfig.h"


/** 监听器,通过接口addListener添加到API里面后可以监听异步回调
 
*/


//todo 1.超链接到GotyeStatusCode
//     2.类描述

@protocol GotyeOCDelegate <NSObject>

@optional
/**
 * @brief 登录回调
 * @param code: 状态id
 * @param user: 当前登录用户
 */
-(void) onLogin:(GotyeStatusCode)code user:(GotyeOCUser*)user;
/**
 * @brief  正在重连回调
 * @param code: 状态id
 * @param user: 当前登录用户
 */
-(void) onReconnecting:(GotyeStatusCode)code user:(GotyeOCUser*)user;
/**
 * @brief  退出登录回调
 * @param code: 状态id
 */
-(void) onLogout:(GotyeStatusCode)code;
/**
 * @brief  获取当前登录用户详细信息回调
 * @param code: 状态id
 * @param user: 当前登录用户
 */
-(void) onGetProfile:(GotyeStatusCode)code user:(GotyeOCUser*)user;

-(void) onStartAPNS:(GotyeStatusCode)code;

-(void) onStopAPNS:(GotyeStatusCode)code;

-(void) onUpdateUnreadMessageCount:(GotyeStatusCode)code;

/**
 * @brief  获得用户详细信息回调
 * @param code: 状态id
 * @param user: 调用getUserDetail时传入的用户对象
 */
-(void) onGetUserDetail:(GotyeStatusCode)code user:(GotyeOCUser*)user;
/**
 * @brief  修改用户详细信息回调
 * @param code: 状态id
 * @param user: 当前登录用户
 */
-(void) onModifyUserInfo:(GotyeStatusCode)code user:(GotyeOCUser*)user;
/**
 * @brief  搜索用户回调
 * @param code: 状态id
 * @param pageIndex: 分页索引
 * @param curPageList: 当前页搜索结果列表
 * @param allList: 累计搜索结果列表
 */
-(void) onSearchUserList:(GotyeStatusCode)code pageIndex:(unsigned)pageIndex curPageList:(NSArray*)curPageList allList:(NSArray*) allList;
/**
 * @brief 获取好友列表回调
 * @param code: 状态id
 * @param friendlist: 最新好友列表
 */
-(void) onGetFriendList:(GotyeStatusCode)code friendlist:(NSArray*)friendlist;
/**
 * @brief 获取黑名单列表回调
 * @param code: 状态id
 * @param blockedlist: 最新黑名单列表
 */
-(void) onGetBlockedList:(GotyeStatusCode)code blockedlist:(NSArray*)blockedlist;
/**
 * @brief 添加好友回调
 * @param code: 状态id
 * @param user: 调用reqAddFriend时传入的用户对象
 */
-(void) onAddFriend:(GotyeStatusCode)code user:(GotyeOCUser*)user;
/**
 * @brief 添加黑名单回调
 * @param code: 状态id
 * @param user: 调用reqAddBlocked时传入的用户对象
 */
-(void) onAddBlocked:(GotyeStatusCode)code user:(GotyeOCUser*)user;
/**
 * @brief 删除好友回调
 * @param code: 状态id
 * @param user: 调用reqRemoveFriend时传入的用户对象
 */
-(void) onRemoveFriend:(GotyeStatusCode)code user:(GotyeOCUser*)user;
/**
 * @brief 移除黑名单回调
 * @param code: 状态id
 * @param user: 调用reqRemoveBlocked时传入的用户对象
 */
-(void) onRemoveBlocked:(GotyeStatusCode)code user:(GotyeOCUser*)user;


/**
 * @brief 获得聊天室回调
 * @param code: 状态id
 * @param pageIndex: 分页索引
 * @param curPageRoomList: 当前页聊天室列表
 * @param allRoomList: 已获取到的全部聊天室列表
 */
-(void) onGetRoomList:(GotyeStatusCode)code pageIndex:(unsigned)pageIndex curPageRoomList:(NSArray*)curPageRoomList allRoomList:(NSArray*)allRoomList;
/**
 * @brief 进入聊天室回调
 * @param code: 状态id
 * @param room: 调用enterRoom时传入的聊天室对象
 */
-(void) onEnterRoom:(GotyeStatusCode)code room:(GotyeOCRoom*)room;
/**
 * @brief 离开聊天室回调
 * @param code: 状态id
 * @param room: 调用leaveRoom时传入的聊天室对象
 */
-(void) onLeaveRoom:(GotyeStatusCode)code room:(GotyeOCRoom*)room;
/**
 * @brief 获取聊天室成员回调
 * @param code: 状态id
 * @param room: 聊天室对象
 * @param pageIndex: 分页索引
 * @param curPageMemberList: 当前页成员列表
 * @param allMemberList: 已获取到的全部成员列表
 */
-(void) onGetRoomMemberList:(GotyeStatusCode)code room:(GotyeOCRoom*)room pageIndex:(unsigned)pageIndex curPageMemberList:(NSArray*)curPageMemberList allMemberList:(NSArray*)allMemberList;

/**
 * @brief 搜索群组结果回调
 * @param code: 状态id
 * @param pageIndex: 分页索引
 * @param curPageList: 当前页搜索结果列表
 * @param allList: 已获取到的全部搜索结果列表
 */
-(void) onSearchGroupList:(GotyeStatusCode)code pageIndex:(unsigned)pageIndex curPageList:(NSArray*) curPageList allList:(NSArray*)allList;
/**
 * @brief 创建群组回调
 * @param code: 状态id
 * @param group: 被创建的新群组对象
 */
-(void) onCreateGroup:(GotyeStatusCode)code group:(GotyeOCGroup*)group;
/**
 * @brief 加入群组回调
 * @param code: 状态id
 * @param group: 群组对象
 */
-(void) onJoinGroup:(GotyeStatusCode)code group:(GotyeOCGroup*)group;
/**
 * @brief 退出群组回调
 * @param code: 状态id
 * @param group: 群组对象
 */
-(void) onLeaveGroup:(GotyeStatusCode)code group:(GotyeOCGroup*)group;
/**
 * @brief 解散群组回调
 * @param code: 状态id
 * @param group: 被解散的群组对象
 */
-(void) onDismissGroup:(GotyeStatusCode)code group:(GotyeOCGroup*)group;
/**
 * @brief 踢出群组成员回调
 * @param code: 状态id
 * @param group: 群组对象
 * @param user: 被踢出群组成员对象
 */
-(void) onKickOutUser:(GotyeStatusCode)code group:(GotyeOCGroup*)group user:(GotyeOCUser*)user;
/**
 * @brief 变更群主回调
 * @param code: 状态id
 * @param group: 群组对象
 * @param user: 新的群主
 */
-(void) onChangeGroupOwner:(GotyeStatusCode)code group:(GotyeOCGroup*)group user:(GotyeOCUser*)user;
/**
 * @brief 获取群租列表回调
 * @param code: 状态id
 * @param grouplist: 最新群组列表
 */
-(void) onGetGroupList:(GotyeStatusCode)code grouplist:(NSArray*)grouplist;
/**
 * @brief 获取群组详情回调
 * @param code: 状态id
 * @param group: 群组对象
 */
-(void) onGetGroupDetail:(GotyeStatusCode)code group:(GotyeOCGroup*)group;
/**
 * @brief 获取群组成员列表回调
 * @param code: 状态id
 * @param group: 群组对象
 * @param pageIndex: 分页索引
 * @param curPageMemberList: 当前页的成员列表
 * @param allMemberList: 所获取到的全部成员列表
 */
-(void) onGetGroupMemberList:(GotyeStatusCode)code group:(GotyeOCGroup*)group pageIndex:(unsigned)pageIndex curPageMemberList:(NSArray*)curPageMemberList allMemberList:(NSArray*)allMemberList;
/**
 * @brief 修改群组详细信息回调
 * @param code: 状态id
 * @param group: 被修改后的群组对象
 */
-(void) onModifyGroupInfo:(GotyeStatusCode)code group:(GotyeOCGroup*)group;
/**
 * @brief 收到通知回调
 * @param notify: 通知对象
 */
-(void) onReceiveNotify:(GotyeOCNotify*)notify;
/**
 * @brief 发送通知回调
 * @param code: 状态id
 * @param notify: 通知
 */
-(void) onSendNotify:(GotyeStatusCode)code notify:(GotyeOCNotify*)notify;

/**
 * @brief 入群通知
 * @param group: 群组对象
 * @param user: 新加入的群组成员
 */
-(void) onUserJoinGroup:(GotyeOCGroup*)group user:(GotyeOCUser*)user;
/**
 * @brief 退群通知
 * @param group: 群组对象
 * @param user: 退出的群组成员
 */
-(void) onUserLeaveGroup:(GotyeOCGroup*)group user:(GotyeOCUser*)user;
/**
 * @brief 群组解散通知
 * @param group: 被解散群组对象
 * @param user: 群主
 */
-(void) onUserDismissGroup:(GotyeOCGroup*)group user:(GotyeOCUser*)user;
/**
 * @brief 群组成员被踢通知
 * @param group: 群组对象
 * @param kicked: 被踢出成员
 * @param actor: 操作发起成员
 */
-(void) onUserKickedFromGroup:(GotyeOCGroup*)group kicked:(GotyeOCUser*)kicked actor:(GotyeOCUser*)actor;
/**
 * @brief 发送消息回调
 * @param code: 状态id
 * @param message: 消息对象
 */
-(void) onSendMessage:(GotyeStatusCode)code message:(GotyeOCMessage*)message;
/**
 * @brief 解码语音消息回调
 * @param code: 状态id
 * @param message: 消息对象
 */
-(void) onDecodeMessage:(GotyeStatusCode)code message:(GotyeOCMessage*)message;
/**
 * @brief 接收消息回调
 * @param message: 接收到的消息对象
 * @param downloadMediaIfNeed: 是否自动下载
 */
-(void) onReceiveMessage:(GotyeOCMessage*)message downloadMediaIfNeed:(bool*)downloadMediaIfNeed;

/**
 * @brief 下载消息回调
 * @param code: 状态id
 * @param message: 消息对象
 */
-(void) onDownloadMediaInMessage:(GotyeStatusCode)code message:(GotyeOCMessage*)message;

/**
 * @brief 获取历史/离线消息回调
 * @param code: 状态id
 * @param msglist: 消息列表
 * @param downloadMediaIfNeed: 是否需要下载
 */
-(void) onGetMessageList:(GotyeStatusCode)code msglist:(NSArray *)msgList downloadMediaIfNeed:(bool*)downloadMediaIfNeed;

-(void) onGetOfflineMessageList:(GotyeStatusCode)code msglist:(NSArray *)msgList downloadMediaIfNeed:(bool*)downloadMediaIfNeed;

-(void) onGetHistoryMessageList:(GotyeStatusCode)code msglist:(NSArray *)msgList downloadMediaIfNeed:(bool*)downloadMediaIfNeed;

/**
 * @brief 举报回调
 * @param code: 状态id
 * @param msglist: 消息对象
 */
-(void) onReport:(GotyeStatusCode)code message:(GotyeOCMessage*)message;
/**
 * @brief 开始录制语音消息回调
 * @param code: 状态id
 * @param target: 聊天对象
 * @param realtime: 是否实时语音
 */
-(void) onStartTalk:(GotyeStatusCode)code target:(GotyeOCChatTarget*)target realtime:(bool)realtime;
/**
 * @brief 结束录制语音消息回调
 * @param code: 状态id
 * @param cancelSending: 是否取消自动发送
 * @param realtime: 是否实时语音
 * @param message: 新生成的语音消息对象(当为实时语音时该参数无效)
 */
-(void) onStopTalk:(GotyeStatusCode)code realtime:(bool)realtime message:(GotyeOCMessage*)message cancelSending:(bool*)cancelSending;
/**
 * @brief 下载头像回调
 * @param code: 状态id
 * @param media: 头像信息
 */
-(void) onDownloadMedia:(GotyeStatusCode)code media:(GotyeOCMedia*)media;

/**
 * @brief 语音消息播放开始回调
 * @param code: 状态id
 * @param message: 消息对象
 */
-(void) onPlayStart:(GotyeStatusCode)code message:(GotyeOCMessage*)message;
/**
 * @brief 实时语音播放开始回调
 * @param speaker: 谁正在发起实时语音
 * @param room: 聊天室对象
 * @param code: 状态id
 */
-(void) onRealPlayStart:(GotyeStatusCode)code speaker:(GotyeOCUser*)speaker room:(GotyeOCRoom*)room;
/**
 * @brief 正在播放回调
 * @param position: 当前播放的位置(单位:毫秒)
 */
-(void) onPlaying:(long)position;
/**
 * @brief 播放停止回调
 */
-(void) onPlayStop;

/**
 *  设置群消息提醒设置的回调
 *
 *  @param code   设置的状态码
 *  @param group  设置的群组
 *  @param config 设置的群消息提醒设置
 */
-(void) onSetGroupMsgConfig:(GotyeStatusCode)code group:(GotyeOCGroup *)group config:(GotyeGroupMsgConfig)config;

/**
 *  获取群消息提醒设置的回调
 *
 *  @param code   获取的状态码
 *  @param group  获取的群组
 *  @param config 获取到的群消息提醒设置
 */
-(void) onGetGroupMsgConfig:(GotyeStatusCode)code group:(GotyeOCGroup *)group config:(GotyeGroupMsgConfig)config;

@end

#endif
