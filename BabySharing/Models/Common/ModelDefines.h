//
//  ModelDefines.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 10/01/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ModelAttchmentType) {
    ModelAttchmentTypeImage,
    ModelAttchmentTypeMovie,
};

typedef NS_ENUM(NSInteger, PostCommentsError) {
    PostCommentsErrorNoError,
    PostCommentsErrorPostIDNotExisting,
};

typedef NS_ENUM(NSInteger, PostLikesError) {
    PostLikesErrorNoError,
    PostLikesErrorPostIDNotExisting,
};

typedef NS_ENUM(NSInteger, UserPostOwnerConnections) {
    UserPostOwnerConnectionsNone,
    UserPostOwnerConnectionsSamePerson,
    UserPostOwnerConnectionsFollowing,
    UserPostOwnerConnectionsFollowed,
    UserPostOwnerConnectionsFriends
};

static const NSString* kUserPostOwnerConnectionsNone = @"kUserPostOwnerConnectionsNone";
static const NSString* kUserPostOwnerConnectionsSamePerson = @"kUserPostOwnerConnectionsSamePerson";
static const NSString* kUserPostOwnerConnectionsFollowing = @"kUserPostOwnerConnectionsFollowing";
static const NSString* kUserPostOwnerConnectionsFollowed = @"kUserPostOwnerConnectionsFollowed";
static const NSString* kUserPostOwnerConnectionsFriends = @"kUserPostOwnerConnectionsFriends";

#pragma mark -- HOST DOMAIN
//#define HOST_DOMAIN                     @"http://www.altlys.com:9000/"
#define HOST_DOMAIN                     @"http://192.168.3.105:9000/"
//#define HOST_DOMAIN_SENDBOX             @"http://192.168.1.105:9000/"

#pragma mark -- DOWNLOAD
#define ATT_DOWNLOAD_HOST                   [HOST_DOMAIN stringByAppendingString:@"query/downloadFile/"]

#pragma mark -- QUERY
#define QUERY_HOST_DOMAIN                   [HOST_DOMAIN stringByAppendingString:@"query/"]
#define QUERY_REFRESH_HOME                  @"queryHomeContent"
#define QUERY_COMMENTS                      @"queryComments"
#define QUERY_COLLECTIONS                   [QUERY_HOST_DOMAIN stringByAppendingString:@"queryCollections"]
#define QUERY_PUSH_CONTENT                  [QUERY_HOST_DOMAIN stringByAppendingString:@"queryPush"]

#pragma mark -- AUTH
#define AUTH_HOST_DOMAIN                    [HOST_DOMAIN stringByAppendingString:@"login/"]
#define AUTH_WITH_PHONE                     @"authWithPhone"
#define AUTH_CONFIRM                        @"authConfirm"
#define AUTH_PWD                            @"authWithPwd"
#define AUTH_UPDATE_DETAILS                 @"authUpdateDetails"
#define AUTH_WITH_THIRD                     @"authWithThird"
#define AUTH_CREATE_WITH_PHONE              @"authCreateUserWithPhone"

#define AUTH_USER_IN_SYSTEM                 [AUTH_HOST_DOMAIN stringByAppendingString:@"userLstInSystem"]
#define AUTH_ONLINE_USER                    [AUTH_HOST_DOMAIN stringByAppendingString:@"online"]
#define AUTH_OFFLINE_USER                   [AUTH_HOST_DOMAIN stringByAppendingString:@"offline"]
#define AUTH_SINGOUT_USER                   [AUTH_HOST_DOMAIN stringByAppendingString:@"signout"]

#pragma mark -- POST
#define POST_HOST_DOMAIN                    [HOST_DOMAIN stringByAppendingString:@"post/"]

#define POST_CONTENT                        @"postContent"
#define POST_UPLOAD                         @"uploadFile"
#define POST_COMMENT                        @"postComment"
#define POST_LIKE                           @"postLike"
#define POST_PUSH                           [POST_HOST_DOMAIN stringByAppendingString:@"postPush"]

#pragma mark -- RPOFILE
#define PROFILE_HOST_DOMAIN                 [HOST_DOMAIN stringByAppendingString:@"profile/"]
#define PROFILE_UPDATE_DETAILS              @"updateProfile"
#define PROFILE_QUERY_DETAILS               @"userProfile"
#define PROFILE_QUERY_MULTIPLE              @"multipleUserProfile"
#define PROFILE_QUERY_RECOMMEND             [PROFILE_HOST_DOMAIN stringByAppendingString:@"recommendUserProfile"]

#define PROFILE_QUERY_DETAIL_DESCRIPTION    [PROFILE_HOST_DOMAIN stringByAppendingString:@"queryDetailDescription"]
#define PROFILE_QUERY_UPDATE_DESCRIPTION    [PROFILE_HOST_DOMAIN stringByAppendingString:@"createAndUpdataDetailDescription"]

//#define PROFILE_HOST_DOMAIN_SENDBOX         [HOST_DOMAIN_SENDBOX stringByAppendingString:@"profile/"]


#pragma mark -- GROUPS
//#define GROUP_HOST_DOMAIN_SENDBOX           [HOST_DOMAIN_SENDBOX stringByAppendingString:@"group/"]
#define GROUP_HOST_DOMAIN                   [HOST_DOMAIN stringByAppendingString:@"group/"]
#define QUERY_GROUP                         @"queryGroups"
#define CREATE_SUB_GROUP                    @"createSubGroup"

#define CHAT_GROUP_CREATE                   [GROUP_HOST_DOMAIN stringByAppendingString:@"createChatGroup"]
#define CHAT_GROUP_UPDATE                   [GROUP_HOST_DOMAIN stringByAppendingString:@"updateChatGroup"]
#define CHAT_GROUP_JOIN                     [GROUP_HOST_DOMAIN stringByAppendingString:@"joinChatGroup"]
#define CHAT_GROUP_LEAVE                    [GROUP_HOST_DOMAIN stringByAppendingString:@"leaveChatGroup"]
#define CHAT_GROUP_DISMISS                  [GROUP_HOST_DOMAIN stringByAppendingString:@"dismissChatGroup"]
#define CHAT_GROUP_QUERY                    [GROUP_HOST_DOMAIN stringByAppendingString:@"queryChatGroup"]

#define CHAT_GROUP_POST_ID                  [GROUP_HOST_DOMAIN stringByAppendingString:@"queryChatGroupWithPostID"]

#pragma mark -- MESSAGES
#define MESSAGES_HOST_DOMAIN                [HOST_DOMAIN stringByAppendingString:@"messages/"]
//#define MESSAGE_WEB_SOCKET                  @"ws://www.altlys.com:9000/registerDevice/"

#define MESSAGE_SEND                        [HOST_DOMAIN stringByAppendingString:@"sendMessage"]
#define MESSAGE_QUERY                       [HOST_DOMAIN stringByAppendingString:@"queryMessages"]
#define MESSAGE_QUERY_WITH_FRIEND           [HOST_DOMAIN stringByAppendingString:@"queryMessagesWithFriend"]
#define MESSAGE_FRIEND_ADD                  [HOST_DOMAIN stringByAppendingString:@"addOneFriend"]
#define MESSAGE_FRIEND_QUERY                [HOST_DOMAIN stringByAppendingString:@"queryAllFriend"]

#pragma mark -- TAGS QUERY
#define TAG_HOST_DOMAIN                     [HOST_DOMAIN stringByAppendingString:@"tags/"]
#define TAG_QUERY                           @"queryContentsWithTag"
#define TAG_RECOMMAND_QUERY                 [TAG_HOST_DOMAIN stringByAppendingString:@"queryRecommandTags"]
#define TAG_PREVIEW_QUERY                   [TAG_HOST_DOMAIN stringByAppendingString:@"queryTagPreViewWithTagName"]
#define TAG_FOUND_SEARCH                    [TAG_HOST_DOMAIN stringByAppendingString:@"queryFoundSearchTagData"]
#define TAG_FOUND_SEARCH_WITH_INPUT         [TAG_HOST_DOMAIN stringByAppendingString:@"queryTagSearchWithInput"]

#pragma mark -- USER SEARCH QUERY
#define USER_SEARCH_HOST_DOMAIN             [HOST_DOMAIN stringByAppendingString:@"users/"]
#define USER_SEARCH_RECOMMAND_USERS         [USER_SEARCH_HOST_DOMAIN stringByAppendingString:@"queryRecommandUsers"]
#define USER_SEARCH_ROLE_TAG                [USER_SEARCH_HOST_DOMAIN stringByAppendingString:@"queryUsersWithRoleTag"]
#define USER_SEARCH_POST                    [USER_SEARCH_HOST_DOMAIN stringByAppendingString:@"queryUsersPosts"]
#define USER_SEARCH_SCREEN_NAME             [USER_SEARCH_HOST_DOMAIN stringByAppendingString:@"queryUsersWithScreenName"]
#define USER_RECOMMAND_USERS_ROLE_TAG       [USER_SEARCH_HOST_DOMAIN stringByAppendingString:@"queryRecommandUsersWithRoleTag"]

#pragma mark -- MESSAGE SNEDBOX
//#define MESSAGES_HOST_DOMAIN_SENDBOX        [HOST_DOMAIN_SENDBOX stringByAppendingString:@"messages/"]
#define MESSAGE_WEB_SOCKET_SENDBOX          @"ws://192.168.1.101:9000/messages/registerDevice/"
//
//#define MESSAGE_SEND_SENDBOX                [HOST_DOMAIN_SENDBOX stringByAppendingString:@"sendMessage"]
//#define MESSAGE_QUERY_SENDBOX               [HOST_DOMAIN_SENDBOX stringByAppendingString:@"queryMessages"]
//#define MESSAGE_QUERY_WITH_FRIEND_SENDBOX   [HOST_DOMAIN_SENDBOX stringByAppendingString:@"queryMessagesWithFriend"]
//#define MESSAGE_FRIEND_ADD_SENDBOX          [HOST_DOMAIN_SENDBOX stringByAppendingString:@"addOneFriend"]
//#define MESSAGE_FRIEND_QUERY_SENDBOX        [HOST_DOMAIN_SENDBOX stringByAppendingString:@"queryAllFriend"]

#pragma mark -- DEVICE 
#define DEVICE_DOMAIN                       [HOST_DOMAIN stringByAppendingString:@"devices/"]
#define DEVICE_REGISTRATION                 [DEVICE_DOMAIN stringByAppendingString:@"registerUserDevice"]

#pragma mark -- RELATIONSHIP
#define RELATIONSHIP_DOMAIN                 [HOST_DOMAIN stringByAppendingString:@"connections/"]
#define RELATIONSHIP_FOLLOW                 [RELATIONSHIP_DOMAIN stringByAppendingString:@"follow"]
#define RELATIONSHIP_UNFOLLOW               [RELATIONSHIP_DOMAIN stringByAppendingString:@"unfollow"]
#define RELATIONSHIP_RELATION               [RELATIONSHIP_DOMAIN stringByAppendingString:@"queryRelationsBetweenUsers"]
#define RELATIONSHIP_QUERY_FOLLOWING        [RELATIONSHIP_DOMAIN stringByAppendingString:@"queryFollowingUsers"]
#define RELATIONSHIP_QUERY_FOLLOWED         [RELATIONSHIP_DOMAIN stringByAppendingString:@"queryFollowedUsers"]
#define RELATIONSHIP_QUERY_FRIENDS          [RELATIONSHIP_DOMAIN stringByAppendingString:@"queryMutureFollowingUsers"]
#define RELATIONSHIP_SMS_INVITATION         [RELATIONSHIP_DOMAIN stringByAppendingString:@"sentSMSInvitation"]

#pragma mark -- ROLETAGS
#define ROLETAGS_DOMAIN                     [HOST_DOMAIN stringByAppendingString:@"roletags/"]
#define ROLETAGS_QUERY_ROLETAGS             [ROLETAGS_DOMAIN stringByAppendingString:@"queryAllRoleTags"]
#define ROLETAGS_ADD_ROLETAGE               [ROLETAGS_DOMAIN stringByAppendingString:@"addRoleTag"]
#define ROLETAGS_RECOMMAND_ROLETAGS         [ROLETAGS_DOMAIN stringByAppendingString:@"queryRecommandRoleTags"]
#define ROLETAGS_PREVIEW_SEARCH             [ROLETAGS_DOMAIN stringByAppendingString:@"queryRoleTagPreViewWithRoleTag"]

#pragma mark -- EMAIL PRIVACY
#define EMAIL_DOMAIN                        [HOST_DOMAIN stringByAppendingString:@"email/"]
#define EMAIL_SENDPRIVACY                   [EMAIL_DOMAIN stringByAppendingString:@"sendPrivacy"]

#pragma mark -- database
#define LOCALDB_LOGIN                       @"loginData.sqlite"
#define LOCALDB_TAGSEARCH                   @"tagSearch.sqlite"
#define LOCALDB_QUERY                       @"quertData.sqlite"
#define LOCALDB_MESSAGEG_NOTIFICATION       @"notifyData.sqlite"
#define LOCALDB_TAG_QUERY                   @"tagQuery.sqlite"
#define LOCALDB_OWNER_QUERY                 @"ownerQuery.sqlite"
#define LOCALDB_OWNER_PUSH_QUERY            @"ownerPushQuery.sqlite"
#define LOCALDB_COLLECTION_QUERY            @"collectionQuery.sqlite"
#define LOCALDB_RELATIONSHIP                @"Relationship.sqlite"
#define LOCALDB_USERSETTING                 @"systemSetting.sqlite"
#define LOCALDB_FOUND_SEARCH                @"foundSearch.sqlite"
#define LOCALDB_TAG                         @"LocalTag.sqlite"
//#define LOCALDB_CHAT                      @"chatData.sqlite"
//#define LOCALDB_GROUP                     @"groupData.sqlite"