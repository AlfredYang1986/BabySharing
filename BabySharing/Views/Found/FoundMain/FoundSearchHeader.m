//
//  FoundSearchHeader.m
//  BabySharing
//
//  Created by Alfred Yang on 8/12/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import "FoundSearchHeader.h"
#import "Define.h"
@implementation FoundSearchHeader
//@synthesize headLabell = _headLabell;
//@synthesize headImg = _headImg;
- (void)awakeFromNib {
    [super awakeFromNib];
    _headLabell.textColor = [UIColor colorWithRed:70.0 / 255.0 green:219.0 / 255.0 blue:202.0 / 255.0 alpha:1.0];
}

+ (CGFloat)prefferredHeight {
    return 44;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (_headImg.image == nil) {
        _headLabell.frame = CGRectMake(14.5 + 14 + 10.5, _headLabell.frame.origin.y + 3, _headLabell.frame.size.width + 20, _headLabell.frame.size.height + 7);
        _headLabell.font = [UIFont systemFontOfSize:14];
        //        _headLabell.center = CGPointMake(_headLabell.center.x, 44 / 2);
        _headLabell.center = CGPointMake(CGRectGetWidth(self.frame) / 2 - (CGRectGetWidth(self.frame) / 2 + 2 - (_headLabell.frame.size.width + 20) / 2), CGRectGetHeight(self.frame) / 2);
//        _headLabell.textColor = [UIColor colorWithRed:70.0 / 255.0 green:219.0 / 255.0 blue:202.0 / 255.0 alpha:1.0];
        _headLabell.textColor = TextColor;
        _headLabell.textAlignment = NSTextAlignmentCenter;
    } else {
        _headImg.frame = CGRectMake(14.5, _headLabell.frame.origin.y, 14, 14);
        _headImg.center = CGPointMake(_headImg.center.x, 44 / 2);
        _headLabell.font = [UIFont systemFontOfSize:14];
        _headLabell.frame = CGRectMake(14.5 + 14 + 10.5, _headLabell.frame.origin.y, _headLabell.frame.size.width + 20, _headLabell.frame.size.height + 10);
//        _headLabell.center = CGPointMake(_headLabell.center.x, 44 / 2);
//        _headLabell.center = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2 + 7);
        _headLabell.center = CGPointMake(CGRectGetWidth(self.frame) / 2 - (CGRectGetWidth(self.frame) / 2 + 2 -(_headLabell.frame.size.width + 20) / 2), CGRectGetHeight(self.frame) / 2);
    }
    
//    if (self.line == nil) {
//        self.line = [[UIView alloc] init];
//        self.line.backgroundColor = UpLineColor;
//        [self addSubview:self.line];
//    }
    
    self.line.frame = CGRectMake(0, CGRectGetMaxY(self.frame), CGRectGetWidth(self.frame), 1);
    
    if (self.line1 == nil) {
        self.line1 = [[UIView alloc] init];
        self.line1.backgroundColor = DownLineColor;
        [self addSubview:self.line1];
    }
    self.line1.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), 1);
}
@end
