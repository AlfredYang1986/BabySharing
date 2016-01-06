//
//  QueryCell.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 9/01/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostDefine.h"
#import "QueryCellDelegate.h"

@class AVPlayer;
@class MoviePlayTrait;

@interface QueryCell : UITableViewCell {
    
}

@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UILabel *tagsLabelView;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIView *bkgView;     // 42
@property (strong, nonatomic) IBOutlet UIView *chatingView; // 47
@property (strong, nonatomic) IBOutlet UIView *funcActArea;
@property (strong, nonatomic) IBOutlet UIButton *funcBtn;

@property (nonatomic) PostPreViewType type;
@property (nonatomic, strong) NSURL* movieURL;
@property (nonatomic, strong) AVPlayer* player;

@property (weak, nonatomic) id<QueryCellActionProtocol> delegate;
@property (weak, nonatomic) id content;

#pragma mark -- constractor

#pragma mark -- layout
+ (CGFloat)preferredHeightWithDescription:(NSString*)description;
- (void)movieContentWithURL:(NSURL*)url withTriat:(MoviePlayTrait*)trait;
- (void)playMovie;
- (void)stopMovie;

#pragma mark -- set values
- (void)setTime:(NSDate*)date;
- (void)setTags:(NSString*)tags;
- (void)setDescription:(NSString*)description;

#pragma mark -- call when cell dispear
- (void)disappearFuncView;

#pragma mark -- show tags
- (void)showTags;
@end