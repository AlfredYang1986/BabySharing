//
//  CycleOverCell.m
//  BabySharing
//
//  Created by Alfred Yang on 18/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "CycleOverCell.h"

@interface CycleOverCell ()
@property (weak, nonatomic) IBOutlet UIButton *timeBtn;
@property (weak, nonatomic) IBOutlet UIButton *locationBtn;
@property (weak, nonatomic) IBOutlet UIButton *tagBtn;
@end

@implementation CycleOverCell

@synthesize numLabel = _numLabel;
@synthesize timeBtn = _timeBtn;
@synthesize locationBtn = _locationBtn;
@synthesize tagBtn = _tagBtn;
@synthesize themeLabel = _themeLabel;
@synthesize themeImg = _themeImg;

+ (CGFloat)preferredHeight {
    return 66;
}

- (void)awakeFromNib {
    // Initialization code
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    [_timeBtn setImage:[UIImage imageNamed:[resourceBundle pathForResource:@"Time" ofType:@"png"]] forState:UIControlStateNormal];
    [_timeBtn setTitle:@"时间" forState:UIControlStateNormal];
    [_locationBtn setImage:[UIImage imageNamed:[resourceBundle pathForResource:@"Location" ofType:@"png"]] forState:UIControlStateNormal];
    [_locationBtn setTitle:@"地点" forState:UIControlStateNormal];
    [_tagBtn setImage:[UIImage imageNamed:[resourceBundle pathForResource:@"Tag" ofType:@"png"]] forState:UIControlStateNormal];
    [_tagBtn setTitle:@"标签" forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
