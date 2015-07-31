//
//  QueryDescriptionCellTableViewCell.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 5/06/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QueryDescriptionCell : UITableViewCell

+ (CGFloat)preferHeightWithUserDescription:(NSString*)description;

- (void)setTime:(NSDate*)date;
- (void)setTags:(NSString*)tags;
- (void)setDescription:(NSString*)description;
@end
