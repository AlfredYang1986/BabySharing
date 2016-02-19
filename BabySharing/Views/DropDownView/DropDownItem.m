//
//  DropDownItem.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 4/01/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "DropDownItem.h"

@interface DropDownItem()

@property (nonatomic, strong) UIImageView *albumImage;
@property (nonatomic, strong) UILabel *albumTitle;

@end

@implementation DropDownItem

@synthesize group = _group;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.albumImage = [[UIImageView alloc] init];
        self.albumTitle = [[UILabel alloc] init];
        [self.contentView addSubview:self.albumImage];
        [self.contentView addSubview: self.albumTitle];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.albumImage.frame = CGRectMake(10, 10, CGRectGetHeight(self.contentView.frame) - 20, CGRectGetHeight(self.contentView.frame) - 20);
    self.albumTitle.center = CGPointMake(CGRectGetHeight(self.contentView.frame) + CGRectGetWidth(self.albumTitle.frame) / 2, CGRectGetHeight(self.contentView.frame) / 2);
}

- (void)setGroup:(ALAssetsGroup *)group {
    _group = group;
    [self.albumImage setImage:[UIImage imageWithCGImage:group.posterImage]];
    self.albumTitle.text = [NSString stringWithFormat:@"%@ %ld", [group valueForProperty:ALAssetsGroupPropertyName], (long)[group numberOfAssets]];
    [self.albumTitle sizeToFit];
}

@end
