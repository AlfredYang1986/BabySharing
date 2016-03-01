//
//  ProgressLayer.m
//  BabySharing
//
//  Created by monkeyheng on 16/2/29.
//  Copyright © 2016年 BM. All rights reserved.
//

#import "ProgressLayer.h"
#import <UIKit/UIColor.h>
#import "Pointlayer.h"

#define POINT_WIDTH     2

@implementation ProgressLayer
{
    NSMutableArray<PointLayer *> *pointArr;
    CGFloat currentTime;
}

- (void)dealloc {
    for (CALayer* iter in pointArr) {
        [iter removeFromSuperlayer];
    }
}

- (void)addPointAtEnd {
    PointLayer *pointLayer = [PointLayer layer];
    pointLayer.time = currentTime;
    pointLayer.backgroundColor = [UIColor redColor].CGColor;
    pointLayer.frame = CGRectMake(CGRectGetWidth(self.frame) - POINT_WIDTH, self.frame.origin.y, POINT_WIDTH, CGRectGetHeight(self.frame));

    if (pointArr == nil) {
        pointArr = [NSMutableArray array];
    }
    [pointArr addObject:pointLayer];
    [self.superlayer addSublayer:pointLayer];
}

- (void)layoutSublayers {
    [super layoutSublayers];
    for (CALayer* iter in self.sublayers) {
        iter.zPosition = 1;
    }
}

- (void)deletePoint {
    if (pointArr.count > 0) {
        PointLayer *currentLayer = [pointArr lastObject];
        [currentLayer removeFromSuperlayer];
        [pointArr removeObject:currentLayer];

        currentLayer = pointArr.lastObject;
        currentTime = currentLayer.time;
        // 加入动画
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, currentLayer.frame.origin.x, self.frame.size.height);
    } else {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, 0, self.frame.size.height);
        currentTime = 0;
    }
}

- (CGFloat)getCurrentTime {
    return currentTime;
}

@end
