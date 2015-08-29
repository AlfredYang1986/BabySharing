//
//  PersonalSettingCell.h
//  BabySharing
//
//  Created by Alfred Yang on 29/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalSettingCell : UITableViewCell

+ (CGFloat)preferredHeightWithImage:(BOOL)bImg;

- (void)changeCellTitile:(NSString*)title;
- (void)changeCellContent:(NSString*)content;
- (void)changeCellImage:(NSString*)image_name;
@end
