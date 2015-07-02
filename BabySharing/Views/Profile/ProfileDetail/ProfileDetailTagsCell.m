//
//  ProfileDetailTagsCell.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 15/06/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "ProfileDetailTagsCell.h"

@interface ProfileDetailTagsCell ()
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@end

@implementation ProfileDetailTagsCell

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

- (IBAction)didSelectNextBtn {
    
}
@end
