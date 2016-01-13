//
//  AreaTableCell.m
//  BabySharing
//
//  Created by Alfred Yang on 19/07/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "AreaTableCell.h"

#define PREFERRED_HEIGHT        44
#define LINE_MARGIN_LEFT        14
#define LINE_MARGIN_RIGHT       34
#define LINE_WIDTH              [UIScreen mainScreen].bounds.size.width - LINE_MARGIN_LEFT - LINE_MARGIN_RIGHT

@implementation AreaTableCell

@synthesize countryLabel = _countryLabel;
@synthesize codeLabel = _codeLabel;

- (void)awakeFromNib {
    // Initialization code
    CALayer* layer = [CALayer layer];
    layer.borderColor = [UIColor colorWithWhite:0.5922 alpha:0.25].CGColor;
    layer.borderWidth = 1.f;
    layer.frame = CGRectMake(LINE_MARGIN_LEFT, PREFERRED_HEIGHT - 1, LINE_WIDTH, 1);
    [self.layer addSublayer:layer];
    
    _codeLabel.textColor = [UIColor colorWithWhite:0.3508 alpha:1.f];
    _countryLabel.textColor = [UIColor colorWithWhite:0.3508 alpha:1.f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
