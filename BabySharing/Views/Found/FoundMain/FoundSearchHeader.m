//
//  FoundSearchHeader.m
//  BabySharing
//
//  Created by Alfred Yang on 8/12/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import "FoundSearchHeader.h"

@implementation FoundSearchHeader

//@synthesize headLabell = _headLabell;
//@synthesize headImg = _headImg;


- (void)awakeFromNib {
    [super awakeFromNib];
//    _headLabell.layer.borderColor = [UIColor colorWithRed:70.0 / 255.0 green:219.0 / 255.0 blue:202.0 / 255.0 alpha:1.0].CGColor;
    _headLabell.textColor = [UIColor colorWithRed:70.0 / 255.0 green:219.0 / 255.0 blue:202.0 / 255.0 alpha:1.0];
//    _headLabell.layer.borderWidth = 1;
//    _headLabell.layer.cornerRadius = 5;
}

+ (CGFloat)prefferredHeight {
    return 44;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (_headImg.image == nil) {
//        _headLabell.frame = CGRectMake(14.5, _headLabell.frame.origin.y, _headLabell.frame.size.width, _headLabell.frame.size.height);
//        _headLabell.center = CGPointMake(_headLabell.center.x, 44 / 2);
        _headLabell.frame = CGRectMake(14.5 + 14 + 10.5, _headLabell.frame.origin.y, _headLabell.frame.size.width + 20, _headLabell.frame.size.height + 10);
        //        _headLabell.center = CGPointMake(_headLabell.center.x, 44 / 2);
        _headLabell.center = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2);
        _headLabell.textColor = [UIColor colorWithRed:70.0 / 255.0 green:219.0 / 255.0 blue:202.0 / 255.0 alpha:1.0];
        _headLabell.textAlignment = NSTextAlignmentCenter;
    } else {
        _headImg.frame = CGRectMake(14.5, _headLabell.frame.origin.y, 14, 14);
        _headImg.center = CGPointMake(_headImg.center.x, 44 / 2);
        _headLabell.frame = CGRectMake(14.5 + 14 + 10.5, _headLabell.frame.origin.y, _headLabell.frame.size.width + 20, _headLabell.frame.size.height + 10);
//        _headLabell.center = CGPointMake(_headLabell.center.x, 44 / 2);
        _headLabell.center = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2);
    }
}
@end
