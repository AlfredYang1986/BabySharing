//
//  QueryDescriptionCellTableViewCell.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 5/06/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "QueryDescriptionCell.h"

@implementation QueryDescriptionCell

@synthesize user_description = _user_description;
@synthesize content_tags = _content_tags;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)preferHeight {
    return 52;
}
@end
