//
//  UserSearchModel.h
//  BabySharing
//
//  Created by Alfred Yang on 15/12/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AppDelegate;

typedef void(^userSearchFinishBlock)(BOOL success, NSArray* result);

@interface UserSearchModel : NSObject

@property (weak, nonatomic) AppDelegate* delegate;
@property (strong, nonatomic) NSArray* userSearchResult;

- (id)initWithDelegate:(AppDelegate*)delegate;

- (void)queryUserSearchWithFinishBlock:(userSearchFinishBlock)block;
- (void)queryUserSearchWithRoleTag:(NSString*)role_tag andFinishBlock:(userSearchFinishBlock)block;
@end
