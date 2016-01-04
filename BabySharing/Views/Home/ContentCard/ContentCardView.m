//
//  ContentCardView.m
//  BabySharing
//
//  Created by Alfred Yang on 28/11/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import "ContentCardView.h"
#import "QueryHeader.h"

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
    UINib* nib = [UINib nibWithNibName:@"QueryCell" bundle:[NSBundle mainBundle]];
    [_queryView registerNib:nib forCellReuseIdentifier:@"query cell"];
    [_queryView registerClass:[QueryHeader class] forHeaderFooterViewReuseIdentifier:@"query header"];
    _queryView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _queryView.scrollEnabled = NO;
    
//    _queryView.delegate = datasource;
//    _queryView.dataSource = datasource;
    
//    _queryView._shadow.borderColor = [UIColor lightGrayColor].CGColor;
//    _queryView._shadow.borderWidth = 1.f;
    _queryView.layer.cornerRadius = 8.f;
    _queryView.clipsToBounds = NO;
   
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    NSString* filepath = [resourceBundle pathForResource:@"home-card-bg" ofType:@"png"];
    UIImage* img = [UIImage imageNamed:filepath];
    
    _shadow = [CALayer layer];
//    _shadow.frame = CGRectMake(-4, -4, _queryView.frame.size.width + 8, _queryView.frame.size.height + 8);
    _shadow.contents = (id)img.CGImage;
    [_queryView.layer addSublayer:_shadow];
    
    for (UIView* a in _queryView.subviews) {
        [_queryView bringSubviewToFront:a];
    }
    
    [self bringSubviewToFront:_queryView];
    
    [UIView setAnimationsEnabled:NO];
    
    self.backgroundColor = [UIColor lightGrayColor];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _shadow.frame = CGRectMake(-4, -4, _queryView.frame.size.width + 8, _queryView.frame.size.height + 8);
    [CATransaction commit];
//    _shadow.frame = self.bounds;
}
@end
