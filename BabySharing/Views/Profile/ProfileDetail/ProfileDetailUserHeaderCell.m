//
//  ProfileDetailUserheaderCell.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 14/06/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "ProfileDetailUserHeaderCell.h"

@interface ProfileDetailUserHeaderCell ()

@end

@implementation ProfileDetailUserHeaderCell

@synthesize userBackgroudView = _userBackgroudView;
@synthesize thumsupNumLabel = _thumsupNumLabel;
@synthesize pushNumLabel = _pushNumLabel;
@synthesize friendNumLabel = _friendNumLabel;

- (void)awakeFromNib {
    // Initialization code
    _userBackgroudView.layer.borderColor = [UIColor colorWithWhite:0.f alpha:0.8].CGColor;
    _userBackgroudView.layer.borderWidth = 2.f;
    _userBackgroudView.layer.cornerRadius = 8.f;
    [_userBackgroudView clipsToBounds];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
