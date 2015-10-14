//
//  CycleAddConditionCell.m
//  BabySharing
//
//  Created by Alfred Yang on 14/10/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import "CycleAddConditionCell.h"

@interface CycleAddConditionCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation CycleAddConditionCell

@synthesize titleLabel = _titleLabel;
@synthesize contentLabel = _contentLabel;

+ (CGFloat)prefferredHeight {
    return 66;
}

- (void)awakeFromNib {
    // Initialization code
    _titleLabel.textColor = [UIColor grayColor];
    _contentLabel.textColor = [UIColor colorWithRed:0.3126 green:0.7529 blue:0.6941 alpha:1.f];
    _contentLabel.font = [UIFont boldSystemFontOfSize:17.f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTitle:(NSString*)title {
    _titleLabel.text = title;
    [_titleLabel sizeToFit];
}

- (void)setContent:(NSString*)content {
    _contentLabel.text = content;
    [_contentLabel sizeToFit];
}
@end
