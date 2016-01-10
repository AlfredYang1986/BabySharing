//
//  UserSearchCell.h
//  BabySharing
//
//  Created by Alfred Yang on 9/12/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserSearchCell : UITableViewCell

+ (CGFloat)preferredHeight;

- (void)setUserHeaderWithScreenName:(NSString*)name roleTag:(NSString*)role_tag andScreenPhoto:(NSString*)photo;
- (void)setUserContentImages:(NSArray*)arr;
@end
