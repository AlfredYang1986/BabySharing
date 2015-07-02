//
//  CommentsHeaderAndFooterCell.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 12/01/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "CommentsHeaderAndFooterCell.h"

@implementation CommentsHeaderAndFooterCell

@synthesize messageLabel = _messageLabel;
@synthesize delegate = _delegate;
@synthesize state = _state;

- (void)awakeFromNib {
    // Initialization code
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didSelectHeaderAndFooter:)];
    [self addGestureRecognizer:tap];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
    [super setSelected:NO animated:animated];

    // Configure the view for the selected state
}

- (void)didSelectHeaderAndFooter:(UITapGestureRecognizer*)sender {
    if (_state == CommentsHeaderAndFooterStatesFooter) {
        [_delegate didSelectDetialMoreComments];
    }
}
@end
