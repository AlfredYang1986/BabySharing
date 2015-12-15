//
//  AppDelegate.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 16/12/2014.
//  Copyright (c) 2014 YY. All rights reserved.
//

#import "AppDelegate.h"
#import "RemoteInstance/RemoteInstance.h"
#import "ModelDefines.h"
#import "Reachability.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize lm = _lm;
@synthesize pm = _pm;
@synthesize qm = _qm;
//@synthesize gm = _gm;
@synthesize mm = _mm;

@synthesize tm = _tm;
@synthesize om = _om;
@synthesize cqm = _cqm;

@synthesize cm = _cm;
@synthesize sm = _sm;

@synthesize fm = _fm;
@synthesize um = _um;

@synthesize apns_token = _apns_token;

@synthesize reachability = _reachability;

- (void)createQueryModel {
    if (!_qm) _qm = [[QueryModel alloc]initWithDelegate:self];
    if (!_tm) _tm = [[TagQueryModel alloc]initWithDelegate:self];
    if (!_om) _om = [[OwnerQueryModel alloc]initWithDelegate:self];
    if (!_cm) _cm = [[ConnectionModel alloc]initWithDelegate:self];
    if (!_cqm) _cqm = [[CollectionQueryModel alloc]initWithDelegate:self];
    if (!_sm) _sm = [[SystemSettingModel alloc]initWithDelegate:self];
    
    [self createSearchModel];
}

- (void)createSearchModel {
    if (!_fm) _fm = [[FoundSearchModel alloc]initWithDelegate:self];
    if (!_um) _um = [[UserSearchModel alloc]initWithDelegate:self];
}

- (void)createMessageAndNotificationModel {
//    if (!_gm) _gm = [[GroupModel alloc]initWithDelegate:self];
    if (!_mm) _mm = [[MessageModel alloc]initWithDelegate:self];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    _lm  = [[LoginModel alloc] init];
    _pm  = [[PostModel alloc] init];

    /**
     * Notification
     */
    //1.创建消息上面要添加的动作(按钮的形式显示出来)
    UIMutableUserNotificationAction *action = [[UIMutableUserNotificationAction alloc] init];
    action.identifier = @"action";//按钮的标示
    action.title=@"Accept";//按钮的标题
    action.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
    //    action.authenticationRequired = YES;
    //    action.destructive = YES;
    
    UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];
    action2.identifier = @"action2";
    action2.title=@"Reject";
    action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
    action.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
    action.destructive = YES;
    
    //2.创建动作(按钮)的类别集合
    UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
    categorys.identifier = @"alert";//这组动作的唯一标示,推送通知的时候也是根据这个来区分
    [categorys setActions:@[action,action2] forContext:(UIUserNotificationActionContextMinimal)];
    
    //3.创建UIUserNotificationSettings，并设置消息的显示类类型
    UIUserNotificationSettings *notiSettings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound) categories:[NSSet setWithObjects:categorys, nil]];
    [[UIApplication sharedApplication] registerUserNotificationSettings:notiSettings];
   
    status im_register_result = [GotyeOCAPI init:@"1afd2cc8-4060-41eb-aa5a-ee9460370156" packageName:@"DongDa"];
    if (im_register_result != GotyeStatusCodeOK) {
        NSLog(@"IM Register Error!");
    } else {
        NSLog(@"IM Register Success!");
    }
    
    /**
     * reach ability
     */
    _reachability = [Reachability reachabilityForInternetConnection];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [_qm saveTop:50];
    [_lm.doc.managedObjectContext save:nil];
    [_mm save];
    if (_reachability) {
        [_reachability stopNotifier];
    }
    [_lm offlineCurrentUser];
    NSLog(@"save content");
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if (_reachability) {
        [_reachability startNotifier];
    }
    [_lm onlineCurrentUser];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [_qm saveTop:50];
    [_lm.doc.managedObjectContext save:nil];
    [_mm save];
    NSLog(@"save content in termination");
    [_lm offlineCurrentUser];
    [GotyeOCAPI exit];
}

#pragma mark -- notification callback
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    //    UIUserNotificationSettings *settings = [application currentUserNotificationSettings];
    //    UIUserNotificationType types = [settings types];
    //    //只有5跟7的时候包含了 UIUserNotificationTypeBadge
    //    if (types == 5 || types == 7) {
    //        application.applicationIconBadgeNumber = 0;
    //    }
    //注册远程通知
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken {
    _apns_token = [NSString stringWithFormat:@"%@",(NSString*)deviceToken];
    _apns_token = [_apns_token stringByReplacingOccurrencesOfString:@" " withString:@""];
    _apns_token = [_apns_token lowercaseString];
    _apns_token = [_apns_token substringToIndex:_apns_token.length-1];
    _apns_token = [_apns_token substringFromIndex:1];
    NSLog(@"My token is: %@", _apns_token);

    [self registerDeviceTokenWithCurrentUser];
    NSString* certName = @"DongDaDeveloper";
    [GotyeOCAPI registerAPNS:_apns_token certName:certName];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error {
    NSLog(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"didReceiveRemoteNotification : %@", userInfo);
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark -- register device to service
- (void)registerDeviceTokenWithCurrentUser {
    if (_apns_token == nil || _lm.current_user_id == nil) {
        return;
    }
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:_lm.current_user_id forKey:@"user_id"];
    [dic setValue:_lm.current_auth_token forKey:@"auth_token"];
    [dic setValue:_apns_token forKey:@"device_token"];
    
    NSError * error = nil;
    NSData* jsonData =[NSJSONSerialization dataWithJSONObject:[dic copy] options:NSJSONWritingPrettyPrinted error:&error];
    
    NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:DEVICE_REGISTRATION]];
    
    if ([[result objectForKey:@"status"] isEqualToString:@"ok"]) {
        NSLog(@"register device success");
        _lm.apns_token = _apns_token;
    } else {
        NSLog(@"register device failed");
    }
}



- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSLog(@"url is : %@", url);
    NSLog(@"source Application : %@", sourceApplication);
    if ([sourceApplication isEqualToString:@"com.sina.weibo"]) {
        return [WeiboSDK handleOpenURL:url delegate:_lm];
    } else {
        return [TencentOAuth HandleOpenURL:url];
    }
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    if ([_lm isCurrentUserConnectWithWeibo]) return [WeiboSDK handleOpenURL:url delegate:_lm];
    else return [TencentOAuth HandleOpenURL:url];
}
@end
