//
//  UserSearchCell.h
//  BabySharing
//
//  Created by Alfred Yang on 9/12/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UserSearchCellDelegate <NSObject>

- (void)didSelectedUserScreenPhoto:(NSString*)user_id;
- (void)didSelectedUserContentImages:(NSInteger)index andUserID:(NSString*)user_id;
@end

@interface UserSearchCell : UITableViewCell

@property (nonatomic, strong) NSString* user_id;
@property (nonatomic, weak) id<UserSearchCellDelegate> delegate;

+ (CGFloat)preferredHeight;

- (void)setUserHeaderWithScreenName:(NSString*)name roleTag:(NSString*)role_tag andScreenPhoto:(NSString*)photo;
- (void)setUserContentImages:(NSArray*)arr;
@end
