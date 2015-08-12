//
//  MyCycleCellHeader.m
//  BabySharing
//
//  Created by Alfred Yang on 12/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "MyCycleCellHeader.h"

#define MRAGIN      8

@implementation MyCycleCellHeader {
}

@synthesize role_tag = _role_tag;

+ (CGFloat)preferHeight {
    return 44;
}

- (void)viewLayoutSubviews {
    CGFloat offset = MRAGIN;
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(MRAGIN, 0, 100, 44)];
    label.text = @"我的圈子";
    [self addSubview:label];
   
    offset += MRAGIN + 100;
    UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(offset, MRAGIN, 80, 44 - MRAGIN * 2)];
    btn.layer.borderColor = [UIColor blueColor].CGColor;
    btn.layer.borderWidth = 1.f;
    btn.layer.cornerRadius = 8.f;
    btn.clipsToBounds = YES;
    
    [btn setTitle:_role_tag forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self addSubview:btn];
}
@end
