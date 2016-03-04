//
//  UserSearchController.h
//  BabySharing
//
//  Created by Alfred Yang on 9/12/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    UserSearchTypeMoreFriends,
    UserSearchTypeRoleTag,
} UserSearchType;

@class UserSearchModel;

@interface UserSearchController : UIViewController

@property (nonatomic) UserSearchType user_search_type;
@property (nonatomic, strong) NSString* role_tag;

@property (weak, nonatomic) UserSearchModel* um;
@end
