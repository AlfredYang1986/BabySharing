//
//  LoginModel.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 26/12/2014.
//  Copyright (c) 2014 YY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Providers.h"
#import "CurrentToken.h"
#import <UIKit/UIKit.h>
// SDKs
#import "WeiboSDK.h"
#import "WXApi.h"
#import "TencentOAuth.h"

@class WeiboUser;

typedef NS_ENUM(NSInteger, LoginModelConfirmResult) {
    LoginModelResultSuccess,
    LoginModelResultError,
    LoginModelResultOthersLogin,
};

typedef NS_ENUM(NSInteger, LoginModelConnectSNResult) {
    LoginModelConnectSNResultSuccess,
    LoginModelConnectSNResultError,
};

typedef NS_ENUM(NSInteger, ShareResouseTyoe) {
    ShareImage,
    ShareNews,
};

typedef void(^descriptionFinishBlock)(BOOL, NSDictionary*);
typedef void(^weiboUsersFinishBlock)(BOOL success, NSArray* friends);
typedef void(^queryRecommendUserFinishBlock)(BOOL success, NSArray* lst);
typedef void(^queryUserListInSystemFinishBlock)(BOOL success, NSArray* lst);
typedef void(^requestUserInfoSeccess)(NSDictionary *data);

//TencentSessionDelegate 这里有个接口 为了去除警告 注掉了
@interface LoginModel : NSObject <WeiboSDKDelegate, WXApiDelegate> {
    NSArray* authorised_users;
}

@property (strong, nonatomic) UIManagedDocument* doc;
@property (weak, nonatomic, readonly, getter=getCurrentUserID) NSString* current_user_id;
@property (weak, nonatomic, readonly, getter=getCurrentAuthToken) NSString* current_auth_token;

@property (nonatomic, weak) NSString* apns_token;

- (id)init;

- (BOOL)sendLoginRequestToPhone:(NSString*) phoneNum;
- (LoginModelConfirmResult)sendConfirrmCode:(NSString*)code ToPhone:(NSString*) phoneNum withToken:(NSString*)reg_token toResult:(NSDictionary**)reVal;
- (BOOL)sendScreenName:(NSString*)screen_name forToken:(NSString*)auth_token andUserID:(NSString*)user_id;
- (BOOL)updateUserProfile:(NSDictionary*)attrs;
- (BOOL)updateAndCreateUserProfile:(NSDictionary*)attrs andUserId:(NSString**)new_user_id;
- (BOOL)sendCreateNewUserWithPhone:(NSString*)phoneNo toResult:(NSDictionary**)reVal;

- (void)loginWithPhoneNo:(NSString*)phoneNo andPassword:(NSString*)password;
#pragma mark -- weibo login
- (void)loginWithWeibo;
- (void)loadWeiboUsersWithCurrentUserWithFinishBlock:(weiboUsersFinishBlock)block;
- (void)inviteFriendWithWeibo:(WeiboUser*)weibo_friend;
- (void)postContentOnWeiboWithText:(NSString*)text andImage:(UIImage*)img;
- (BOOL)isCurrentUserConnectWithWeibo;

#pragma mark -- face book login
- (void)loginWithFacebook;

#pragma mark -- we chat login
- (void)loginWithWeChat;
- (void)postContentOnWeChatWithText:(NSString *)text andImage:(UIImage *)img;
- (void)postContentOnFriendShipWithText:(NSString *)text andImage:(UIImage *)img;

#pragma mark -- qq login and call back
- (void)loginWithQQ;
- (void)postContentOnQQzoneWithText:(NSString *)text andImage:(UIImage *)img type:(ShareResouseTyoe)type;

- (NSArray*)enumAllAuthorisedUsers;
- (void)reloadDataFromLocalDB;

- (void)loginSuccessWithWeiboAsUser:(NSString*)weibo_user_id withToken:(NSString*)weibo_token;

- (BOOL)isLoginedByUser;
- (BOOL)isTmpLoginProcess;

- (void)setCurrentUser:(LoginToken*)token;
- (CurrentToken*)getCurrentUser;
- (NSDictionary*)getCurrentUserAttr;
- (NSString*)getCurrentUserID;
- (NSString*)getCurrentAuthToken;

- (NSDictionary*)getRegTmpUserAttr;
#pragma mark -- logout
- (BOOL)signOutCurrentUser;
- (BOOL)offlineCurrentUser;
- (BOOL)onlineCurrentUser;
- (BOOL)isCurrentUserOffline;

- (void)resignTmpLoginUserProcess;

#pragma mark -- query mutiple user simple profiles
- (NSArray*)querMultipleProlfiles:(NSArray*)user_ids;
- (void)querRecommendUserProlfilesWithFinishBlock:(queryRecommendUserFinishBlock)block;

#pragma mark -- current user detail info
- (BOOL)isCurrentHasDetailInfoLocal;
- (BOOL)isCurrentHasDetailInfo;

- (void)updateDetailInfoWithData:(NSDictionary*)dic_attr;
- (void)updateDetailInfoLocalWithData:(NSDictionary*)dic;

- (void)currentDeltailInfoAsyncWithFinishBlock:(descriptionFinishBlock)block;
- (NSDictionary*)currentDeltailInfoLocal;

#pragma mark -- query users in system
- (void)queryUserList:(NSArray*)user_lst withProviderName:(NSString*)provider_name andFinishBlock:(queryUserListInSystemFinishBlock)block;
#pragma mark -- requestForUserInfo--这是一个异步线程
- (void)requestUserInfo:(requestUserInfoSeccess)block;
@end
