//
//  TagQueryCell.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 20/06/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QueryContent;

@interface TagQueryCell : UITableViewCell

@property (nonatomic, strong, setter=setRangeContent:) NSArray* range_content;

+ (CGFloat)getPreferHeight;
+ (NSInteger)getRowItemCount;

- (void)setRangeContent:(NSArray*)contents;
@end
