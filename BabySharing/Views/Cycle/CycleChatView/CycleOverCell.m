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
    NSString * filepath = [resourceBundle pathForResource:@"GroupImg" ofType:@"png"];
   
    _themeImg.image = [UIImage imageNamed:filepath];
    _themeImg.layer.borderColor = [UIColor redColor].CGColor;
    _themeImg.layer.borderWidth = 2.f;
    _themeImg.layer.cornerRadius = 25.f;
    _themeImg.clipsToBounds = YES;
    
    [_timeBtn setImage:[UIImage imageNamed:[resourceBundle pathForResource:@"Time_Publish" ofType:@"png"]] forState:UIControlStateNormal];
    [_timeBtn setTitle:@"一年" forState:UIControlStateNormal];
    [_timeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_locationBtn setImage:[UIImage imageNamed:[resourceBundle pathForResource:@"Location_Publish" ofType:@"png"]] forState:UIControlStateNormal];
    [_locationBtn setTitle:@"北京" forState:UIControlStateNormal];
    [_locationBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_tagBtn setImage:[UIImage imageNamed:[resourceBundle pathForResource:@"Tag_Publish" ofType:@"png"]] forState:UIControlStateNormal];
    [_tagBtn setTitle:@"购物" forState:UIControlStateNormal];
    [_tagBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    _numLabel.backgroundColor = [UIColor colorWithRed:0.3126 green:0.7529 blue:0.6941 alpha:1.f];
    _numLabel.layer.cornerRadius = 10.5;
    _numLabel.clipsToBounds = YES;
    _numLabel.textColor = [UIColor whiteColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
