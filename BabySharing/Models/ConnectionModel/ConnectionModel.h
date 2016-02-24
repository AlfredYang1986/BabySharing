//
//  ConnectionModel.h
//  BabySharing
//
//  Created by Alfred Yang on 5/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ModelDefines.h"

@class AppDelegate;

//typedef void(^followFinishBlock)(BOOL success, NSString* message);
typedef void(^followFinishBlock)(BOOL success, NSString* message, UserPostOwnerConnections new_relations);
typedef void(^queryFinishBlock)(BOOL success);
typedef void(^queryRelationShip)(NSInteger relations);

@interface ConnectionModel : NSObject

@property (strong, nonatomic) UIManagedDocument* doc;
@property (strong, nonatomic) NSArray* querydata;
@property (weak, nonatomic, readonly) AppDelegate* delegate;

#pragma mark -- constractor
- (id)initWithDelegate:(AppDelegate*)app;

#pragma mark -- follow and unfollow
- (void)followOneUser:(NSString*)follow_user_id withFinishBlock:(followFinishBlock)block;
- (void)unfollowOneUser:(NSString*)follow_user_id withFinishBlock:(followFinishBlock)block;

#pragma mark -- query connections from server
- (void)queryFollowingWithUser:(NSString*)owner_id andFinishBlock:(queryFinishBlock)block;
- (void)queryFollowedWithUser:(NSString*)owner_id andFinishBlock:(queryFinishBlock)block;
- (void)queryFriendsWithUser:(NSString*)owner_id andFinishBlock:(queryFinishBlock)block;

#pragma mark -- query connections from local
- (NSArray*)queryLocalFollowingWithUser:(NSString*)owner_id;
- (NSArray*)queryLocalFollowedWithUser:(NSString*)owner_id;
- (NSArray*)queryLocalFriendsWithUser:(NSString*)owner_id;


@end
