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

#pragma mark -- HOST DOMAIN
#define HOST_DOMAIN                     @"http://www.altlys.com:9000/"
//#define HOST_DOMAIN                     @"http://192.168.1.102:9000/"
//#define HOST_DOMAIN_SENDBOX             @"http://192.168.1.105:9000/"

#pragma mark -- DOWNLOAD
#define ATT_DOWNLOAD_HOST                   [HOST_DOMAIN stringByAppendingString:@"query/downloadFile/"]

#pragma mark -- QUERY
#define QUERY_HOST_DOMAIN                   [HOST_DOMAIN stringByAppendingString:@"query/"]
#define QUERY_REFRESH_HOME                  @"queryHomeContent"
#define QUERY_COMMENTS                      @"queryComments"

#pragma mark -- AUTH
#define AUTH_HOST_DOMAIN                    [HOST_DOMAIN stringByAppendingString:@"login/"]
#define AUTH_WITH_PHONE                     @"authWithPhone"
#define AUTH_CONFIRM                        @"authConfirm"
#define AUTH_PWD                            @"authWithPwd"
#define AUTH_UPDATE_DETAILS                 @"authUpdateDetails"
#define AUTH_WITH_THIRD                     @"authWithThird"
#define AUTH_CREATE_WITH_PHONE              @"authCreateUserWithPhone"

#pragma mark -- POST
#define POST_HOST_DOMAIN                    [HOST_DOMAIN stringByAppendingString:@"post/"]

#define POST_CONTENT                        @"postContent"
#define POST_UPLOAD                         @"uploadFile"
#define POST_COMMENT                        @"postComment"
#define POST_LIKE                           @"postLike"

#pragma mark -- RPOFILE
#define PROFILE_HOST_DOMAIN                 [HOST_DOMAIN stringByAppendingString:@"profile/"]
#define PROFILE_UPDATE_DETAILS              @"updateProfile"
#define PROFILE_QUERY_DETAILS               @"userProfile"
#define PROFILE_QUERY_MULTIPLE              @"multipleUserProfile"

//#define PROFILE_HOST_DOMAIN_SENDBOX         [HOST_DOMAIN_SENDBOX stringByAppendingString:@"profile/"]


#pragma mark -- GROUPS
//#define GROUP_HOST_DOMAIN_SENDBOX           [HOST_DOMAIN_SENDBOX stringByAppendingString:@"group/"]
#define GROUP_HOST_DOMAIN                   [HOST_DOMAIN stringByAppendingString:@"group/"]
#define QUERY_GROUP                         @"queryGroups"
#define CREATE_SUB_GROUP                    @"createSubGroup"

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

#pragma mark -- database
#define LOCALDB_LOGIN                       @"loginData.sqlite"
#define LOCALDB_QUERY                       @"quertData.sqlite"
#define LOCALDB_GROUP                       @"groupData.sqlite"
#define LOCALDB_TAG_QUERY                   @"tagQuery.sqlite"
#define LOCALDB_RELATIONSHIP                @"Relationship.sqlite"
//#define LOCALDB_CHAT                      @"chatData.sqlite"