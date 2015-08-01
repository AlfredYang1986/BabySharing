//
//  ProfileOverView.h
//  BabySharing
//
//  Created by Alfred Yang on 1/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileOverView : UITableViewHeaderFooterView

- (void)setOwnerPhoto:(NSString*)photo_name;
- (void)setShareCount:(NSInteger)count;
- (void)setCycleCount:(NSInteger)count;
- (void)setFriendsCount:(NSInteger)count;
- (void)setLoation:(NSString*)location;
- (void)setPersonalSign:(NSString*)sign_content;
- (void)setRoleTag:(NSString*)role_tag;
@end
