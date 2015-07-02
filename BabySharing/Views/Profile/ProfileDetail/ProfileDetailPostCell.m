//
//  ProfileDetailPostCell.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 14/06/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "ProfileDetailPostCell.h"

@interface ProfileDetailPostCell ()
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@end

@implementation ProfileDetailPostCell

@synthesize screenPhotoImgView = _screenPhotoImgView;
@synthesize nextBtn = _nextBtn;

- (void)awakeFromNib {
    // Initialization code
//    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
//    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
//    [_nextBtn setImage:[UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"Next2"] ofType:@"png"]] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
