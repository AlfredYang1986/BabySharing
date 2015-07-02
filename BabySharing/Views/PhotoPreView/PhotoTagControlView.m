//
//  PhotoTagControlView.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 12/06/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "PhotoTagControlView.h"

@interface PhotoTagControlView ()

@end

@implementation PhotoTagControlView

@synthesize hitLabel = _hitLabel;

- (void)awakeFromNib {
    NSLog(@"awake from nib with photo preview edit view");
    /**
     * init self rect
     */
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    self.bounds = CGRectMake(0, 0, width, width / 2);
    self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    
    /**
     * init sub views
     */
    _hitLabel = [[UILabel alloc]init];
    _hitLabel.text = @"Click Hit";
    [self addSubview:_hitLabel];

    
    /**
     * init control views
     */
    // TODO: ...
}

- (void)layoutSubviews {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = width / 2;
    _hitLabel.center = CGPointMake(width / 2, height / 2);
}

- (void)layoutMySelf {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat screen_height = [UIScreen mainScreen].bounds.size.height;
    CGFloat height = width / 2;
   
    self.frame = CGRectMake(0, screen_height - height, width, height);
}
@end
