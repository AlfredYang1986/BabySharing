//
//  ProgressLayer.h
//  BabySharing
//
//  Created by monkeyheng on 16/2/29.
//  Copyright © 2016年 BM. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
@interface ProgressLayer : CALayer
// 只需要打点就可以了
- (void)addPointAtEnd;
//- (void)setPointWithTime:(CGFloat)time;
// 删除段落
- (void)deletePoint;
// 去到当前时间
- (CGFloat)getCurrentTime;

@end
