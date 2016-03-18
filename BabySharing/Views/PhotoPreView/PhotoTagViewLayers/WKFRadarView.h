//
//  WKFRadarView.h
//  RadarDemo
//
//  Created by apple on 16/1/13.
//  Copyright © 2016年 吴凯锋 QQ:24272779. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KFRadarButton :UIButton

@end

@interface WKFRadarView : UIView
@property (nonatomic,strong)UIImage *thumbnailImage;
-(instancetype)initWithFrame:(CGRect)frame andThumbnail:(NSString *)thumbnailUrl;
-(void)addOrReplaceItem;
@end
