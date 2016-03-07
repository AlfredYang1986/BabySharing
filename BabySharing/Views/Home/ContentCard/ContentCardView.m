//
//  ContentCardView.m
//  BabySharing
//
//  Created by Alfred Yang on 28/11/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import "ContentCardView.h"
#import "QueryHeader.h"
#import "QueryCell.h"

@implementation ContentCardView {
}

@synthesize queryView = _queryView;
@synthesize shadow = _shadow;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    _queryView = [[UITableView alloc]init];
    [self addSubview:_queryView];
    
    UINib* nib = [UINib nibWithNibName:@"QueryCell" bundle:[NSBundle mainBundle]];
    [_queryView registerNib:nib forCellReuseIdentifier:@"query cell"];
    [_queryView registerClass:[QueryHeader class] forHeaderFooterViewReuseIdentifier:@"query header"];
    _queryView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _queryView.scrollEnabled = NO;

    _queryView.layer.cornerRadius = 8.f;
    _queryView.clipsToBounds = NO;
   
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    NSString* filepath = [resourceBundle pathForResource:@"home_card_bg" ofType:@"png"];
    UIImage* img = [UIImage imageNamed:filepath];
    
    _shadow = [CALayer layer];
    _shadow.contents = (id)img.CGImage;
    [self.layer addSublayer:_shadow];
    
    [self bringSubviewToFront:_queryView];
    
    [UIView setAnimationsEnabled:NO];
    
    self.backgroundColor = [UIColor colorWithRed:0.9529 green:0.9529 blue:0.9529 alpha:1.f];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
  
    CGFloat h = [QueryHeader preferredHeight] + [QueryCell preferredHeightWithDescription:@"Any word"];
    CGFloat w = [UIScreen mainScreen].bounds.size.width - 21 - 8;
    _queryView.frame = CGRectMake(4, 4, w, h);
    _queryView.clipsToBounds = YES;
    
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _shadow.frame = CGRectMake(0, 0, w + 8, h + 8);
    [CATransaction commit];
}
@end
