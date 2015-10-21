//
//  PhotoTagTariangleLayer2.m
//  BabySharing
//
//  Created by Alfred Yang on 21/10/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import "PhotoTagTariangleLayer2.h"
#import <UIKit/UIKit.h>

@implementation PhotoTagTariangleLayer2
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
//    CGContextMoveToPoint(ctx, rect.origin.x + rect.size.width / 3, rect.origin.y + rect.size.height / 2);
    CGContextMoveToPoint(ctx, rect.origin.x, rect.origin.y + rect.size.height / 2);
    CGContextAddLineToPoint(ctx, rect.origin.x + rect.size.width, rect.origin.y);
    CGContextAddLineToPoint(ctx, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
   
//    CGContextSetRGBFillColor(ctx, 0, 0, 0, 0.6);
//    CGContextSetRGBFillColor(ctx, 0.3176, 0.7529, 0.6941, 1.0);
    CGContextSetRGBFillColor(ctx, 0.9137, 0.5882, 0.4784, 0.6);
    CGContextFillPath(ctx);
    
    CGContextRestoreGState(ctx);
}

- (CGRect)getPreferRect:(CGFloat)hit_height {
    return CGRectMake(0, 0, hit_height * 2 / 3.f, hit_height);
}
@end
