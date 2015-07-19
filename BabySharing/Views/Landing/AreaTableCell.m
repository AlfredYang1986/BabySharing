//
//  AreaTableCell.m
//  BabySharing
//
//  Created by Alfred Yang on 19/07/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "AreaTableCell.h"

@implementation AreaTableCell

@synthesize countryLabel = _countryLabel;
@synthesize codeLabel = _codeLabel;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
