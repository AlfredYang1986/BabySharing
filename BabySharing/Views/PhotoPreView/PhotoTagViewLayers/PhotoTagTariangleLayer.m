//
//  PhotoTagTariangleLayer.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 13/06/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "PhotoTagTariangleLayer.h"
#import <UIKit/UIKit.h>

@implementation PhotoTagTariangleLayer

- (id)init{
    self = [super init];
    if (self) {
//        self.backgroundColor = [UIColor colorWithWhite:0.f alpha:1.0].CGColor;
    }
    
    return self;
}

//重写该方法，在该方法内绘制图形
-(void)drawInContext:(CGContextRef)ctx {
    CGRect rect = self.bounds;
    CGContextClearRect(ctx, rect);
    
    CGContextSaveGState(ctx);
  
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, rect.origin.x, rect.origin.y + rect.size.height / 2);
    CGContextAddLineToPoint(ctx, rect.origin.x + rect.size.width, rect.origin.y);
    CGContextAddLineToPoint(ctx, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
   
    CGContextSetRGBFillColor(ctx, 0, 0, 0, 0.6);
    CGContextFillPath(ctx);
    
    CGContextRestoreGState(ctx);
}

- (CGRect)getPreferRect:(CGFloat)hit_height {
    return CGRectMake(0, 0, hit_height, hit_height);
}
@end
