//
//  ProfileDetailController.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 14/06/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileDetailController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) NSString* current_user_id;
@property (nonatomic, weak) NSString* current_auth_token;
@property (nonatomic, weak) NSString* query_user_id;
@property (nonatomic, weak) NSString* query_screen_photo;
@property (nonatomic, weak) NSString* query_screen_name;
@property (nonatomic)   NSInteger followers_count;
@property (nonatomic)   NSInteger followings_count;
@property (nonatomic)   NSInteger posts_count;
@end
