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
#import "WeiboSDK.h"
#import "WeiboUser.h"
#import "ModelDefines.h"
#import "TmpFileStorageModel.h"
#import "Reachability.h"

// weibo sdk
#import "WBHttpRequest+WeiboUser.h"
#import "WBHttpRequest+WeiboShare.h"

// qq sdk
#import "TencentOAuth.h"

@interface LoginModel ()
@property (strong, nonatomic) CurrentToken* current_user;

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
}

@synthesize doc = _doc;
@synthesize current_user = _current_user;

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
                qq_oauth = [[TencentOAuth alloc]initWithAppId:@"QQ41DA62FE" andDelegate:self];
                qq_oauth.redirectURI = nil;
                permissions =  [NSArray arrayWithObjects:@"get_user_info", @"get_simple_userinfo", @"add_t", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"app ready" object:nil];
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
    _doc = (UIManagedDocument*)[[UIManagedDocument alloc]initWithFileURL:url];
    
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

- (LoginModelConfirmResult)sendConfirrmCode:(NSString*)code ToPhone:(NSString*) phoneNum withToken:(NSString*)reg_token toResult:(NSDictionary**)reVal {
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:phoneNum forKey:@"phoneNo"];
    [dic setValue:reg_token forKey:@"reg_token"];
    [dic setValue:code forKey:@"code"];
   
    NSError * error = nil;
    NSData* jsonData =[NSJSONSerialization dataWithJSONObject:[dic copy] options:NSJSONWritingPrettyPrinted error:&error];

//    NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:@"http://192.168.0.104:8888/login/authConfirm"]];
    NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:[AUTH_HOST_DOMAIN stringByAppendingString:AUTH_CONFIRM]]];
 
    if ([[result objectForKey:@"status"] isEqualToString:@"ok"]) {
        *reVal = [result objectForKey:@"result"];
        [RegTmpToken removeTokenInContext:_doc.managedObjectContext WithToken:reg_token];
        return LoginModelResultSuccess;
    } else {
        NSDictionary* reError = [result objectForKey:@"error"];
        NSString* msg = [reError objectForKey:@"message"];
        if ([msg isEqualToString:@"already login"]) {
            [RegTmpToken removeTokenInContext:_doc.managedObjectContext WithToken:reg_token];
            *reVal = reError;
            return LoginModelResultOthersLogin;
        } else {
         
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:msg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
            [alert show];
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
        [[NSNotificationCenter defaultCenter] postNotificationName:@"login success" object:nil];
    
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
        [LoginToken updataLoginUserInContext:_doc.managedObjectContext withUserID:user_id andAttrs:reVal];
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
    
    NSError * error = nil;
    NSData* jsonData =[NSJSONSerialization dataWithJSONObject:[dic copy] options:NSJSONWritingPrettyPrinted error:&error];
    
    NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:[AUTH_HOST_DOMAIN stringByAppendingString:AUTH_CREATE_WITH_PHONE]]];
    
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
    
}

#pragma mark - qq login and call back
- (void)loginWithQQ {
    [qq_oauth authorize:permissions inSafari:YES];
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

- (CurrentToken*)sendAuthProviders: (Providers*)provider {
    return [self sendAuthProvidersName:provider.provider_name andProvideUserId:provider.provider_user_id andProvideToken:provider.provider_token andProvideScreenName:provider.provider_screen_name];
}

- (CurrentToken*)sendAuthProvidersName:(NSString*)provide_name andProvideUserId:(NSString*)provide_user_id andProvideToken:(NSString*)provide_token andProvideScreenName:(NSString*)provide_screen_name {
  
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@"" forKey:@"auth_token"];
    [dic setValue:@"" forKey:@"user_id"];
    [dic setValue:provide_name forKey:@"provide_name"];
    [dic setValue:provide_screen_name forKey:@"provide_screen_name"];
    [dic setValue:@"" forKey:@"provide_screen_photo"];
    [dic setValue:provide_user_id forKey:@"provide_uid"];
    [dic setValue:provide_token forKey:@"provide_token"];
    
    NSError * error = nil;
    NSData* jsonData =[NSJSONSerialization dataWithJSONObject:[dic copy] options:NSJSONWritingPrettyPrinted error:&error];
    
    NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:[AUTH_HOST_DOMAIN stringByAppendingString:AUTH_WITH_THIRD]]];
    
    if ([[result objectForKey:@"status"] isEqualToString:@"ok"]) {
        NSDictionary* reVal = [result objectForKey:@"result"];
        NSString* user_id = (NSString*)[reVal objectForKey:@"user_id"];
        Providers* tmp = [Providers createProviderInContext:_doc.managedObjectContext ByName:provide_name andProviderUserId:provide_user_id andProviderToken:provide_token andProviderScreenName:provide_screen_name];
        LoginToken* user = [LoginToken createTokenInContext:_doc.managedObjectContext withUserID:user_id andAttrs:reVal];
        [user addConnectWithObject:tmp];
       
        return [CurrentToken changeCurrentLoginUser:user inContext:_doc.managedObjectContext];
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"请先绑定微博或用微博登录" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
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
            _current_user = [self sendAuthProvidersName:@"weibo" andProvideUserId:weibo_user_id andProvideToken:weibo_token andProvideScreenName:screen_name];
            NSLog(@"new user token %@", _current_user.who.auth_token);
            NSLog(@"new user id %@", _current_user.who.user_id);
            
            /**
             * 3.1 user image
             */
            dispatch_queue_t aq = dispatch_queue_create("weibo profile img queue", nil);
            dispatch_async(aq, ^{
                NSData* data = [RemoteInstance remoteDownDataFromUrl:[NSURL URLWithString:user.profileImageUrl]];
                UIImage* img = [UIImage imageWithData:data];
                if (img) {
                    NSString* img_name = [TmpFileStorageModel generateFileName];
                    [TmpFileStorageModel saveToTmpDirWithImage:img withName:img_name];
                    
                    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
                    [dic setValue:[self getCurrentAuthToken] forKey:@"auth_token"];
                    [dic setValue:[self getCurrentUserID] forKey:@"user_id"];
                    [dic setValue:img_name forKey:@"screen_photo"];
                    [self updateUserProfile:[dic copy]];
                    
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
                }
            });
      
            /**
             *  4. push notification to the controller
             *      and controller to refresh the view
             */
            [_doc.managedObjectContext save:nil];
            NSLog(@"end get user info from weibo");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SNS login success" object:nil];
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

    [dic setObject:_apns_token forKey:@"device_token"];
    
    NSError * error = nil;
    NSData* jsonData =[NSJSONSerialization dataWithJSONObject:[dic copy] options:NSJSONWritingPrettyPrinted error:&error];
    
    NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:AUTH_SINGOUT_USER]];
    
    if ([[result objectForKey:@"status"] isEqualToString:@"ok"]) {
        [CurrentToken logOutCurrentLoginUserInContext:_doc.managedObjectContext];
        _current_user = nil;
        return YES;
        
    } else {
//        NSDictionary* reError = [result objectForKey:@"error"];
//        NSString* msg = [reError objectForKey:@"message"];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:msg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
//        [alert show];
        return NO;
    }
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
    
    if (self.current_user == nil)
        return NO;
    
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
//            NSDictionary* reError = [result objectForKey:@"error"];
//            NSString* msg = [reError objectForKey:@"message"];
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:msg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
//            [alert show];
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
        NSLog(@"login succss with token : %@", qq_oauth.accessToken);
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
@end
