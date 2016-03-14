//
//  MJRefreshBackGifFooter.m
//  MJRefreshExample
//
//  Created by MJ Lee on 15/4/24.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "BSRefreshAnimationFooter.h"

@interface BSRefreshAnimationFooter()
{
    __unsafe_unretained UIImageView *_gifView;
}
/** 所有状态对应的动画图片 */
@property (strong, nonatomic) NSMutableDictionary *stateImages;
/** 所有状态对应的动画时间 */
@property (strong, nonatomic) NSMutableDictionary *stateDurations;
@end

@implementation BSRefreshAnimationFooter
#pragma mark - 懒加载
- (UIImageView *)gifView
{
    if (!_gifView) {
        UIImageView *gifView = [[UIImageView alloc] init];
        NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
        NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
        gifView.image = [UIImage imageNamed:[resourceBundle pathForResource:@"avatar_00019" ofType:@"png"]];
        [self addSubview:_gifView = gifView];
    
        CABasicAnimation* rotationAnimation;
        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
        rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
        rotationAnimation.duration = 1.5;
        rotationAnimation.cumulative = YES;
        rotationAnimation.repeatCount = INT64_MAX;
        [_gifView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    }
    return _gifView;
}

- (NSMutableDictionary *)stateImages
{
    if (!_stateImages) {
        self.stateImages = [NSMutableDictionary dictionary];
    }
    return _stateImages;
}

- (NSMutableDictionary *)stateDurations
{
    if (!_stateDurations) {
        self.stateDurations = [NSMutableDictionary dictionary];
    }
    return _stateDurations;
}

#pragma mark - 公共方法
- (void)setImages:(NSArray *)images duration:(NSTimeInterval)duration forState:(MJRefreshState)state
{
    if (images == nil) return;
    
    self.stateImages[@(state)] = images;
    self.stateDurations[@(state)] = @(duration);
    
    /* 根据图片设置控件的高度 */
    UIImage *image = [images firstObject];
    if (image.size.height > self.mj_h) {
        self.mj_h = image.size.height;
    }
}

- (void)setImages:(NSArray *)images forState:(MJRefreshState)state
{
    [self setImages:images duration:images.count * 0.1 forState:state];
}

#pragma mark - 实现父类的方法
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    NSArray *images = self.stateImages[@(MJRefreshStateIdle)];
    if (self.state != MJRefreshStateIdle || images.count == 0) return;
    [self.gifView stopAnimating];
    NSUInteger index =  images.count * pullingPercent;
    if (index >= images.count) index = images.count - 1;
    self.gifView.image = images[index];
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    if (self.gifView.constraints.count) return;
    
    self.gifView.frame = self.bounds;
    if (self.stateLabel.hidden) {
        self.gifView.contentMode = UIViewContentModeCenter;
    } else {
        self.gifView.contentMode = UIViewContentModeRight;
        self.gifView.mj_w = self.mj_w * 0.5 - 90;
    }
    self.gifView.contentMode = UIViewContentModeScaleAspectFit;
    self.gifView.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, CGRectGetHeight(self.bounds) / 2 - 5);
}

- (void)setState:(MJRefreshState)state
{
    MJRefreshState oldState = self.state;
    if (state == oldState) return;
    [super setNoTextState:state];
    //    // 根据状态做事情
    //    if (state == MJRefreshStatePulling || state == MJRefreshStateRefreshing) {
    //        NSArray *images = self.stateImages[@(state)];
    //        if (images.count == 0) return;
    //
    //        [self.gifView stopAnimating];
    //        if (images.count == 1) { // 单张图片
    //            self.gifView.image = [images lastObject];
    //        } else { // 多张图片
    //            self.gifView.animationImages = images;
    //            self.gifView.animationDuration = [self.stateDurations[@(state)] doubleValue];
    //            [self.gifView startAnimating];
    //        }
    //    } else if (state == MJRefreshStateIdle) {
    //        [self.gifView stopAnimating];
    //    }
}

- (void)setLastUpdatedTimeKey:(NSString *)lastUpdatedTimeKey {
    
}
@end
