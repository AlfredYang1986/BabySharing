/****************************************************************************
 Copyright(c) 2013-2014, Shanghai AiLiao Information Technology Co.,Ltd

 http://www.gotye.com.cn
 
 @author:	liugan
 @date:		2014-06-20
 @version:	v3.0
 @filename:	GotyeStatusCode.h
 @description:
 This header file inlcudes gotye status codes.
 Include "GotyeAPI.h" instead of this.
****************************************************************************/

#define NETSTATE_OFFLINE        -1  ///< 离线状态，这种状态下API会自动重连
#define NETSTATE_BELOWLINE       0  ///< 未登录
#define NETSTATE_ONLINE          1  ///< 在线

#define SEX_IGNORE              -1   ///< 忽略性别


typedef enum
{
    GotyeStatusCodeWaitingCallback          = -1,   ///< 异步调用成功
	GotyeStatusCodeOK                       = 0,    ///< 调用成功
    GotyeStatusCodeSystemBusy               = 1,    ///< 系统忙
    GotyeStatusCodeNotLoginYet              = 2,    ///< 尚未登录
    GotyeStatusCodeCreateFileFailed         = 3,    ///< 创建文件失败
    GotyeStatusCodeTargetIsSelf             = 4,    ///< 目标自己
    GotyeStatusCodeReloginOK                = 5,    ///< 重新登录成功
    GotyeStatusCodeOfflineLoginOK           = 6,    ///< 离线登录成功
    GotyeStatusCodeTimeout                  = 300,  ///< 超时
	GotyeStatusCodeVerifyFailed             = 400,  ///< 验证失败
    GotyeStatusCodeNoPermission             = 401,  ///< 没有权限
    GotyeStatusCodeRepeatOper               = 402,  ///< 重复操作
    GotyeStatusCodeGroupNotFound            = 403,  ///< 群组不存在
    GotyeStatusCodeUserNotFound             = 404,  ///< 用户不存在
    GotyeStatusCodeLoginFailed              = 500,  ///< 登录失败
	GotyeStatusCodeForceLogout              = 600,  ///< 强制登出(被其他设备同一账号踢下线)
	GotyeStatusCodeNetworkDisConnected      = 700,  ///< 网络异常断开
    GotyeStatusCodeRoomNotExist             = 33,   ///< 聊天室不存在
    GotyeStatusCodeRoomIsFull               = 34,   ///< 聊天室人数已满
    GotyeStatusCodeNotInRoom                = 35,   ///< 不在聊天室
    GotyeStatusCodeForbidden                = 36,   ///< 禁止
    GotyeStatusCodeAlreadyInRoom            = 39,   ///< 已经在聊天室中
    GotyeStatusCodeUserNotExist             = 804,  ///< 用户不存在
    GotyeStatusCodeBlackList                = 805,  ///< 被列入黑名单
    GotyeStatusCodeRequestMicFailed         = 806,  ///< 请求麦克风失败
    GotyeStatusCodeVoiceTimeOver            = 807,  ///< 录音到达最大时长
    GotyeStatusCodeRecorderBusy             = 808,  ///< 录音设备忙
    GotyeStatusCodeVoiceTooShort            = 809,  ///< 录音时间过短
    GotyeStatusCodeNotInGroup               = 810,  ///< 用户不在群组中
    GotyeStatusCodeInvalidArgument          = 1000, ///< 参数无效
    GotyeStatusCodeServerProcessError       = 1001, ///< 服务器错误
    GotyeStatusCodeDBError                  = 1002, ///< 数据库错误
    GotyeStatusCodeUnkonwnError             = 1100  ///< 未知错误
}GotyeStatusCode, status;                           ///< 状态码枚举
