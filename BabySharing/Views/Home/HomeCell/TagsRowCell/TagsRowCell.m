//
//  TagsRowCell.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 6/06/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "TagsRowCell.h"
#define ROW_ITEM_COUNT      4

@implementation TagsRowCell {
    NSArray* imgs;
    
    CGFloat step_width;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)preferdHeight {
    return 70;
}

- (void)setRowShowingTags {
    step_width = [UIScreen mainScreen].bounds.size.width / ROW_ITEM_COUNT;
}
@end
