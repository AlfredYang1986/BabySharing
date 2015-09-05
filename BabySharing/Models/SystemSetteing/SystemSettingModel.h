//
//  SystemSettingModel.h
//  BabySharing
//
//  Created by Alfred Yang on 5/09/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class AppDelegate;

@interface SystemSettingModel : NSObject
@property (strong, nonatomic) UIManagedDocument* doc;
//@property (strong, nonatomic) NSArray* querydata;
@property (weak, nonatomic, readonly) AppDelegate* delegate;

#pragma mark -- constractor
- (id)initWithDelegate:(AppDelegate*)app;

#pragma mark -- current version
- (NSString*)getCurrentVersion;

#pragma mark -- query message Setting
- (BOOL)isModeSilenceOn;
- (void)resetModeSilence:(BOOL)isOn;
- (BOOL)isModeVoiceOn;
- (void)resetModeVoice:(BOOL)isOn;
- (BOOL)isModeViberOn;
- (void)resetModeViber:(BOOL)isOn;

- (BOOL)isNotifyCycleOn;
- (void)resetNotifyCycle:(BOOL)isOn;
- (BOOL)isNotifyP2POn;
- (void)resetNotifyP2P:(BOOL)isOn;
- (BOOL)isNotifyNotificationOn;
- (void)resetNotifyNotification:(BOOL)isOn;
- (BOOL)isNotifyDongDaOn;
- (void)resetNotifyDongDa:(BOOL)isOn;
@end
