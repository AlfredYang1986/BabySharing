//
//  TalkerHeaderView.h
//  BabySharing
//
//  Created by monkeyheng on 16/3/16.
//  Copyright © 2016年 BM. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, HeaderViewShape){
    Square,
    Circle,
};

@interface TalkerHeaderView : UIView

@property (nonatomic, weak) NSArray *imageArr;
@property (nonatomic, assign) CGFloat padding;

- (instancetype)initWithFrame:(CGRect)frame count:(NSInteger)count shape:(HeaderViewShape)shape;
- (UIImageView *)getAllHeadImageView;
//- (CGRect)newFrame;

@end
