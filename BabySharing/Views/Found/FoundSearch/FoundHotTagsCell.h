//
//  FoundHotTagsCell.h
//  BabySharing
//
//  Created by Alfred Yang on 8/12/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoundHotTagsCell : UITableViewCell

@property (nonatomic) BOOL isDarkTheme;
@property (nonatomic, setter=setHiddenLine:) BOOL isHiddenSepline;
@property (nonatomic) CGFloat ver_margin;

+ (CGFloat)preferredHeight;
- (void)setHotTags:(NSArray*)arr;
- (void)setHotTagsTest:(NSArray*)arr;
@end
