//
//  ChatViewOwnerCell.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 9/06/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "ChatViewOwnerCell.h"

@implementation ChatViewOwnerCell

@synthesize imgView = _imgView;
@synthesize textContentLabel = _textContentLabel;

- (void)awakeFromNib {
    // Initialization code
    self.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)downloadImg:(UIImage *)image {
    _imgView.image = image;
}

- (void)changeContent:(NSString *)content {
    _textContentLabel.text = content;
}
@end
