//
//  ProfileUserHeaderCell.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 14/06/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProfileUserHeaderProtocol <NSObject>
- (void)didSelectDetailProfileBtn;
@end

@interface ProfileUserHeaderCell : UITableViewCell
@property (nonatomic, weak) id<ProfileUserHeaderProtocol> delegate;
@property (nonatomic, weak) NSString* current_user_id;
@property (nonatomic, weak) NSString* current_auth_token;

- (void)updateHeaderView;
@end