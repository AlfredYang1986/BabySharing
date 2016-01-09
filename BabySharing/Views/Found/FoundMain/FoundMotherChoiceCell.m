//
//  FoundMotherChooiceCell.m
//  BabySharing
//
//  Created by Alfred Yang on 8/12/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import "FoundMotherChoiceCell.h"

@interface FoundMotherChoiceCell ()
@property (weak, nonatomic) IBOutlet UIImageView *mcIcon;

@end

@implementation FoundMotherChoiceCell

@synthesize mcIcon = _mcIcon;

+ (CGFloat)preferredHeight {
    return 46;
}

- (void)awakeFromNib {
    // Initialization code
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    
    _mcIcon.image = [UIImage imageNamed:[resourceBundle pathForResource:@"found_mother_chooice" ofType:@"png"]];
    
    UILabel* label = (UILabel*)[self viewWithTag:1];
    label.textColor = [UIColor colorWithWhite:0.5059 alpha:1.f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
