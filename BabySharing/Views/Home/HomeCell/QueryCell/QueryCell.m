//
//  QueryCell.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 9/01/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "QueryCell.h"
#import <MediaPlayer/MediaPlayer.h>
#import "MoviePlayTrait.h"
#import <AVFoundation/AVFoundation.h>
#import "INTUAnimationEngine.h"
#import "OBShapedButton.h"
#import "QueryContent.h"
#import "QueryContentTag.h"
#import "PhotoTagView.h"
#import "AppDelegate.h"

#define HER_MARGIN  10
#define VER_MARGIN  1

#define IMG_HEIGHT  226

#define IMG_OFFSET  100

#define HEADER_MARGIN_TO_SCREEN 8

#define FUNC_BTN_WIDTH  30
#define FUNC_BTN_TOP_MARGIN 8

#define DESCRIPTION_LEFT_MARGIN 6
#define DESCRIPTION_TOP_MARGIN  -9

#define FUNC_VIEW_HEIGHT            46
#define CHATING_VIEW_HEIGHT         47
#define DESCRIPTION_VIEW_HEIGHT     30

#define FUNC_BTN_WIDTH_2        25
#define FUNC_BTN_HEIGHT_2       FUNC_BTN_WIDTH_2
#define FUNC_BTN_MARGIN_2       10.5f

#define ITEMS_COUNT             3
#define ITEM_LEFT_MARGIN        10.5
#define ITEM_WIDTH              26
#define ITEM_HEIGHT             ITEM_WIDTH
#define ITEM_MARGIN_BETWEEN     -6

#define FONT_COLOR              [UIColor colorWithRed:0.3059 green:0.3059 blue:0.3059 alpha:1.f]

@implementation QueryCell {
//    MPMoviePlayerController* movie;
    AVPlayerLayer *avPlayerLayer;
    
    UITextView* descriptionView;
//    UIView* funcView;
    OBShapedButton* funcView;
    
    OBShapedButton* tag_btn;
    
    NSMutableArray* tag_arr;
}

@synthesize imgView = _imgView;

@synthesize tagsLabelView = _tagsLabelView;
@synthesize timeLabel = _timeLabel;
@synthesize bkgView = _bkgView;
@synthesize chatingView = _chatingView;
@synthesize funcBtn = _funcBtn;
@synthesize funcActArea = _funcActArea;

@synthesize delegate = _delegate;
@synthesize content = _content;

@synthesize type = _type;
@synthesize movieURL = _movieURL;
@synthesize player = _player;

#pragma mark -- constractor

#pragma mark -- layout
+ (CGFloat)preferredHeightWithDescription:(NSString*)description {
  
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat img_height = width - 2 * HER_MARGIN;
//    CGFloat img_height = IMG_HEIGHT;
//    CGFloat tmp = 89;
    CGFloat tmp = CHATING_VIEW_HEIGHT + DESCRIPTION_VIEW_HEIGHT;
    if (width == 320.f)
        return img_height
            + tmp;
//            + HER_MARGIN
//            + [self getSizeBaseOnDescription:description].height;
    else
        return img_height
            + FUNC_VIEW_HEIGHT
            + tmp;
//            + HER_MARGIN
//            + [self getSizeBaseOnDescription:description].height;
}

+ (CGSize)getSizeBaseOnDescription:(NSString*)description {
    UIFont* font = [UIFont systemFontOfSize:14.f];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
   
    /**
     * show all the description
     */
//    return [description sizeWithFont:font constrainedToSize:CGSizeMake(width - HER_MARGIN * 2, FLT_MAX)];

    CGSize size = [description sizeWithFont:font constrainedToSize:CGSizeMake(width - HER_MARGIN * 2 - 134, FLT_MAX)];
    CGSize s = [@"我靠" sizeWithFont:font constrainedToSize:CGSizeMake(width - HER_MARGIN * 2 - 134, FLT_MAX)];
    return CGSizeMake(size.width, s.height);
}

- (void)awakeFromNib {
    // Initialization code
    _imgView = [[UIImageView alloc]init];
    _imgView.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:_imgView];
    
    // 播放按钮
    _playImageView = [[UIImageView alloc] init];
    NSString * yyBundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *yyResourceBundle = [NSBundle bundleWithPath:yyBundlePath];
    UIImage *image = [UIImage imageNamed:[yyResourceBundle pathForResource:[NSString stringWithFormat:@"playvideo"] ofType:@"png"]];
    [_imgView addSubview:_playImageView];
    _playImageView.image = image;
    CGPoint center = _playImageView.center;
    _playImageView.frame = CGRectMake(0, 0, 30, 30);
    _playImageView.center = center;
    
    _imgView.userInteractionEnabled = YES;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didClickImage:)];
    [_imgView addGestureRecognizer:tap];

    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
  
    /***********************************************************************************************/
    // funcActArea
    // like
    _funcActArea = [[UIView alloc]init];
    [self addSubview:_funcActArea];
    
    // split line
    CALayer* line = [CALayer layer];
    line.borderColor = [UIColor colorWithRed:0.6078 green:0.6078 blue:0.6078 alpha:0.25].CGColor;
    line.borderWidth = 1.f;
    line.frame = CGRectMake(10.5f, FUNC_VIEW_HEIGHT - 1, [UIScreen mainScreen].bounds.size.width - 10.5f * 4 - 8, 1);
    [_funcActArea.layer addSublayer:line];
    
    UIButton* like_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, FUNC_BTN_WIDTH_2, FUNC_BTN_HEIGHT_2)];
    [like_btn setBackgroundImage:[UIImage imageNamed:[resourceBundle pathForResource:@"home_like" ofType:@"png"]] forState:UIControlStateNormal];
    like_btn.center = CGPointMake(FUNC_BTN_MARGIN_2 + FUNC_BTN_WIDTH_2 / 2, FUNC_VIEW_HEIGHT / 2);
    [like_btn addTarget:self action:@selector(likeBtnSelected) forControlEvents:UIControlEventTouchUpInside];
    [_funcActArea addSubview:like_btn];
    
    // repush btn
    UIButton* repost_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, FUNC_BTN_WIDTH_2, FUNC_BTN_HEIGHT_2)];
    [repost_btn setBackgroundImage:[UIImage imageNamed:[resourceBundle pathForResource:@"home_repost" ofType:@"png"]] forState:UIControlStateNormal];
    repost_btn.center = CGPointMake(FUNC_BTN_MARGIN_2 * 3 + FUNC_BTN_WIDTH_2 + FUNC_BTN_WIDTH_2 / 2, FUNC_VIEW_HEIGHT / 2);
    [repost_btn addTarget:self action:@selector(collectBtnSelected) forControlEvents:UIControlEventTouchUpInside];
    [_funcActArea addSubview:repost_btn];
    
    // chat btn
    UIButton* chat_btn = [[UIButton alloc]init];
    [chat_btn setTitle:@"加入圈聊" forState:UIControlStateNormal];
    [chat_btn setTitleColor:FONT_COLOR forState:UIControlStateNormal];
    chat_btn.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [chat_btn sizeToFit];
    chat_btn.center = CGPointMake([UIScreen mainScreen].bounds.size.width - FUNC_BTN_MARGIN_2 * 4 - chat_btn.frame.size.width / 2, FUNC_VIEW_HEIGHT / 2);
    [chat_btn addTarget:self action:@selector(commentsBtnSelected) forControlEvents:UIControlEventTouchUpInside];
    [_funcActArea addSubview:chat_btn];
    
    
    UIButton *chat_icon = [[UIButton alloc] init];
    chat_icon.frame = CGRectMake(0, 0, CGRectGetHeight(chat_btn.frame), CGRectGetHeight(chat_btn.frame));
    chat_icon.center = CGPointMake(chat_btn.center.x - CGRectGetWidth(chat_btn.frame) / 2 - CGRectGetHeight(chat_btn.frame) / 2, chat_btn.center.y);
    [chat_icon addTarget:self action:@selector(commentsBtnSelected) forControlEvents:UIControlEventTouchUpInside];
    [_funcActArea addSubview:chat_icon];
    
    
    CALayer* chat_icon_layer = [CALayer layer];
    chat_icon_layer.frame = CGRectMake(0, 0, CGRectGetHeight(chat_btn.frame) / 1.5, CGRectGetHeight(chat_btn.frame) / 1.5);
    chat_icon_layer.contents = (id)[UIImage imageNamed:[resourceBundle pathForResource:@"home_chat" ofType:@"png"]].CGImage;
    chat_icon_layer.position = CGPointMake(CGRectGetHeight(chat_btn.frame) / 2, CGRectGetHeight(chat_btn.frame) / 2);
    [chat_icon.layer addSublayer:chat_icon_layer];
    
    /***********************************************************************************************/

    /***********************************************************************************************/
    // chating info view
    _chatingView = [[UIView alloc]init];
    [self addSubview:_chatingView];
    
    for (int index = 2; index >= 0; --index) {
        UIImageView* tmp = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ITEM_WIDTH, ITEM_HEIGHT)];
        tmp.image = [UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"tmp_face_%d", index] ofType:@"png"]];
        tmp.center = CGPointMake(ITEM_LEFT_MARGIN + ITEM_WIDTH / 2 + (ITEM_WIDTH  + ITEM_MARGIN_BETWEEN) * index, CHATING_VIEW_HEIGHT / 2);
        tmp.tag = index + 1;
        [_chatingView addSubview:tmp];
    }
    
    UILabel* label = [[UILabel alloc]init];
    label.text = @"9个人在圈聊";
    label.font = [UIFont systemFontOfSize:12.f];
    label.textColor = FONT_COLOR;
    [label sizeToFit];
    label.center = CGPointMake(ITEM_LEFT_MARGIN + (ITEM_WIDTH  + ITEM_MARGIN_BETWEEN) * 3 + ITEM_LEFT_MARGIN - ITEM_MARGIN_BETWEEN + label.frame.size.width / 2, CHATING_VIEW_HEIGHT / 2);
    [_chatingView addSubview:label];
    /***********************************************************************************************/

    /***********************************************************************************************/
    // description area
    _bkgView = [[UIView alloc]init];
    [self addSubview:_bkgView];
    /***********************************************************************************************/
    
    tag_arr = [[NSMutableArray alloc]init];
}

- (void)layoutSubviews {
    CGFloat width = self.bounds.size.width;
    CGFloat img_height = width;
  
    CGFloat offset_y = 0;
    _imgView.frame = CGRectMake(0, 0, width, img_height <= 320.f ? img_height - 44 : img_height);
    offset_y += _imgView.frame.size.height;
    _funcActArea.frame = CGRectMake(0, offset_y, width, FUNC_VIEW_HEIGHT);
    offset_y += FUNC_VIEW_HEIGHT;
    _chatingView.frame = CGRectMake(0, offset_y, width, CHATING_VIEW_HEIGHT);
    offset_y += CHATING_VIEW_HEIGHT;
    _bkgView.frame = CGRectMake(0, offset_y, width, DESCRIPTION_VIEW_HEIGHT);
//    _funcBtn.frame = CGRectMake(width - FUNC_BTN_WIDTH - HER_MARGIN, FUNC_BTN_TOP_MARGIN, FUNC_BTN_WIDTH, FUNC_BTN_WIDTH);
    _playImageView.hidden = self.type == PostPreViewMovie ? NO : YES;
    _playImageView.center = CGPointMake(CGRectGetWidth(_imgView.frame) - CGRectGetWidth(_playImageView.frame)/2 - 5, CGRectGetHeight(_playImageView.frame)/2 + 5);
}

- (void)createTagsWithContentData {
#define SCALE_FACT     0.5
    QueryContent* tmp = (QueryContent*)_content;
    for (QueryContentTag* tag in tmp.tags) {
        PhotoTagView* tmp = [[PhotoTagView alloc]initWithTagName:tag.tag_content andType:tag.tag_type.integerValue];
        tmp.frame = CGRectMake(tag.tag_offset_x.floatValue * SCALE_FACT , tag.tag_offset_y.floatValue * SCALE_FACT, tmp.bounds.size.width, tmp.bounds.size.height);
        [_imgView addSubview:tmp];
        [tag_arr addObject:tmp];
    }
}

- (void)showTags {
    for (UIView* v in tag_arr) {
        [v removeFromSuperview];
    }
    [tag_arr removeAllObjects];
    [self createTagsWithContentData];
}

- (void)movieContentWithURL:(NSURL*)url withTriat:(MoviePlayTrait*)trait {
    self.type = PostPreViewMovie;
    self.movieURL = url;
    if (self.player == nil) {
        self.player = [[AVPlayer alloc] initWithURL:url];
    }
}

- (void)movieFinishedCallback:(NSNotification*)notify {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)playMovie {
    if (_type == PostPreViewMovie) {
//        [movie play];
        NSLog(@"play movie");
        if (avPlayerLayer == nil) {
            avPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
        }
        if (![self.layer.sublayers containsObject:avPlayerLayer]) {
            avPlayerLayer.frame = CGRectMake(_imgView.frame.origin.x, _imgView.frame.origin.y, _imgView.frame.size.width, _imgView.frame.size.height);
            avPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
            [self.layer addSublayer:avPlayerLayer];
        }
        _player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
        [_player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
            [_player play];
        }];
    } else {
//        [self commentsBtnSelected];
    }
}

- (void)stopMovie {
    if (_type == PostPreViewMovie) {
//        [movie stop];
        [_player pause];
        [avPlayerLayer removeFromSuperlayer];
//        avPlayerLayer = nil;
    }
}

#pragma mark -- handler
- (void)didClickImage:(UITapGestureRecognizer*)gesture {
    [self playMovie];
}

#pragma mark -- set values
- (void)setTime:(NSDate*)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.formatterBehavior = NSDateFormatterBehavior10_4;
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    NSString *result = [formatter stringForObjectValue:date];
    _timeLabel.text = result;
}

- (void)setTags:(NSString *)tags {
    _tagsLabelView.text = tags;
}

- (void)setDescription:(NSString*)description {
    if (descriptionView == nil) {
        descriptionView = [[UITextView alloc]init];
        [_bkgView addSubview:descriptionView];
        descriptionView.editable = NO;
        descriptionView.scrollEnabled = NO;
        descriptionView.textColor = [UIColor colorWithRed:0.3059 green:0.3059 blue:0.3059 alpha:1.f];
    }
   
    UIFont* font = [UIFont systemFontOfSize:13.f];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGSize size = [description sizeWithFont:font constrainedToSize:CGSizeMake(width - DESCRIPTION_LEFT_MARGIN * 2, FLT_MAX)];
    CGSize s = [@"我靠" sizeWithFont:font constrainedToSize:CGSizeMake(width - DESCRIPTION_LEFT_MARGIN * 2, FLT_MAX)];
    
    descriptionView.font = font;
    descriptionView.frame = CGRectMake(DESCRIPTION_LEFT_MARGIN, DESCRIPTION_TOP_MARGIN, [UIScreen mainScreen].bounds.size.width - DESCRIPTION_LEFT_MARGIN * 2, s.height);
    descriptionView.text = description;
    [descriptionView sizeToFit];
}

- (IBAction)didSelectFuncBtn {
    
    static const CGFloat kAnimationDuration = 0.5; // in seconds
    
    if (funcView == nil) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        funcView = [[OBShapedButton alloc] initWithFrame:CGRectMake(width - 113 - HEADER_MARGIN_TO_SCREEN, -60, 113, 167)];
        
        NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
        NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
        [funcView setBackgroundImage:[UIImage imageNamed:[resourceBundle pathForResource:@"home-func-view" ofType:@"png"]] forState:UIControlStateNormal];

#define TMP_MARGIN 30
#define TMP_MARGIN_2 20
        UIButton* didnotlikeBtn = [[UIButton alloc]initWithFrame:CGRectMake(113 - 28.5 - TMP_MARGIN - 30 , 19 - TMP_MARGIN_2, 50, 50)];
        [didnotlikeBtn addTarget:self action:@selector(notLikeBtnSelected) forControlEvents:UIControlEventTouchDown];
        [didnotlikeBtn setImage:[UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"home-func-up-icon"] ofType:@"png"]] forState:UIControlStateNormal];
        UIButton* collectBtn = [[UIButton alloc]initWithFrame:CGRectMake(113 - 63.5 - TMP_MARGIN, 167 / 2 - TMP_MARGIN_2, 32, 32)];
        [collectBtn setImage:[UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"home-func-col-icon"] ofType:@"png"]] forState:UIControlStateNormal];
        [collectBtn addTarget:self action:@selector(collectBtnSelected) forControlEvents:UIControlEventTouchDown];
        UIButton* commentsBtn = [[UIButton alloc]initWithFrame:CGRectMake(113 - 28.5 - TMP_MARGIN - 30, 167 - 16.5 - TMP_MARGIN_2 - 50, 50, 50)];
        [commentsBtn setImage:[UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"home-func-chat-icon"] ofType:@"png"]] forState:UIControlStateNormal];
        [commentsBtn addTarget:self action:@selector(commentsBtnSelected) forControlEvents:UIControlEventTouchDown];

        [funcView addSubview:didnotlikeBtn];
        [funcView addSubview:collectBtn];
        [funcView addSubview:commentsBtn];
        
        [_bkgView addSubview:funcView];
        funcView.hidden = YES;
        [_bkgView bringSubviewToFront:funcView];
        [_bkgView bringSubviewToFront:_funcBtn];
    }
    
    if ([funcView isHidden]) {
        funcView.hidden = NO;
        [INTUAnimationEngine animateWithDuration:kAnimationDuration
                                           delay:0.0
                                          easing:INTUEaseInOutQuadratic
                                         options:INTUAnimationOptionNone
                                      animations:^(CGFloat progress) {
                                          CGFloat rotationAngle = INTUInterpolateCGFloat(0, M_PI_4, progress);
                                          _funcBtn.transform = CGAffineTransformMakeRotation(rotationAngle);
                                      }
                                      completion:^(BOOL finished) {
                                          NSLog(@"%@", finished ? @"Animation Completed" : @"Animation Canceled");
                                      }];
    } else {
        funcView.hidden = YES;
        [INTUAnimationEngine animateWithDuration:kAnimationDuration
                                           delay:0.0
                                          easing:INTUEaseInOutQuadratic
                                         options:INTUAnimationOptionNone
                                      animations:^(CGFloat progress) {
                                          CGFloat rotationAngle = INTUInterpolateCGFloat(M_PI_4, 0, progress);
                                          _funcBtn.transform = CGAffineTransformMakeRotation(rotationAngle);
                                      }
                                      completion:^(BOOL finished) {
                                          NSLog(@"%@", finished ? @"Animation Completed" : @"Animation Canceled");
                                      }];
    }
}

- (void)notLikeBtnSelected {
    [_delegate didSelectNotLikeBtn:_content complete:^(BOOL success) {
        
        
    }];
}

- (void)likeBtnSelected {
    [_delegate didSelectLikeBtn:_content complete:^(BOOL success) {
        
        
    }];
}

- (void)collectBtnSelected {
    [_delegate didSelectCollectionBtn:_content];
}

- (void)commentsBtnSelected {
    [_delegate didSelectJoinGroupBtn:_content];
}

- (void)disappearFuncView {
    funcView.hidden = YES;
//    CGFloat rotationAngle = INTUInterpolateCGFloat(M_PI_4, 0, progress);
    _funcBtn.transform = CGAffineTransformMakeRotation(0);
    _funcBtn.hidden = NO;
}

- (void)setResource:(NSArray *)resource {
    if (![_resource isEqual:resource]) {
        _resource = resource;
    }
    // 设置图片
}

@end
