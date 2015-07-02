//
//  ProfileDetailSNCell.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 19/06/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "ProfileDetailSNCell.h"

#define IMG_WIDTH   30
#define IMG_HEIGHT  IMG_WIDTH
#define IMG_MARGIN  3

@interface ProfileDetailSNCell ()
@property (weak, nonatomic) IBOutlet UIView *imgContainer;

@end

@implementation ProfileDetailSNCell {
    CGFloat offset;
}

@synthesize imgContainer = _imgContainer;

- (void)awakeFromNib {
    // Initialization code
    offset = IMG_MARGIN;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)addSNImage:(UIImage*)img {
    UIImageView* tmp = [[UIImageView alloc]initWithFrame:CGRectMake(offset, 0, IMG_WIDTH, IMG_HEIGHT)];
    
    tmp.image = img;
    tmp.contentMode = UIViewContentModeScaleToFill;
    
    [_imgContainer addSubview:tmp];
    
    offset += IMG_WIDTH + IMG_MARGIN;
}

- (void)resetSNImage:(UIImage*)img {
    
    for (UIView* tmp in _imgContainer.subviews) {
        [tmp removeFromSuperview];
    }
    offset = IMG_MARGIN;
    
    UIImageView* tmp = [[UIImageView alloc]initWithFrame:CGRectMake(offset, 0, IMG_WIDTH, IMG_HEIGHT)];
    
    tmp.image = img;
    tmp.contentMode = UIViewContentModeScaleToFill;
    
    [_imgContainer addSubview:tmp];
    
    offset += IMG_WIDTH + IMG_MARGIN;
}
@end
