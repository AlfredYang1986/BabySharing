//
//  UserSearchModel.h
//  BabySharing
//
//  Created by Alfred Yang on 15/12/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelDefines.h"

@class AppDelegate;

typedef void(^userSearchFinishBlock)(BOOL success, NSArray* result);
typedef void(^userSearchPostFinishBlock)(BOOL success, NSDictionary* result);

@interface UserSearchModel : NSObject

@property (weak, nonatomic) AppDelegate* delegate;
@property (strong, nonatomic) NSArray* userSearchPreviewResult;
@property (strong, nonatomic) NSArray* lastSearchScreenNameResult;

- (id)initWithDelegate:(AppDelegate*)delegate;

- (void)queryUserSearchWithFinishBlock:(userSearchFinishBlock)block;
- (void)queryUserSearchWithRoleTag:(NSString*)role_tag andFinishBlock:(userSearchFinishBlock)block;
- (void)queryUserSearchWithScreenName:(NSString*)screen_name andFinishBlock:(userSearchPostFinishBlock)block;

- (BOOL)changeRelationsInMemory:(NSString*)user_id andConnections:(UserPostOwnerConnections)connections;
@end
