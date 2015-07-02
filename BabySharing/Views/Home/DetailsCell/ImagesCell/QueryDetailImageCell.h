//
//  QueryDetailImageCell.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 12/01/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QueryDetailActionDelegate.h"
#import "PostDefine.h"

@class AVPlayer;

@interface QueryDetailImageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) id<QueryDetailActionDelegate> delegate;

#pragma mark -- for movie
@property (nonatomic) PostPreViewType type;
@property (nonatomic, weak, setter=prepareForAVPlayer:) AVPlayer* player;

- (void)prepareForAVPlayer:(AVPlayer*)player;
- (void)addTag:(NSString*)tag_name withPoint:(CGPoint)origin;

+ (CGRect)getPerferBounds;
+ (CGFloat)getPerferCellHeight;

- (void)addTagWithType:(NSInteger)type andContent:(NSString*)content withPositionX:(CGFloat)pos_x andPositionY:(CGFloat)pos_y;
@end
