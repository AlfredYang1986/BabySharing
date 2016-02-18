//
//  FoundHotTagsCell.h
//  BabySharing
//
//  Created by Alfred Yang on 8/12/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FoundHotTagsCellDelegate <NSObject>
- (void)recommandTagBtnSelected:(NSString*)tag_name adnType:(NSInteger)tag_type;
- (void)recommandRoleTagBtnSelected:(NSString*)tag_name;
@end

@interface FoundHotTagsCell : UITableViewCell

@property (nonatomic) BOOL isDarkTheme;
@property (nonatomic, setter=setHiddenLine:) BOOL isHiddenSepline;
@property (nonatomic) CGFloat ver_margin;

@property (nonatomic, weak) id<FoundHotTagsCellDelegate> delegate;

+ (CGFloat)preferredHeight;
- (void)setHotTags:(NSArray*)arr;
- (void)setHotTagsTest:(NSArray*)arr;
@end
