//
//  QueryOwnerCell.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 12/01/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QueryDetailActionDelegate.h"
#import "ModelDefines.h"

@class DongDaFollowBtn;

@interface QueryOwnerCell : UITableViewCell
@property (nonatomic, strong) UIImageView* userImg;
@property (nonatomic, strong) UIButton* userRoleTagBtn;
@property (nonatomic, strong) UILabel* userNameLabel;
//@property (nonatomic, strong) UIButton* followBtn;
@property (nonatomic, strong) DongDaFollowBtn* followBtn;

@property (nonatomic, strong) UILabel* tagLabel;

@property (weak, nonatomic) NSString* owner_id;
@property (weak, nonatomic) id<QueryDetailActionDelegate> delegate;

+ (CGFloat)preferHeight;

- (void)setUserPhoto:(NSString*)photo_name;
- (void)setUserName:(NSString*)name;
- (void)setTagText:(NSString*)location;
- (void)setRoleTag:(NSString*)role_tag;
- (void)setConnections:(UserPostOwnerConnections)relations;
@end
