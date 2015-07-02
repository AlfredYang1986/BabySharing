//
//  QueryOwnerCell.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 12/01/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "QueryOwnerCell.h"

@implementation QueryOwnerCell

@synthesize owner_img = _owner_img;
@synthesize owner_name = _owner_name;
@synthesize owner_tags = _owner_tags;
@synthesize content_share_number = _content_share_number;

@synthesize owner_id = _owner_id;
@synthesize delegate = _delegate;

- (void)awakeFromNib {
    // Initialization code
    _owner_img.userInteractionEnabled = YES;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didSelectImageOrName:)];
    [_owner_img addGestureRecognizer:tap];

    _owner_name.userInteractionEnabled = YES;
    UITapGestureRecognizer* tap_2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didSelectImageOrName:)];
    [_owner_name addGestureRecognizer:tap_2];
}

+ (CGFloat)preferHeight {
    return 46;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)didSelectFollowBtn {
    [_delegate didSelectDetialFollowOwner];
}

- (void)didSelectImageOrName:(UITapGestureRecognizer*)sender {
    [_delegate didSelectDetialOwnerNameOrImage:_owner_id];
}

@end
