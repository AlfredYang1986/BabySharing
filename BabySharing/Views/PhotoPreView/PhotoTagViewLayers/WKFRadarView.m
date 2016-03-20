//
//  WKFRadarView.m
//  RadarDemo
//
//  Created by apple on 16/1/13.
//  Copyright © 2016年 吴凯锋 QQ:24272779. All rights reserved.
//

#import "WKFRadarView.h"
@interface KFRadarButton ()

@end

@implementation KFRadarButton

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.alpha = 0;
    }
    return self;
}
-(void)didMoveToWindow
{
    [super didMoveToWindow];
    if (self.window != nil) {
        [UIView animateWithDuration:1 animations:^{
            self.alpha = 1;
        }];
    }
}
-(void)removeFromSuperview
{
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:1];
    self.alpha = 0;
    [UIView setAnimationDidStopSelector:@selector(callSuperRemoveSuperView)];
    [UIView commitAnimations];
    
}
-(void)callSuperRemoveSuperView
{
    [super removeFromSuperview];
}

@end

@interface WKFRadarView()
{
    CGSize itemSize;
    NSMutableArray *items ;
}

@property (nonatomic,weak)CALayer *animationLayer;

@end

@implementation WKFRadarView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //当重后台进入前台，防止假死状态
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resumeAnimation) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resumeAnimation) name:@"refreshTagAnimation" object:nil];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame andThumbnail:(NSString *)thumbnailUrl {
    if (self = [super initWithFrame:frame]) {
        //当重后台进入前台，防止假死状态
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resumeAnimation) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resumeAnimation) name:@"refreshTagAnimation" object:nil];
        self.backgroundColor = [UIColor clearColor];
        items = [[NSMutableArray alloc] init];
        itemSize = CGSizeMake(40, 40);
        self.thumbnailImage = [UIImage imageNamed:thumbnailUrl];
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    [[UIColor clearColor] setFill];
    UIRectFill(rect);
    NSInteger pulsingCount = 3;
    double animationDuration = 2;
    
    CALayer * animationLayer = [[CALayer alloc] init];
    self.animationLayer = animationLayer;
    
    for (int i = 0; i < pulsingCount; i++) {
        CALayer * pulsingLayer = [[CALayer alloc] init];
        pulsingLayer.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
        pulsingLayer.backgroundColor = [UIColor colorWithRed:155.0/255.0 green:155.0/255.0 blue:155.0/255.0 alpha:1.0].CGColor;
        pulsingLayer.borderColor = [UIColor colorWithRed:155.0/255.0 green:155.0/255.0 blue:155.0/255.0 alpha:1.0].CGColor;
        pulsingLayer.borderWidth = 1.0;
        pulsingLayer.cornerRadius = rect.size.height / 2;
        
        CAMediaTimingFunction * defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        
        CAAnimationGroup * animationGroup = [[CAAnimationGroup alloc] init];
        animationGroup.fillMode = kCAFillModeBoth;
        animationGroup.beginTime = CACurrentMediaTime() + (double)i * animationDuration/(double)pulsingCount;
        animationGroup.duration = animationDuration;
        animationGroup.repeatCount = HUGE_VAL;
        animationGroup.timingFunction = defaultCurve;
        
        CABasicAnimation * scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.autoreverses = NO;
        scaleAnimation.fromValue = [NSNumber numberWithDouble:0.0];
        scaleAnimation.toValue = [NSNumber numberWithDouble:1.0];
        
        
        CAKeyframeAnimation * opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.values = @[[NSNumber numberWithDouble:1.0], [NSNumber numberWithDouble:0.5],[NSNumber numberWithDouble:0.3], [NSNumber numberWithDouble:0.0]];
        opacityAnimation.keyTimes = @[[NSNumber numberWithDouble:0.0], [NSNumber numberWithDouble:0.25],[NSNumber numberWithDouble:0.5], [NSNumber numberWithDouble:1.0]];
        animationGroup.animations = @[scaleAnimation,opacityAnimation];
        
        [pulsingLayer addAnimation:animationGroup forKey:@"pulsing"];
        [animationLayer addSublayer:pulsingLayer];
        
    }
    
    self.animationLayer.zPosition = -1;//重新加载时，使动画至底层
    [self.layer addSublayer:self.animationLayer];
    
    CALayer * thumbnailLayer = [[CALayer alloc] init];
    thumbnailLayer.backgroundColor = [UIColor whiteColor].CGColor;
    CGRect thumbnailRect = CGRectMake(0, 0, 0, 0);
    thumbnailRect.origin.x = (rect.size.width - thumbnailRect.size.width)/2.0;
    thumbnailRect.origin.y = (rect.size.height - thumbnailRect.size.height)/2.0;
    thumbnailLayer.frame = thumbnailRect;
    thumbnailLayer.cornerRadius = 23.0;
    thumbnailLayer.borderWidth = 1.0;
    thumbnailLayer.masksToBounds = YES;
    thumbnailLayer.borderColor = [UIColor whiteColor].CGColor;
    UIImage * thumbnail = self.thumbnailImage;
    thumbnailLayer.contents = (id)thumbnail.CGImage;
    thumbnailLayer.zPosition = -1;
    [self.layer addSublayer:thumbnailLayer];
}

// 以下代码无用
//-(void)addOrReplaceItem
//{
//    NSInteger maxCount = 6;
//    KFRadarButton *prButton = [[KFRadarButton alloc]initWithFrame:CGRectMake(0, 0, itemSize.width, itemSize.height)];
//    [prButton setImage:[UIImage imageNamed:@"default_portrait"] forState:UIControlStateNormal];
//    prButton.layer.cornerRadius = 20;
//    prButton.layer.masksToBounds = YES;
//    
//    do {
//        CGPoint point = [self generateCenterPointInRadar];
//        prButton.center = CGPointMake(point.x, point.y);
//        
//    } while ([self itemFrameIntersectsInOtherItem:prButton.frame]);
//    
//    [self addSubview:prButton];
//    [items addObject:prButton];
//    
//    if (items.count > maxCount) {
//        UIView * view = items[0];
//        [view removeFromSuperview];
//        [items removeObject:view];
//    }
//}

//-(BOOL)itemFrameIntersectsInOtherItem:(CGRect)frame
//{
//    for (KFRadarButton *item in items) {
//        if (CGRectIntersectsRect(item.frame, frame)) {
//            return YES;
//        }
//    }
//    return NO;
//}
//
//-(CGPoint)generateCenterPointInRadar
//{
//    double angle = arc4random()%360;
//    double radius = ((NSInteger)arc4random()) % ((NSInteger)((self.bounds.size.width - itemSize.width)/2));
//    double x = cos(angle) * radius;
//    double y = sin(angle) * radius;
//    return CGPointMake(x + self.bounds.size.width/2, y + self.bounds.size.height/2);
//}


// 防止假死
-(void)resumeAnimation {
    if (self.animationLayer) {
        [self.animationLayer removeFromSuperlayer];
        [self setNeedsDisplay];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
