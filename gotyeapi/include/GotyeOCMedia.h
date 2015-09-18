//
//  GotyeOCMedia.h
//  GotyeAPI
//
//  Created by Peter on 14/12/3.
//  Copyright (c) 2014年 Ailiao Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    GotyeMediaTypeImage = 1,    ///< 图片
    GotyeMediaTypeAudio,        ///< 语音
    GotyeMediaTypeUserData,     ///< 用户数据
    GotyeMediaTypeExtraData     ///< 额外数据
}GotyeMediaType;                ///< 媒体类型枚举

typedef enum
{
    GotyeMediaStatusCreated,            ///< 创建
    GotyeMediaStatusDownloading,        ///< 正在下载
    GotyeMediaStatusDownloaded,         ///< 下载完成
    GotyeMediaStatusDownloadFailed      ///< 下载失败
}GotyeMediaStatus;

/** 多媒体对象
 
 */
@interface GotyeOCMedia : NSObject


@property(nonatomic, assign) long long tag;             ///< 标签
@property(nonatomic, assign) GotyeMediaType type;       ///< 媒体类型
@property(nonatomic, assign) GotyeMediaStatus status;   ///< 媒体状态

@property(nonatomic, copy) NSString* url;               ///< 服务器存储地址
@property(nonatomic, copy) NSString* path;              ///< 保存头像/缩略图/语音/自定义数据/消息附加字段文件完整路径
@property(nonatomic, copy) NSString* pathEx;            ///< 保存原始大图/PCM音频文件完整路径

@property(nonatomic, assign) unsigned duration;         ///< 语音消息时长(单位:毫秒)
@end
