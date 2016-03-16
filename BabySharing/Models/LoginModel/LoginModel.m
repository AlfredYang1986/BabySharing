//
//  LoginModel.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 26/12/2014.
//  Copyright (c) 2014 YY. All rights reserved.
//

#import "LoginModel.h"
#import "RemoteInstance.h"
#import "LoginToken+ContextOpt.h"
#import "RegTmpToken+ContextOpt.h"
#import "Providers+ContextOpt.h"
#import "CurrentToken+ContextOpt.h"
#import "RegCurrentToken+ContextOpt.h"
#import "WeiboSDK.h"
#import "WeiboUser.h"
#import "ModelDefines.h"
#import "TmpFileStorageModel.h"
#import "Reachability.h"
#import "QQApiInterfaceObject.h"
#import "QQApiInterface.h"
#import "Tools.h"
#import "AppDelegate.h"

// weibo sdk
#import "WBHttpRequest+WeiboUser.h"
#import "WBHttpRequest+WeiboShare.h"

// qq sdk
#import "TencentOAuth.h"

@interface LoginModel ()
@property (strong, nonatomic) CurrentToken* current_user;
@property (strong, nonatomic) RegCurrentToken* reg_user;

/**
 * for weibo login
 */
@property (strong, nonatomic) NSString *wbtoken;
@property (strong, nonatomic) NSString *wbCurrentUserID;
@end

@implementation LoginModel {
    /**
     * for qq
     */
    TencentOAuth* qq_oauth;
    NSArray* permissions;
    NSString *wechatopenid;
    NSString *wechattoken;
}

@synthesize doc = _doc;
@synthesize current_user = _current_user;
@synthesize reg_user = _reg_user;

@synthesize apns_token = _apns_token;

@synthesize wbtoken = _wbtoken;
@synthesize wbCurrentUserID = _wbCurrentUserID;

- (void)reloadDataFromLocalDB {
    authorised_users = [LoginToken enumAllLoginUsersWithContext:_doc.managedObjectContext];
}

- (void)enumDataFromLocalDB:(UIManagedDocument*)document {
    dispatch_queue_t aq = dispatch_queue_create("load_data", NULL);
   
    
    dispatch_async(aq, ^(void){
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [document.managedObjectContext performBlock:^(void){
                authorised_users = [LoginToken enumAllLoginUsersWithContext:_doc.managedObjectContext];
                _current_user = [self getCurrentUser];
                
                // Weibo sdk init
                [WeiboSDK enableDebugMode:YES];
                [WeiboSDK registerApp:@"1584832986"];

                // Tencent sdk init
//                 @"1104592420"
//                QQ41DA62FE
                qq_oauth = [[TencentOAuth alloc] initWithAppId:@"1104831230" andDelegate:self];
                qq_oauth.redirectURI = nil;
                permissions =  [NSArray arrayWithObjects:@"get_user_info", @"get_simple_userinfo", @"add_t", nil];
                
//                wx66d179d99c9ba7d6
//                469c1beed3ecaa3a836767a5999beeb1
                [WXApi registerApp:@"wx66d179d99c9ba7d6" withDescription:@"weichat"];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kDongDaNotificationkeyAppReady object:nil];
            }];
        });
    });
}

- (id)init {
    self = [super init];
    /**
     * get authorised user array in the local database
     */
    NSString* docs=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSURL* url =[NSURL fileURLWithPath:[docs stringByAppendingPathComponent:LOCALDB_LOGIN]];
    _doc = (UIManagedDocument*)[[UIManagedDocument alloc] initWithFileURL:url];
    
    if (![[NSFileManager defaultManager]fileExistsAtPath:[url path] isDirectory:NO]) {
        [_doc saveToURL:url forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success){
            [self enumDataFromLocalDB:_doc];
        }];
    } else if (_doc.documentState == UIDocumentStateClosed) {
        [_doc openWithCompletionHandler:^(BOOL success){
            [self enumDataFromLocalDB:_doc];
        }];
    } else {
        
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    return self;
}

- (BOOL)isLoginedByUser {
    return _current_user != nil;
//    return NO;
}

- (BOOL)isTmpLoginProcess {
    return _reg_user != nil;
}

- (void)resignTmpLoginUserProcess {
    [RegCurrentToken deleteCurrentRegUserInContext:_doc.managedObjectContext];
}

- (NSArray*)enumAllAuthorisedUsers {
    [self reloadDataFromLocalDB];
//    return authorised_users;
    return [[NSArray alloc]init];
}

- (BOOL)sendLoginRequestToPhone:(NSString*) phoneNum {
  
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:phoneNum forKey:@"phoneNo"];
   
    NSError * error = nil;
    NSData* jsonData =[NSJSONSerialization dataWithJSONObject:[dic copy] options:NSJSONWritingPrettyPrinted error:&error];
    
    NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:[AUTH_HOST_DOMAIN stringByAppendingString:AUTH_WITH_PHONE]]];
 
    if ([[result objectForKey:@"status"] isEqualToString:@"ok"]) {
        NSDictionary* reVal = [result objectForKey:@"result"];
        NSString* reg_token = (NSString*)[reVal objectForKey:@"reg_token"];
        NSString* phoneNo = (NSString*)[reVal objectForKey:@"phoneNo"];
        [RegTmpToken createRegTokenInContext:_doc.managedObjectContext WithToken: reg_token andPhoneNumber: phoneNo];
        return YES;
    } else {
        NSDictionary* reError = [result objectForKey:@"error"];
        NSString* msg = [reError objectForKey:@"message"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:msg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
}

- (LoginModelConfirmResult)sendConfirmCode:(NSString*)code ToPhone:(NSString*) phoneNum withToken:(NSString*)reg_token toResult:(NSDictionary**)reVal {
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:phoneNum forKey:@"phoneNo"];
    [dic setValue:reg_token forKey:@"reg_token"];
    [dic setValue:[Tools getDeviceUUID] forKey:@"uuid"];
    [dic setValue:code forKey:@"code"];
   
    NSError * error = nil;
    NSData* jsonData =[NSJSONSerialization dataWithJSONObject:[dic copy] options:NSJSONWritingPrettyPrinted error:&error];

    NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:[AUTH_HOST_DOMAIN stringByAppendingString:AUTH_CONFIRM]]];
 
    if ([[result objectForKey:@"status"] isEqualToString:@"ok"]) {
        *reVal = [result objectForKey:@"result"];
        [RegTmpToken removeTokenInContext:_doc.managedObjectContext WithToken:reg_token];
        LoginToken *user = [LoginToken createTokenInContext:_doc.managedObjectContext withUserID:[*reVal objectForKey:@"user_id"] andAttrs:*reVal];
//        _current_user = [CurrentToken changeCurrentLoginUser:user inContext:_doc.managedObjectContext];
        _reg_user = [RegCurrentToken changeCurrentRegLoginUser:user inContext:_doc.managedObjectContext];
        return LoginModelResultSuccess;
    } else {
        NSDictionary* reError = [result objectForKey:@"error"];
        NSString* msg = [reError objectForKey:@"message"];
        if ([msg isEqualToString:@"already login"]) {
            [RegTmpToken removeTokenInContext:_doc.managedObjectContext WithToken:reg_token];
            *reVal = reError;
            LoginToken *user = [LoginToken createTokenInContext:_doc.managedObjectContext withUserID:[*reVal objectForKey:@"user_id"] andAttrs:*reVal];
//            _current_user = [CurrentToken changeCurrentLoginUser:user inContext:_doc.managedObjectContext];
            _reg_user = [RegCurrentToken changeCurrentRegLoginUser:user inContext:_doc.managedObjectContext];
            return LoginModelResultOthersLogin;
        } else if ([msg isEqualToString:@"new user"]) {
            [RegTmpToken removeTokenInContext:_doc.managedObjectContext WithToken:reg_token];
            *reVal = reError;
            LoginToken *user = [LoginToken createTokenInContext:_doc.managedObjectContext withUserID:[*reVal objectForKey:@"user_id"] andAttrs:*reVal];
//            _current_user = [CurrentToken changeCurrentLoginUser:user inContext:_doc.managedObjectContext];
            _reg_user = [RegCurrentToken changeCurrentRegLoginUser:user inContext:_doc.managedObjectContext];
            return LoginModelResultSuccess;
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:msg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil] show];
            return LoginModelResultError;
        }
    }
}

- (void)loginWithPhoneNo:(NSString*)phoneNo andPassword:(NSString*)password {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:phoneNo forKey:@"phoneNo"];
    [dic setValue:password forKey:@"pwd"];
    
    NSError * error = nil;
    NSData* jsonData =[NSJSONSerialization dataWithJSONObject:[dic copy] options:NSJSONWritingPrettyPrinted error:&error];
    
    //    NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:@"http://192.168.0.104:8888/login/authConfirm"]];
    NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:[AUTH_HOST_DOMAIN stringByAppendingString:AUTH_PWD]]];
    
    if ([[result objectForKey:@"status"] isEqualToString:@"ok"]) {
        NSDictionary* reVal = [result objectForKey:@"result"];
        NSString* user_id = (NSString*)[reVal objectForKey:@"user_id"];
        LoginToken* user = [LoginToken createTokenInContext:_doc.managedObjectContext withUserID:user_id andAttrs:reVal];
        
        _current_user = [CurrentToken changeCurrentLoginUser:user inContext:_doc.managedObjectContext];
        [_doc.managedObjectContext save:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:kDongDaNotificationkeyLoginSuccess object:nil];
    
    } else {
        NSDictionary* reError = [result objectForKey:@"error"];
        NSString* msg = [reError objectForKey:@"message"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:msg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
    }
}

- (BOOL)sendScreenName:(NSString*)screen_name forToken:(NSString*)auth_token andUserID:(NSString*)user_id {
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:screen_name forKey:@"screen_name"];
    [dic setValue:auth_token forKey:@"auth_token"];
    [dic setValue:user_id forKey:@"user_id"];
    
    return [self updateUserProfile:[dic copy]];
}

- (BOOL)updateUserProfile:(NSDictionary*)attrs {
   
    NSError * error = nil;
    NSData* jsonData =[NSJSONSerialization dataWithJSONObject:attrs options:NSJSONWritingPrettyPrinted error:&error];
    
    NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:[PROFILE_HOST_DOMAIN stringByAppendingString:PROFILE_UPDATE_DETAILS]]];
    
    if ([[result objectForKey:@"status"] isEqualToString:@"ok"]) {
        NSDictionary* reVal = [result objectForKey:@"result"];
        NSString* user_id = (NSString*)[reVal objectForKey:@"user_id"];
        [LoginToken createTokenInContext:_doc.managedObjectContext withUserID:user_id andAttrs:reVal];
        return YES;
    } else {
        NSDictionary* reError = [result objectForKey:@"error"];
        NSString* msg = [reError objectForKey:@"message"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:msg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
}

- (BOOL)updateAndCreateUserProfile:(NSDictionary*)attrs andUserId:(NSString**)new_user_id {
    
    NSError * error = nil;
    NSData* jsonData =[NSJSONSerialization dataWithJSONObject:attrs options:NSJSONWritingPrettyPrinted error:&error];
    
    NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:[PROFILE_HOST_DOMAIN stringByAppendingString:PROFILE_UPDATE_DETAILS]]];
    
    if ([[result objectForKey:@"status"] isEqualToString:@"ok"]) {
        NSDictionary* reVal = [result objectForKey:@"result"];
        *new_user_id = (NSString*)[reVal objectForKey:@"user_id"];
        [LoginToken createTokenInContext:_doc.managedObjectContext withUserID:*new_user_id andAttrs:reVal];
        return YES;
    } else {
        NSDictionary* reError = [result objectForKey:@"error"];
        NSString* msg = [reError objectForKey:@"message"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:msg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
}

- (BOOL)sendCreateNewUserWithPhone:(NSString*)phoneNo toResult:(NSDictionary**)reVal {
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:phoneNo forKey:@"phoneNo"];
    [dic setValue:[Tools getDeviceUUID] forKey:@"uuid"];
    
    NSError * error = nil;
    NSData* jsonData =[NSJSONSerialization dataWithJSONObject:[dic copy] options:NSJSONWritingPrettyPrinted error:&error];
    
//    NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:[AUTH_HOST_DOMAIN stringByAppendingString:AUTH_CREATE_WITH_PHONE]]];
    NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:AUTH_TMP_WITH_PHONE]];
    
    if ([[result objectForKey:@"status"] isEqualToString:@"ok"]) {
        *reVal = [result objectForKey:@"result"];
        return YES;
    } else {
        NSDictionary* reError = [result objectForKey:@"error"];
        NSString* msg = [reError objectForKey:@"message"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:msg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
}

#pragma mark - facebook login and call back
- (void)loginWithFacebook {
    
}

#pragma mark - wechat login and call back
- (void)loginWithWeChat {
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo,snsapi_base";
    req.state = @"0744";
    [WXApi sendReq:req];
}

/*! @brief 收到一个来自微信的请求，第三方应用程序处理完后调用sendResp向微信发送结果
 *
 * 收到一个来自微信的请求，异步处理完成后必须调用sendResp发送处理结果给微信。
 * 可能收到的请求有GetMessageFromWXReq、ShowMessageFromWXReq等。
 * @param req 具体请求内容，是自动释放的
 */
-(void) onReq:(BaseReq*)req {
    
}



/*! @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 * @param resp具体的回应内容，是自动释放的
 */
-(void) onResp:(BaseResp*)resp {
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *aresp = (SendAuthResp *)resp;
        if (aresp.errCode == 0) {
            [self getWeChatOpenIdWithCode:aresp.code];
        }
    }
}

- (void)getWeChatOpenIdWithCode:(NSString *)code {
    //https://api.weixin.qq.com/sns/oauth2/access_token?appid=APPID&secret=SECRET&code=CODE&grant_type=authorization_code
    
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",@"wx66d179d99c9ba7d6",@"469c1beed3ecaa3a836767a5999beeb1",code];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                wechatopenid = [dic objectForKey:@"openid"];
                wechattoken = [dic objectForKey:@"access_token"];
                [self getWechatUserInfo];
            }
        });
    });
}

- (void)getWechatUserInfo {
    // https://api.weixin.qq.com/sns/userinfo?access_token=ACCESS_TOKEN&openid=OPENID
    
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",wechattoken,wechatopenid];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                /*
                 {
                 city = Haidian;
                 country = CN;
                 headimgurl = "http://wx.qlogo.cn/mmopen/FrdAUicrPIibcpGzxuD0kjfnvc2klwzQ62a1brlWq1sjNfWREia6W8Cf8kNCbErowsSUcGSIltXTqrhQgPEibYakpl5EokGMibMPU/0";
                 language = "zh_CN";
                 nickname = "xxx";
                 openid = oyAaTjsDx7pl4xxxxxxx;
                 privilege =     (
                 );
                 province = Beijing;
                 sex = 1;
                 unionid = oyAaTjsxxxxxxQ42O3xxxxxxs;
                 }
                 */
                [self loginSuccessWithWeChatAsUser:wechatopenid accessToken:wechattoken infoDic:dic];
                
            }
        });
        
    });
}

- (void)loginSuccessWithWeChatAsUser:(NSString *)qq_openID accessToken:(NSString*)accessToken infoDic:(NSDictionary *)infoDic {
    // 保存 accessToken 和 qq_openID 到本地 coreData 和服务器
//    _current_user = [self sendAuthProvidersName:@"wechat" andProvideUserId:qq_openID andProvideToken:accessToken andProvideScreenName:[infoDic valueForKey:@"nickname"]];
    _reg_user = [self sendAuthProvidersName:@"wechat" andProvideUserId:qq_openID andProvideToken:accessToken andProvideScreenName:[infoDic valueForKey:@"nickname"]];
    NSLog(@"login user id is: %@", _reg_user.who.user_id);
    NSLog(@"login auth token is: %@", _reg_user.who.auth_token);
    NSLog(@"login screen photo is: %@", _reg_user.who.screen_image);

    // 获取头像
    if (_reg_user.who.screen_image == nil || [_reg_user.who.screen_image isEqualToString:@""]) {
        dispatch_queue_t aq = dispatch_queue_create("qq profile img queue", nil);
        dispatch_async(aq, ^{
            NSData* data = [RemoteInstance remoteDownDataFromUrl:[NSURL URLWithString:[infoDic valueForKey:@"headimgurl"]]];
            UIImage* img = [UIImage imageWithData:data];
            if (img) {
                NSString* img_name = [TmpFileStorageModel generateFileName];
                [TmpFileStorageModel saveToTmpDirWithImage:img withName:img_name];
                
                dispatch_queue_t post_queue = dispatch_queue_create("post queue", nil);
                dispatch_async(post_queue, ^(void){
                    [RemoteInstance uploadPicture:img withName:img_name toUrl:[NSURL URLWithString:[POST_HOST_DOMAIN stringByAppendingString:POST_UPLOAD]] callBack:^(BOOL successs, NSString *message) {
                        if (successs) {
                            NSLog(@"post image success");
                        } else {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                            [alert show];
                        }
                    }];
                });
                
                NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
                [dic setValue:_reg_user.who.auth_token forKey:@"auth_token"];
                [dic setValue:_reg_user.who.user_id forKey:@"user_id"];
                [dic setValue:img_name forKey:@"screen_photo"];
                [self updateUserProfile:[dic copy]];
            }
        });
    }
    
    /**
     *  4. push notification to the controller
     *      and controller to refresh the view
     */
    dispatch_async(dispatch_get_main_queue(), ^{
        [_doc.managedObjectContext save:nil];
        NSLog(@"end get user info from weibo");
        [[NSNotificationCenter defaultCenter] postNotificationName:kDongDaNotificationkeySNSLoginSuccess object:nil];
    });
}

- (void)postContentOnWeChatWithText:(NSString *)text andImage:(UIImage *)img {

    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"咚哒";
    message.description = @"我在咚哒，快来加入咚哒吧";
    message.thumbData = UIImagePNGRepresentation(img);
    WXWebpageObject *webpageObject = [WXWebpageObject object];
    webpageObject.webpageUrl = @"www.baidu.com";
    message.mediaObject = webpageObject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;
    [WXApi sendReq:req];
}

- (void)postContentOnFriendShipWithText:(NSString *)text andImage:(UIImage *)img {
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:[Tools OriginImage:img scaleToSize:CGSizeMake(100, 100)]];
    // 缩略图
    WXImageObject *imageObject = [WXImageObject object];
    imageObject.imageData = UIImagePNGRepresentation(img);
    message.mediaObject = imageObject;
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;
    [WXApi sendReq:req];
}


#pragma mark - qq login and call back
- (void)loginWithQQ {
        [qq_oauth authorize:permissions inSafari:YES];
}

- (void)loginSuccessWithQQAsUser:(NSString *)qq_openID accessToken:(NSString*)accessToken infoDic:(NSDictionary *)infoDic {
    // 保存 accessToken 和 qq_openID 到本地 coreData 和服务器
//    _current_user = [self sendAuthProvidersName:@"qq" andProvideUserId:qq_openID andProvideToken:accessToken andProvideScreenName:[infoDic valueForKey:@"nickname"]];
    _reg_user = [self sendAuthProvidersName:@"qq" andProvideUserId:qq_openID andProvideToken:accessToken andProvideScreenName:[infoDic valueForKey:@"nickname"]];
    NSLog(@"login user id is: %@", _reg_user.who.user_id);
    NSLog(@"login auth token is: %@", _reg_user.who.auth_token);
    NSLog(@"login screen photo is: %@", _reg_user.who.screen_image);
    
    // 获取头像
    if (_reg_user.who.screen_image == nil || [_reg_user.who.screen_image isEqualToString:@""]) {
        dispatch_queue_t aq = dispatch_queue_create("qq profile img queue", nil);
        dispatch_async(aq, ^{
            NSData* data = [RemoteInstance remoteDownDataFromUrl:[NSURL URLWithString:[infoDic valueForKey:@"figureurl_qq_2"]]];
            UIImage* img = [UIImage imageWithData:data];
            if (img) {
                NSString* img_name = [TmpFileStorageModel generateFileName];
                [TmpFileStorageModel saveToTmpDirWithImage:img withName:img_name];
                
                dispatch_queue_t post_queue = dispatch_queue_create("post queue", nil);
                dispatch_async(post_queue, ^(void){
                    [RemoteInstance uploadPicture:img withName:img_name toUrl:[NSURL URLWithString:[POST_HOST_DOMAIN stringByAppendingString:POST_UPLOAD]] callBack:^(BOOL successs, NSString *message) {
                        if (successs) {
                            NSLog(@"post image success");
                        } else {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                            [alert show];
                        }
                    }];
                });
                
                NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
                [dic setValue:_reg_user.who.auth_token forKey:@"auth_token"];
                [dic setValue:_reg_user.who.user_id forKey:@"user_id"];
                [dic setValue:img_name forKey:@"screen_photo"];
                [self updateUserProfile:[dic copy]];
            }
        });
    }
    
    /**
     *  4. push notification to the controller
     *      and controller to refresh the view
     */
    dispatch_async(dispatch_get_main_queue(), ^{
        [_doc.managedObjectContext save:nil];
        NSLog(@"end get user info from weibo");
        [[NSNotificationCenter defaultCenter] postNotificationName:kDongDaNotificationkeySNSLoginSuccess object:nil];
    });
}

- (void)postContentOnQQzoneWithText:(NSString *)text andImage:(UIImage *)img type:(ShareResouseTyoe)type{
    if (![TencentOAuth iphoneQQInstalled]) {
        [[[UIAlertView alloc] initWithTitle:@"通知" message:@"当前手机未安装QQ无法分享到QQ空间" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
        return;
    }
    SendMessageToQQReq* req;
    QQApiObject *qqObj;
    switch (type) {
        case ShareImage:{
            NSData *thumbnailImg = UIImagePNGRepresentation([Tools OriginImage:img scaleToSize:CGSizeMake(100, 100)]);
            NSData *previewImg = UIImagePNGRepresentation(img);
            qqObj = [QQApiImageObject objectWithData:previewImg previewImageData:thumbnailImg title:@"咚哒" description:text];
        }
            break;
        case ShareNews:{
            
            NSData *previewData = UIImagePNGRepresentation([Tools OriginImage:img scaleToSize:CGSizeMake(100, 100)]);
            qqObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:@"www.baidu.com"] title:@"咚哒" description:text previewImageData:previewData targetContentType:QQApiURLTargetTypeNews];
        }
            break;
        default:
            break;
    }
    req = [SendMessageToQQReq reqWithContent:qqObj];
    if ([QQApiInterface sendReq:req] != EQQAPISENDSUCESS) {
        [[[UIAlertView alloc] initWithTitle:@"通知" message:@"分享QQ失败" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
    }
}

#pragma mark - weibo login call back
- (void)loginWithWeibo {
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = @"http://192.168.0.101";
    request.scope = @"all";
    request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
}

- (RegCurrentToken*)sendAuthProviders: (Providers*)provider {
    return [self sendAuthProvidersName:provider.provider_name andProvideUserId:provider.provider_user_id andProvideToken:provider.provider_token andProvideScreenName:provider.provider_screen_name];
}


/**
 *  保存到本地和服务器
 *
 *  @param provide_name        保存的方式
 *  @param provide_user_id     用户id
 *  @param provide_token       token
 *  @param provide_screen_name 昵称
 *
 *  @return 返回当前的token
 */
- (RegCurrentToken *)sendAuthProvidersName:(NSString*)provide_name andProvideUserId:(NSString*)provide_user_id andProvideToken:(NSString*)provide_token andProvideScreenName:(NSString*)provide_screen_name {
  
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [dic setValue:@"" forKey:@"auth_token"];
    [dic setValue:@"" forKey:@"user_id"];
    [dic setValue:provide_name forKey:@"provide_name"];
    [dic setValue:provide_screen_name forKey:@"provide_screen_name"];
    [dic setValue:@"" forKey:@"provide_screen_photo"];
    [dic setValue:provide_user_id forKey:@"provide_uid"];
    [dic setValue:provide_token forKey:@"provide_token"];
    [dic setValue:[Tools getDeviceUUID] forKey:@"uuid"];
    
    NSError * error = nil;
    NSData* jsonData =[NSJSONSerialization dataWithJSONObject:[dic copy] options:NSJSONWritingPrettyPrinted error:&error];
    
    NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:[AUTH_HOST_DOMAIN stringByAppendingString:AUTH_WITH_THIRD]]];
    
    if ([[result objectForKey:@"status"] isEqualToString:@"ok"]) {
        NSDictionary* reVal = [result objectForKey:@"result"];
        NSString* user_id = (NSString*)[reVal objectForKey:@"user_id"];
        Providers* tmp = [Providers createProviderInContext:_doc.managedObjectContext ByName:provide_name andProviderUserId:provide_user_id andProviderToken:provide_token andProviderScreenName:provide_screen_name];
        LoginToken* user = [LoginToken createTokenInContext:_doc.managedObjectContext withUserID:user_id andAttrs:reVal];
        [user addConnectWithObject:tmp];
      
//        return [CurrentToken changeCurrentLoginUser:user inContext:_doc.managedObjectContext];
        return [RegCurrentToken changeCurrentRegLoginUser:user inContext:_doc.managedObjectContext];
    } else {
        NSDictionary* reError = [result objectForKey:@"error"];
        NSString* msg = [reError objectForKey:@"message"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:msg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
        return nil;
    }
}

- (void)loadWeiboUsersWithCurrentUserWithFinishBlock:(weiboUsersFinishBlock)block {
    
    /**
     * 1. get weibo user id and weibo token
     *    if not success, tell user to connect weibo first
     */
    Providers* cur = [Providers enumProvideInContext:_doc.managedObjectContext ByName:@"weibo" andCurrentUserID:self.current_user_id];
    
    if (cur == nil) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"请先绑定微博或用微博登录" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
//        [alert show];
        NSLog(@"请先绑定微博或用微博登录");
    } else {
        /**
         * 2. send request to weibo
         */
        dispatch_queue_t wb_query_queue = dispatch_queue_create("wb query queus", nil);
        dispatch_async(wb_query_queue, ^{
//            NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithCapacity:2];
//            [dic setObject:cur.provider_user_id forKey:@"uid"];
//            [dic setObject:cur.provider_token forKey:@"access_token"];
//            [dic setObject:@"2" forKey:@"page"];
//            [dic setObject:@"100" forKey:@"count"];
            [WBHttpRequest requestForBilateralFriendsListOfUser:cur.provider_user_id withAccessToken:cur.provider_token andOtherProperties:nil queue:[NSOperationQueue currentQueue] withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
    
                NSArray* friends = [result objectForKey:@"users"];
                if (friends.count > 0) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        block(YES, friends);
                    });
                }
            }];
        });
    }
}

- (void)inviteFriendWithWeibo:(WeiboUser*)weibo_friend {
    
    /**
     * 1. get weibo user id and weibo token
     *    if not success, tell user to connect weibo first
     */
    Providers* cur = [Providers enumProvideInContext:_doc.managedObjectContext ByName:@"weibo" andCurrentUserID:self.current_user_id];
    
    if (cur == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"请先绑定微博或用微博登录" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
    } else {
        /**
         * 2. send request to weibo
         */
        NSLog(@"SDK Version: %@", [WeiboSDK getSDKVersion]);
        if (weibo_friend == nil) {
            WBSDKAppRecommendRequest* request = [WBSDKAppRecommendRequest requestWithUIDs:nil access_token:cur.provider_token];
            [WeiboSDK sendRequest:request];
        } else {
            WBSDKAppRecommendRequest* request = [WBSDKAppRecommendRequest requestWithUIDs:@[weibo_friend.userID] access_token:cur.provider_token];
            [WeiboSDK sendRequest:request];
        }
       
//        [WeiboSDK inviteFriend:@"快来加入咚嗒" withUid:weibo_friend.userID withToken:cur.provider_token delegate:self withTag:nil];
        
//          NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithCapacity:2];
//          [dic setObject:cur.provider_token forKey:@"access_token"];
//          [dic setObject:@"text" forKey:@"type"];
//          [dic setObject:@"快来加入咚嗒" forKey:@"data"];
//          [dic setObject:weibo_friend.userID forKey:@"receiver_id"];
//          [WBHttpRequest requestWithURL:@"https://m.api.weibo.com/2/messages/reply.json" httpMethod:@"POST" params:[dic copy] queue:[NSOperationQueue mainQueue] withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
//            
//              NSLog(@"result is %@", result);
//              NSLog(@"error is %@", error.domain);
//          }];
    }
}

- (void)postContentOnWeiboWithText:(NSString*)text andImage:(UIImage*)img {
    
    /**
     * 1. get weibo user id and weibo token
     *    if not success, tell user to connect weibo first
     */
    Providers* cur = [Providers enumProvideInContext:_doc.managedObjectContext ByName:@"weibo" andCurrentUserID:self.current_user_id];
    
    if (cur == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"请先绑定微博或用微博登录" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
    } else {
        dispatch_queue_t wb_query_queue = dispatch_queue_create("wb share queus", nil);
        dispatch_async(wb_query_queue, ^{
            WBImageObject* img_obj = [WBImageObject object];
            img_obj.imageData = UIImagePNGRepresentation(img);
            [WBHttpRequest requestForShareAStatus:text contatinsAPicture:img_obj orPictureUrl:nil withAccessToken:cur.provider_token andOtherProperties:nil queue:[NSOperationQueue currentQueue] withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
                NSLog(@"result is %@", result);
                NSLog(@"error is %@", error.domain);
            }];
        });
    }
}

- (void)loginSuccessWithWeiboAsUser:(NSString*)weibo_user_id withToken:(NSString*)weibo_token {
    NSLog(@"wei bo login success");
    NSLog(@"login as user: %@", weibo_user_id);
    NSLog(@"login with token: %@", weibo_token);
    /**
     *  1. get user email in weibo profle
     */
    [WBHttpRequest requestForUserProfile:weibo_user_id withAccessToken:weibo_token andOtherProperties:nil queue:nil withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
        
        NSLog(@"begin get user info from weibo");
        NSString *title = nil;
        UIAlertView *alert = nil;
        
        if (error) {
            title = NSLocalizedString(@"请求异常", nil);
            alert = [[UIAlertView alloc] initWithTitle:title
                                               message:[NSString stringWithFormat:@"%@",error]
                                              delegate:nil
                                     cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                     otherButtonTitles:nil];
            [alert show];
        } else {
           /**
            *  2. sent user screen name to server and create auth_token
            */
            WeiboUser* user = (WeiboUser*)result;
            NSString* screen_name = user.screenName;
            NSLog(@"user name is %@", screen_name);
            
            /**
             *  3. save auth_toke and weibo user profile in local DB
             */
//            _current_user = [self sendAuthProvidersName:@"weibo" andProvideUserId:weibo_user_id andProvideToken:weibo_token andProvideScreenName:screen_name];
            _reg_user = [self sendAuthProvidersName:@"weibo" andProvideUserId:weibo_user_id andProvideToken:weibo_token andProvideScreenName:screen_name];
            NSLog(@"new user token %@", _reg_user.who.auth_token);
            NSLog(@"new user id %@", _reg_user.who.user_id);
            NSLog(@"new user photo %@", _reg_user.who.screen_image);
            
            if (_reg_user.who.screen_image == nil || [_reg_user.who.screen_image isEqualToString:@""]) {
                dispatch_queue_t aq = dispatch_queue_create("weibo profile img queue", nil);
                dispatch_async(aq, ^{
                    NSData* data = [RemoteInstance remoteDownDataFromUrl:[NSURL URLWithString:user.profileImageUrl]];
                    UIImage* img = [UIImage imageWithData:data];
                    if (img) {
                        NSString* img_name = [TmpFileStorageModel generateFileName];
                        [TmpFileStorageModel saveToTmpDirWithImage:img withName:img_name];
                        
                        dispatch_queue_t post_queue = dispatch_queue_create("post queue", nil);
                        dispatch_async(post_queue, ^(void){
                            [RemoteInstance uploadPicture:img withName:img_name toUrl:[NSURL URLWithString:[POST_HOST_DOMAIN stringByAppendingString:POST_UPLOAD]] callBack:^(BOOL successs, NSString *message) {
                                if (successs) {
                                    NSLog(@"post image success");
                                } else {
                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                                    [alert show];
                                }
                            }];
                        });
                        
                        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
                        [dic setValue:_reg_user.who.auth_token forKey:@"auth_token"];
                        [dic setValue:_reg_user.who.user_id forKey:@"user_id"];
                        [dic setValue:img_name forKey:@"screen_photo"];
                        [self updateUserProfile:[dic copy]];
                    }
                });
            }
            
            /**
             *  4. push notification to the controller
             *      and controller to refresh the view
             */
            dispatch_async(dispatch_get_main_queue(), ^{
                [_doc.managedObjectContext save:nil];
                NSLog(@"end get user info from weibo");
                [[NSNotificationCenter defaultCenter] postNotificationName:kDongDaNotificationkeySNSLoginSuccess object:nil];
            });
        }
    }];
}

- (BOOL)isCurrentUserConnectWithWeibo {
    return [Providers enumProvideInContext:_doc.managedObjectContext ByName:@"weibo" andCurrentUserID:self.current_user_id] != nil;
}

#pragma mark -- current token
- (void)setCurrentUser:(LoginToken*)user {
    NSLog(@"set token : %@", user.auth_token);
    NSLog(@"set user id : %@", user.user_id);
    
    _current_user = [CurrentToken changeCurrentLoginUser:user inContext:_doc.managedObjectContext];
    [_doc.managedObjectContext save:nil];
}

- (CurrentToken*)getCurrentUser {
    _current_user = [CurrentToken enumCurrentLoginUserInContext:_doc.managedObjectContext];
    return _current_user;
}

- (NSDictionary*)getCurrentUserAttr {
    CurrentToken* cur = [CurrentToken enumCurrentLoginUserInContext:_doc.managedObjectContext];
    return [LoginToken userToken2Attr:cur.who];
}

- (NSDictionary*)getRegTmpUserAttr {
    RegCurrentToken* cur = [RegCurrentToken enumCurrentRegLoginUserInContext:_doc.managedObjectContext];
    return [LoginToken userToken2Attr:cur.who];
}

- (NSString*)getCurrentUserID {
    return _current_user.who.user_id;
}

- (NSString*)getCurrentAuthToken {
    return _current_user.who.auth_token;
}

#pragma mark -- logout and online, offline users
- (BOOL)signOutCurrentUser {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
   
    [dic setObject:_current_user.who.user_id forKey:@"user_id"];
    [dic setObject:_current_user.who.auth_token forKey:@"auth_token"];

    if (_apns_token) {
        [dic setObject:_apns_token forKey:@"device_token"];
    }
    
    NSError * error = nil;
    NSData* jsonData =[NSJSONSerialization dataWithJSONObject:[dic copy] options:NSJSONWritingPrettyPrinted error:&error];
    
    NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:AUTH_SINGOUT_USER]];
    
    if ([[result objectForKey:@"status"] isEqualToString:@"ok"]) {
//        [CurrentToken logOutCurrentLoginUserInContext:_doc.managedObjectContext];
//        _current_user = nil;
        [self signOutCurrentUserLocal];
        return YES;
        
    } else {
        return NO;
    }
}

- (void)signOutCurrentUserLocal {
    [CurrentToken logOutCurrentLoginUserInContext:_doc.managedObjectContext];
    _current_user = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:kDongDaNotificationkeyUserSignOutSuccess object:nil];
}

- (BOOL)offlineCurrentUser {
  
    if (self.current_user == nil)
        return NO;
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:_current_user.who.user_id forKey:@"user_id"];
    [dic setObject:_current_user.who.auth_token forKey:@"auth_token"];
    
    NSError * error = nil;
    NSData* jsonData =[NSJSONSerialization dataWithJSONObject:[dic copy] options:NSJSONWritingPrettyPrinted error:&error];
    
    NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:AUTH_OFFLINE_USER]];
    
    if ([[result objectForKey:@"status"] isEqualToString:@"ok"]) {
        [CurrentToken offlineCurrentLoginUserInContext:_doc.managedObjectContext];
        return YES;
        
    } else {
        //        NSDictionary* reError = [result objectForKey:@"error"];
        //        NSString* msg = [reError objectForKey:@"message"];
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:msg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        //        [alert show];
        return NO;
    }
}

- (BOOL)onlineCurrentUser {
    
    if (self.current_user == nil || _current_user.who.user_id == nil)
        return NO;
   
    NSLog(@"user_id = %@", _current_user.who.user_id);
    NSLog(@"auth_token = %@", _current_user.who.auth_token);
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:_current_user.who.user_id forKey:@"user_id"];
    [dic setObject:_current_user.who.auth_token forKey:@"auth_token"];
    
    NSError * error = nil;
    NSData* jsonData =[NSJSONSerialization dataWithJSONObject:[dic copy] options:NSJSONWritingPrettyPrinted error:&error];
    
    NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:AUTH_ONLINE_USER]];
    
    if ([[result objectForKey:@"status"] isEqualToString:@"ok"]) {
        [CurrentToken onlineCurrentLoginUserInContext:_doc.managedObjectContext];
        return YES;
        
    } else {
        //        NSDictionary* reError = [result objectForKey:@"error"];
        //        NSString* msg = [reError objectForKey:@"message"];
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:msg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        //        [alert show];
        return NO;
    }
}

- (BOOL)isCurrentUserOffline {
    return [CurrentToken isCurrentOfflineInContext:_doc.managedObjectContext];
}

#pragma mark -- query mutiple user simple profiles
- (NSArray*)querMultipleProlfiles:(NSArray*)user_ids {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:_current_user.who.user_id forKey:@"user_id"];
    [dic setObject:_current_user.who.auth_token forKey:@"auth_token"];
    
    [dic setObject:user_ids forKey:@"query_list"];
    
    NSError * error = nil;
    NSData* jsonData =[NSJSONSerialization dataWithJSONObject:[dic copy] options:NSJSONWritingPrettyPrinted error:&error];
    
    NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:[PROFILE_HOST_DOMAIN stringByAppendingString:PROFILE_QUERY_MULTIPLE]]];
    
    if ([[result objectForKey:@"status"] isEqualToString:@"ok"]) {
       
        return [result objectForKey:@"result"];
    } else {
        NSDictionary* reError = [result objectForKey:@"error"];
        NSString* msg = [reError objectForKey:@"message"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:msg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
        return nil;
    }
}

- (void)querRecommendUserProlfilesWithFinishBlock:(queryRecommendUserFinishBlock)block {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:_current_user.who.user_id forKey:@"user_id"];
    [dic setObject:_current_user.who.auth_token forKey:@"auth_token"];
    
    NSError * error = nil;
    NSData* jsonData =[NSJSONSerialization dataWithJSONObject:[dic copy] options:NSJSONWritingPrettyPrinted error:&error];
    
    NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:PROFILE_QUERY_RECOMMEND]];
    
    if ([[result objectForKey:@"status"] isEqualToString:@"ok"]) {
       
        NSArray* reVal = [result objectForKey:@"result"];
        NSLog(@"user profile is %@", reVal);
        block(YES, reVal);
        
    } else {
//        NSDictionary* reError = [result objectForKey:@"error"];
//        NSString* msg = [reError objectForKey:@"message"];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:msg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
//        [alert show];
//        return nil;
        block(NO, nil);
    }
}

#pragma mark -- reachability change
- (void)reachabilityChanged:(NSNotification*)notify {
    Reachability * reach = [notify object];
    
    if([reach isReachable]) {
        NSString * temp = [NSString stringWithFormat:@"InternetConnection Notification Says Reachable(%@)", reach.currentReachabilityString];
        NSLog(@"%@", temp);
      
        if ([self isCurrentUserOffline]) {
            [self onlineCurrentUser];
        }
        
    } else {
        NSString * temp = [NSString stringWithFormat:@"InternetConnection Notification Says Unreachable(%@)", reach.currentReachabilityString];
        NSLog(@"%@", temp);
        
    }
}

#pragma mark -- current user detail info
- (BOOL)isCurrentHasDetailInfoLocal {
    return [CurrentToken isCurrentHasDetailInfoInContext:_doc.managedObjectContext];
}

- (BOOL)isCurrentHasDetailInfo {
    // TODO: query server
    return [CurrentToken isCurrentHasDetailInfoInContext:_doc.managedObjectContext];
}

- (void)currentDeltailInfoAsyncWithFinishBlock:(descriptionFinishBlock)block {
    
    dispatch_queue_t aq = dispatch_queue_create("detail description", nil);

    dispatch_async(aq, ^{
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        
        [dic setObject:_current_user.who.user_id forKey:@"user_id"];
        [dic setObject:_current_user.who.auth_token forKey:@"auth_token"];
        
        NSError * error = nil;
        NSData* jsonData =[NSJSONSerialization dataWithJSONObject:[dic copy] options:NSJSONWritingPrettyPrinted error:&error];
        
        NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:PROFILE_QUERY_DETAIL_DESCRIPTION]];
        
        if ([[result objectForKey:@"status"] isEqualToString:@"ok"]) {
            
            block(YES, [result objectForKey:@"result"]);
        } else {
            block(NO, [result objectForKey:@"error"]);
        }
    });
}

- (NSDictionary*)currentDeltailInfoLocal {
    return [CurrentToken currentDetailInfoInContext:_doc.managedObjectContext];
}

- (void)updateDetailInfoWithData:(NSDictionary*)dic_attr {
    NSMutableDictionary* dic = [dic_attr mutableCopy];
    
    [dic setObject:_current_user.who.user_id forKey:@"user_id"];
    [dic setObject:_current_user.who.auth_token forKey:@"auth_token"];
    
    NSError * error = nil;
    NSData* jsonData =[NSJSONSerialization dataWithJSONObject:[dic copy] options:NSJSONWritingPrettyPrinted error:&error];
    
    NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:PROFILE_QUERY_UPDATE_DESCRIPTION]];
    
    if ([[result objectForKey:@"status"] isEqualToString:@"ok"]) {
       
        NSLog(@"%@", [result objectForKey:@"result"]);
        [self updateDetailInfoLocalWithData:dic_attr];
    } else {
        //            NSDictionary* reError = [result objectForKey:@"error"];
        //            NSString* msg = [reError objectForKey:@"message"];
        //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:msg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        //            [alert show];
        NSLog(@"%@", [result objectForKey:@"error"]);
    }
}

- (void)updateDetailInfoLocalWithData:(NSDictionary*)dic {
    return [CurrentToken updateCurrentDetailInfoWithAttr:dic InContext:_doc.managedObjectContext];
}

#pragma mark -- weibo delegate

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        NSString *title = NSLocalizedString(@"发送结果", nil);
        NSString *message = [NSString stringWithFormat:@"%@: %d\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode, NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil),response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                              otherButtonTitles:nil];
        WBSendMessageToWeiboResponse* sendMessageToWeiboResponse = (WBSendMessageToWeiboResponse*)response;
        NSString* accessToken = [sendMessageToWeiboResponse.authResponse accessToken];
        if (accessToken)
        {
            self.wbtoken = accessToken;
        }
        NSString* userID = [sendMessageToWeiboResponse.authResponse userID];
        if (userID) {
            self.wbCurrentUserID = userID;
        }
        [alert show];
    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        /**
         * auth response
         * if success throw the user id and the token to the login model
         * otherwise show error message
         */
        if (response.statusCode == 0) { // success
            [self loginSuccessWithWeiboAsUser:[(WBAuthorizeResponse *)response userID] withToken:[(WBAuthorizeResponse *)response accessToken]];
        } else {
            NSString *title = @"weibo auth error";
            
            NSString *message = [NSString stringWithFormat: @"some thing wrong, and error code is %ld", (long)response.statusCode];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                            message:message
                                                           delegate:nil
                                                  cancelButtonTitle:@"cancel"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    else if ([response isKindOfClass:WBPaymentResponse.class])
    {
        NSString *title = NSLocalizedString(@"支付结果", nil);
        NSString *message = [NSString stringWithFormat:@"%@: %d\nresponse.payStatusCode: %@\nresponse.payStatusMessage: %@\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode,[(WBPaymentResponse *)response payStatusCode], [(WBPaymentResponse *)response payStatusMessage], NSLocalizedString(@"响应UserInfo数据", nil),response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil), response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                              otherButtonTitles:nil];
        [alert show];
    }
    else if ([response isKindOfClass:WBSDKAppRecommendResponse.class]) {
        
        NSString *title = @"推荐结果";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:[NSString stringWithFormat:@"response %@", ((WBSDKAppRecommendResponse*)response)]
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                              otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark -- tencent delegate
/**
 * 登录成功后的回调
 */
- (void)tencentDidLogin {
    NSLog(@"login succss with token : %@", qq_oauth.accessToken);
    if (qq_oauth.accessToken && 0 != [qq_oauth.accessToken length]) {
        //  记录登录用户的OpenID、Token以及过期时间
        NSLog(@"张openId === %@", [qq_oauth getUserOpenID]);
        NSLog(@"login succss with token : %@", qq_oauth.accessToken);
        NSLog(@"获取用户信息 === %c", [qq_oauth getUserInfo]);
    } else {
        NSLog(@"login error");
    }
}

/**
 * 登录失败后的回调
 * \param cancelled 代表用户是否主动退出登录
 */
- (void)tencentDidNotLogin:(BOOL)cancelled {
    if (cancelled) {
        NSLog(@"login user cancel");
    } else {
        NSLog(@"login failed");
    }
}

/**
 * 登录时网络有问题的回调
 */
-(void)tencentDidNotNetWork {
    NSLog(@"login with no network");
}

/**
 * 获取用户信息的回调
 */
- (void)getUserInfoResponse:(APIResponse *)response {
    if (response.retCode == URLREQUEST_SUCCEED) {
        [self loginSuccessWithQQAsUser:qq_oauth.openId accessToken:qq_oauth.accessToken infoDic:response.jsonResponse];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"通知" message:@"获取QQ详细信息失败" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
    }
}

#pragma mark -- query users in system
- (void)queryUserList:(NSArray*)user_lst withProviderName:(NSString*)provider_name andFinishBlock:(queryUserListInSystemFinishBlock)block {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    
    [dic setValue:self.current_user_id forKey:@"user_id"];
    [dic setValue:self.current_auth_token forKey:@"auth_token"];
    [dic setValue:user_lst forKey:@"lst"];
    [dic setValue:provider_name forKey:@"provider_name"];
    
    NSError *error = nil;
    NSData *jsonData =[NSJSONSerialization dataWithJSONObject:[dic copy] options:NSJSONWritingPrettyPrinted error:&error];
    
    NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:AUTH_USER_IN_SYSTEM]];
    
    if ([[result objectForKey:@"status"] isEqualToString:@"ok"]) {
        NSArray* reVal = [result objectForKey:@"result"];
        NSLog(@"result is: %@", reVal);
        block(YES, reVal);
    } else {
        block(NO, nil);
    }
}

- (void)requestUserInfo:(requestUserInfoSeccess)block {
    dispatch_queue_t queue = dispatch_queue_create("get_userInfo", nil);
    dispatch_async(queue, ^{
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
//        [dic setValue:self.current_auth_token forKey:@"query_auth_token"];
//        [dic setValue:self.current_user_id forKey:@"query_user_id"];
        [dic setValue:self.current_auth_token forKey:@"auth_token"];
        [dic setValue:self.current_user_id forKey:@"user_id"];
        [dic setValue:self.current_user_id forKey:@"owner_user_id"];
        
        NSError * error = nil;
        NSData* jsonData =[NSJSONSerialization dataWithJSONObject:[dic copy] options:NSJSONWritingPrettyPrinted error:&error];
        
        NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:[PROFILE_HOST_DOMAIN stringByAppendingString:PROFILE_QUERY_DETAILS]]];
        if ([[result valueForKey:@"status"] isEqualToString:@"ok"]) {
            block([result valueForKey:@"result"]);
        }
    });
}
@end
