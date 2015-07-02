//
//  QueryDetailImageCell.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 12/01/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "QueryDetailImageCell.h"
#import <AVFoundation/AVFoundation.h>
#import "PhotoTagView.h"

#define HER_MARGIN      0
#define IMG_HEIGHT      241

@implementation QueryDetailImageCell {
    AVPlayerLayer* avPlayerLayer;
}

@synthesize imgView = _imgView;
@synthesize delegate = _delegate;

#pragma mark -- for movie
@synthesize type = _type;
@synthesize player = _player;

- (void)awakeFromNib {
    // Initialization code
    _imgView.userInteractionEnabled = YES;
    _imgView.contentMode = UIViewContentModeScaleToFill;
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didSelectImg:)];
    [_imgView addGestureRecognizer:tap];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)addTag:(NSString*)tag_name withPoint:(CGPoint)origin {
   
    CGFloat width = 100;
    CGFloat height = 30;
    
    _imgView.userInteractionEnabled = YES;
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(origin.x, origin.y, width, height);
    btn.backgroundColor = [UIColor blueColor];
    [btn setTitle:tag_name forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(didSelectTag:) forControlEvents:UIControlEventTouchDown];
    [_imgView addSubview:btn];
}

- (void)didSelectTag:(UITapGestureRecognizer*)gesture {
//    NSLog(@"%@", sender.titleLabel.text);
//    [_delegate didSelectDetialImageTagsWithContents:sender.titleLabel.text];
    PhotoTagView* tmp = (PhotoTagView*)gesture.view;
    [_delegate didSelectTagWithType:tmp.type andName:tmp.content];
}

- (void)prepareForAVPlayer:(AVPlayer*)player {
    
    if (_player != nil && avPlayerLayer != nil) {
        [avPlayerLayer removeFromSuperlayer];
    }
    _player = player;
    
    avPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    
    avPlayerLayer.frame = [QueryDetailImageCell getPerferBounds];
    avPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.layer addSublayer:avPlayerLayer];
}

- (void)didSelectImg:(UITapGestureRecognizer*)gesture {
    NSLog(@"tap img");
    
    if (_type == PostPreViewMovie) {
        NSLog(@"play movie in detail view");
        _player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
        [_player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
            [_player play];
        }];
    }
}

#pragma mark -- layout
+ (CGRect)getPerferBounds {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height - width / 2;
    return CGRectMake(0, 0, width, height);
}

+ (CGFloat)getPerferCellHeight {
    CGRect rc = [self getPerferBounds];
    return rc.size.height;
}

#pragma mark -- add tag to the image
- (void)addTagWithType:(NSInteger)type andContent:(NSString*)content withPositionX:(CGFloat)pos_x andPositionY:(CGFloat)pos_y {
    PhotoTagView* tmp = [[PhotoTagView alloc]initWithTagName:content andType:type];
    CGRect rc = [tmp getTagViewPreferBounds];
    tmp.frame = CGRectMake(pos_x, pos_y, rc.size.width, rc.size.height);
    [_imgView addSubview:tmp];
    [_imgView bringSubviewToFront:tmp];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didSelectTag:)];
    [tmp addGestureRecognizer:tap];
}
@end
