//
//  FoundPCGCell.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 6/06/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "FoundPCGCell.h"

@interface FoundPCGCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation FoundPCGCell

@synthesize imgView = _imgView;

- (void)awakeFromNib {
    // Initialization code

    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    NSString * filePath = [resourceBundle pathForResource:[NSString stringWithFormat:@"RecommondUser"] ofType:@"png"];
    
    _imgView.contentMode = UIViewContentModeScaleToFill;
    _imgView.image = [UIImage imageNamed:filePath];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)preferdHeight {
    return 144;
}

@end
