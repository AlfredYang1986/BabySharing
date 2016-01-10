//
//  FountMoreFriendCell.h
//  BabySharing
//
//  Created by Alfred Yang on 7/12/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoundMoreFriendCell : UITableViewCell

@property (nonatomic, setter=setHiddenIcon:) BOOL isHiddenIcon;
@property (nonatomic) BOOL isHiddenSep;
@property (nonatomic, weak, setter=setDes:) NSString* des;

+ (CGFloat)preferredHeight;

- (void)setUserImages:(NSArray*)img_arr;
@end
