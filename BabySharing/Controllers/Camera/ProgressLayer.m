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

@implementation ProgressLayer
{
    NSMutableArray<PointLayer *> *pointArr;
    CGFloat currentTime;
}


- (void)setPointWithTime:(CGFloat)time {
    PointLayer *pointLayer = [[PointLayer alloc] init];
    pointLayer.time = time;
    pointLayer.backgroundColor = [UIColor redColor].CGColor;
    pointLayer.frame = CGRectMake(CGRectGetWidth(self.frame), 0, 2, CGRectGetHeight(self.frame));
//    pointLayer.frame = CGRectMake(0, 0, 2, CGRectGetHeight(self.frame) + 10);

    if (pointArr == nil) {
        pointArr = [NSMutableArray array];
    }
    [pointArr addObject:pointLayer];
    [self addSublayer:pointLayer];
}

- (void)deletePoint {
    if (pointArr == nil) {
        return;
    }
    
    if (pointArr.count > 0) {
        PointLayer *currentLayer = [pointArr lastObject];
        [currentLayer removeFromSuperlayer];
        currentTime = currentLayer.time;
        // 加入动画
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, currentLayer.frame.origin.x - 2, self.frame.size.height);
        [pointArr removeLastObject];
    } else {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, 0, self.frame.size.height);
        currentTime = 0;
    }
}

- (CGFloat)getCurrentTime {
    return currentTime;
}

@end
