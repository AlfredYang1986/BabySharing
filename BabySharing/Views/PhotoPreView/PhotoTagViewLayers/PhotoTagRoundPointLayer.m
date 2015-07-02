//
//  PhotoTagRoundPointLayer.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 13/06/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "PhotoTagRoundPointLayer.h"
#import <UIKit/UIKit.h>

@implementation PhotoTagRoundPointLayer

- (id)init{
    self = [super init];
    if (self) {
//        self.backgroundColor = [UIColor colorWithWhite:0.f alpha:1.0].CGColor;
    }
    
    return self;
}

//重写该方法，在该方法内绘制图形
-(void)drawInContext:(CGContextRef)ctx {
    CGRect rect = [self getPreferRect];
    CGContextClearRect(ctx, rect);
    
    CGContextSaveGState(ctx);
    
    CGContextAddEllipseInRect(ctx, rect);
    CGContextSetRGBFillColor(ctx, 0, 0, 0, 0.6);  // 白色画一个圆圈
    CGContextFillPath(ctx);
   
    CGFloat step = 1.f / sqrt(2.0);
    CGContextAddEllipseInRect(ctx, CGRectMake(rect.size.width * ( 1.f - step) / 2, rect.size.width * ( 1.f - step)/ 2, rect.size.width * step, rect.size.height * step));
    CGContextSetRGBFillColor(ctx, 1, 1, 1, 1);  // 黑色画一个圆圈
    CGContextFillPath(ctx);

//    CGContextAddEllipseInRect(ctx, CGRectMake(rect.size.width * ( 1.f / 2 - step * step), rect.size.width * ( 1.f / 2 - step * step), rect.size.width * step * step, rect.size.height * step * step));
//    CGContextSetRGBFillColor(ctx, 1, 1, 1, 1);  // 白色画一个圆圈
//    CGContextFillPath(ctx);

    CGContextRestoreGState(ctx);
}

- (CGRect)getPreferRect {
    return CGRectMake(0, 0, 16, 16);
}
@end
