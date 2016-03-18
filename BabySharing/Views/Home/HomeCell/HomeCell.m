//
//  HomeCell.m
//  BabySharing
//
//  Created by monkeyheng on 16/3/10.
//  Copyright © 2016年 BM. All rights reserved.
//

#import "HomeCell.h"
#import "Tools.h"
#import "TmpFileStorageModel.h"
#import "QueryContentItem.h"
#import <AVFoundation/AVFoundation.h>
#import "GPUImage.h"
#import "Define.h"
#import "PhotoTagView.h"
#import "QueryContentTag.h"

@interface HomeCell()

@property (nonatomic, strong, readonly) UIImageView *ownerImage;
@property (nonatomic, strong, readonly) UILabel *ownerNameLable;
@property (nonatomic, strong, readonly) UILabel *ownerRole;
@property (nonatomic, strong, readonly) UILabel *ownerDate;
@property (nonatomic, strong, readonly) UIImageView *mainImage;
@property (nonatomic, strong, readonly) UILabel *descriptionLabel;
@property (nonatomic, strong, readonly) UILabel *praiseCount;
@property (nonatomic, strong, readonly) UILabel *usefulCount;
@property (nonatomic, strong, readonly) UIImageView *firstImage;
@property (nonatomic, strong, readonly) UIImageView *secondImage;
@property (nonatomic, strong, readonly) UIImageView *thirdImage;
@property (nonatomic, strong, readonly) UILabel *talkerCount;
@property (nonatomic, strong, readonly) UITextField *jionGroup;
@property (nonatomic, strong, readonly) UIImageView *videoSign;
@property (nonatomic, strong, readonly) QueryContentItem *queryContentItem;
//@property (nonatomic, strong) AVPlayer *avplayer;
//@property (nonatomic, strong) AVPlayerItem *avplayerItem;
//@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, weak) QueryContent *content;

@property (nonatomic, strong) GPUImageMovie *gpuImageMovie;
@property (nonatomic, strong) GPUImageView *gpuImageView;
@property (nonatomic, strong) PhotoTagView *tagViewBand;
@property (nonatomic, strong) PhotoTagView *tagViewTime;
@property (nonatomic, strong) PhotoTagView *tagViewLocation;

@end

@implementation HomeCell {
    UIImageView *praiseImage;
    UIImageView *pushImage;
    UIImageView *jionImage;
    UIView *lineView;
    UIView *jionGroupView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier indexPath:(NSIndexPath *)indexPath {
    self = [self initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.indexPath = indexPath;
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
        NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
        _ownerImage = [[UIImageView alloc] init];
        [self.contentView addSubview:_ownerImage];
        
        _ownerNameLable = [[UILabel alloc] init];
        _ownerNameLable.font = [UIFont systemFontOfSize:14];
        _ownerNameLable.textColor = TextColor;
        [self.contentView addSubview:_ownerNameLable];
        
        _ownerRole = [[UILabel alloc] init];
        _ownerRole.text = @"没有返回角色标签";
        _ownerRole.font = [UIFont systemFontOfSize:12];
        _ownerRole.backgroundColor = [Tools colorWithRED:254.0 GREEN:192.0 BLUE:0.0 ALPHA:1.0];
        _ownerRole.textAlignment = NSTextAlignmentCenter;
        _ownerRole.layer.masksToBounds = YES;
        _ownerRole.layer.cornerRadius = 3;
        _ownerRole.layer.shouldRasterize = YES;
        _ownerRole.layer.rasterizationScale = [UIScreen mainScreen].scale;
        _ownerRole.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_ownerRole];
        
        _ownerDate = [[UILabel alloc] init];
        _ownerDate.font = [UIFont systemFontOfSize:11];
        _ownerDate.textAlignment = NSTextAlignmentRight;
        _ownerDate.textColor = TextColor;
        [self.contentView addSubview:_ownerDate];
        
        _mainImage = [[UIImageView alloc] init];
        [self.contentView addSubview:_mainImage];
        
        _descriptionLabel = [[UILabel alloc] init];
        _descriptionLabel.font = [UIFont systemFontOfSize:15.0];
        _descriptionLabel.textColor = TextColor;
        [self.contentView addSubview:_descriptionLabel];
        
        praiseImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        praiseImage.image = [UIImage imageNamed:[resourceBundle pathForResource:@"home_like_default" ofType:@"png"]];
        [self.contentView addSubview:praiseImage];
//        _praiseCount = [[UILabel alloc] init];
        
        
        pushImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        pushImage.image = [UIImage imageNamed:[resourceBundle pathForResource:@"push" ofType:@"png"]];
        [self.contentView addSubview:pushImage];
        [self.contentView addSubview:_praiseCount];
//        _usefulCount = [[UILabel alloc] init];
        
        
        // 中间的一条线
        lineView = [[UIView alloc] init];
        [self.contentView addSubview:lineView];
        lineView.backgroundColor = [Tools colorWithRED:231.0 GREEN:231.0 BLUE:231.0 ALPHA:1.0];
        
        [self.contentView addSubview:_usefulCount];
        _firstImage = [[UIImageView alloc] init];
        
        [self.contentView addSubview:_firstImage];
        _secondImage = [[UIImageView alloc] init];
        
        [self.contentView addSubview:_secondImage];
        _thirdImage = [[UIImageView alloc] init];
        
        [self.contentView addSubview:_thirdImage];
        _talkerCount = [[UILabel alloc] init];
        _talkerCount.text = @"没有返回全聊人数";
        _talkerCount.font = [UIFont systemFontOfSize:12];
        _talkerCount.textColor = TextColor;
        [self.contentView addSubview:_talkerCount];
        
        _jionGroup = [[UITextField alloc] init];
        _jionGroup.enabled = YES;
        _jionGroup.font = [UIFont systemFontOfSize:12];
        _jionGroup.text = @"  加入圈聊";
        _jionGroup.textColor = TextColor;
        [self.contentView addSubview:_jionGroup];
        jionImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        jionImage.image = [UIImage imageNamed:[resourceBundle pathForResource:@"home_chat" ofType:@"png"]];
        _jionGroup.leftView = jionImage;
        _jionGroup.leftViewMode = UITextFieldViewModeAlways;
        [self.contentView addSubview:_jionGroup];
        
        jionGroupView = [[UIView alloc] init];
        jionGroupView.alpha = 0.1;
        jionGroupView.backgroundColor = [UIColor whiteColor];
        [_jionGroup addSubview:jionGroupView];
        // 播放按钮
        _videoSign = [[UIImageView alloc] init];
        NSString * yyBundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
        NSBundle *yyResourceBundle = [NSBundle bundleWithPath:yyBundlePath];
        UIImage *image = [UIImage imageNamed:[yyResourceBundle pathForResource:[NSString stringWithFormat:@"playvideo"] ofType:@"png"]];
        _videoSign.image = image;
        _videoSign.frame = CGRectMake(0, 0, 30, 30);
        [_mainImage addSubview:_videoSign];

        _gpuImageView = [[GPUImageView alloc] init];
        _gpuImageView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
        [_mainImage addSubview:_gpuImageView];
        
        _tagViewBand = [[PhotoTagView alloc] initWithTagName:@"" andType:TagTypeBrand];
        [_mainImage addSubview:_tagViewBand];
        _tagViewTime = [[PhotoTagView alloc] initWithTagName:@"" andType:TagTypeTime];
        [_mainImage addSubview:_tagViewTime];
        _tagViewLocation = [[PhotoTagView alloc] initWithTagName:@"" andType:TagTypeLocation];
        [_mainImage addSubview:_tagViewLocation];

        
        self.contentView.layer.cornerRadius = 8;
        self.contentView.layer.shadowColor = [UIColor blackColor].CGColor;
        self.contentView.layer.shadowOffset = CGSizeMake(0, 0);
        self.contentView.layer.shadowOpacity = 0.25;
        self.contentView.layer.shadowRadius = 2;
        self.contentView.layer.shouldRasterize = YES;
        self.contentView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        self.backgroundColor = [Tools colorWithRED:242.0 GREEN:242.0 BLUE:242.0 ALPHA:1.0];
        self.contentView.backgroundColor = [UIColor whiteColor];
        // 加入动作
        pushImage.userInteractionEnabled = YES;
        [pushImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushGroupTap)]];
        _mainImage.userInteractionEnabled = YES;
        [_mainImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mainImageTap)]];
        praiseImage.userInteractionEnabled = YES;
        [praiseImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(praiseImageTap)]];
        [_jionGroup addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jionGroupTap)]];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    if (self.indexPath.row == 0) {
//        self.contentView.frame = CGRectMake(12.5, 10, CGRectGetWidth(self.contentView.frame) - 25, CGRectGetHeight(self.contentView.frame) - 18.5);
//    } else {
//        self.contentView.frame = CGRectInset(self.contentView.frame, 12.5, 12.5 / 2);
//    }
    self.contentView.frame = CGRectMake(12.5, 10.5, CGRectGetWidth(self.contentView.frame) - 25, CGRectGetHeight(self.contentView.frame) - 12.5);
//    self.contentView.frame = CGRectInset(self.contentView.frame, 12.5, 6);
    _ownerImage.frame = CGRectMake(12, 10, 28, 28);
    
    [_ownerNameLable sizeToFit];
    _ownerNameLable.frame = CGRectMake(50, 16, CGRectGetWidth(_ownerNameLable.frame), 14);
    [_ownerRole sizeToFit];
    _ownerRole.frame = CGRectMake(CGRectGetMaxX(_ownerNameLable.frame) + 10, 15, CGRectGetWidth(_ownerRole.frame) + 3, 16);
    
    _ownerDate.frame = CGRectMake(CGRectGetWidth(self.contentView.frame) - 60, 16, 50, 14);
    _mainImage.frame = CGRectMake(0, 46, CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame) - 176);
    _videoSign.center = CGPointMake(CGRectGetWidth(_mainImage.frame) - CGRectGetWidth(_videoSign.frame) / 2 - 10, CGRectGetHeight(_videoSign.frame) / 2 + 10);
//    _playerLayer.frame = CGRectMake(0, 0, CGRectGetWidth(_mainImage.frame), CGRectGetHeight(_mainImage.frame));
    _gpuImageView.frame = CGRectMake(0, 0, CGRectGetWidth(_mainImage.frame), CGRectGetHeight(_mainImage.frame));
    
    _descriptionLabel.frame = CGRectMake(10, CGRectGetMaxY(_mainImage.frame) + 0, CGRectGetWidth(self.contentView.frame) - 20, 18);
    _descriptionLabel.center = CGPointMake(CGRectGetWidth(self.contentView.frame) / 2, CGRectGetMaxY(_mainImage.frame) + 2 + CGRectGetHeight(_descriptionLabel.frame));
    
    praiseImage.frame = CGRectMake(17, CGRectGetMaxY(_descriptionLabel.frame) + 15, 25, 25);
    _praiseCount.frame = CGRectMake(57, CGRectGetMaxY(_descriptionLabel.frame) + 20, 30, 15);
    _praiseCount.backgroundColor = [UIColor redColor];
    
    pushImage.frame = CGRectMake(CGRectGetWidth(self.contentView.frame) / 2, CGRectGetMaxY(_descriptionLabel.frame) + 15, 25, 25);
    _usefulCount.frame = CGRectMake(CGRectGetMaxX(_praiseCount.frame) + 80, CGRectGetMinY(_praiseCount.frame), 30, 15);
    _usefulCount.backgroundColor = [UIColor redColor];
    lineView.frame = CGRectMake(15, CGRectGetMaxY(praiseImage.frame) + 15, CGRectGetWidth(self.contentView.frame) - 30, 1);
    CGFloat radius = (CGRectGetHeight(self.contentView.frame) - CGRectGetMaxY(lineView.frame)) / 2;
    _firstImage.frame = CGRectMake(0, 0, radius * 2 - 18, radius * 2 - 18);
    _firstImage.center = CGPointMake(18 + radius / 2, CGRectGetMaxY(lineView.frame) + radius);
    _secondImage.frame = CGRectMake(0, 0, radius * 2 - 18, radius * 2 - 18);
    _secondImage.center = CGPointMake(CGRectGetMidX(_firstImage.frame) + radius, CGRectGetMaxY(lineView.frame) + radius);
    _thirdImage.frame = CGRectMake(0, 0, radius * 2 - 18, radius * 2 - 18);
    _thirdImage.center = CGPointMake(CGRectGetMidX(_secondImage.frame) + radius, CGRectGetMaxY(lineView.frame) + radius);
    _firstImage.backgroundColor = [UIColor redColor];
    _secondImage.backgroundColor = [UIColor yellowColor];
    _thirdImage.backgroundColor = [UIColor greenColor];
    [self.contentView bringSubviewToFront:_thirdImage];
    [self.contentView bringSubviewToFront:_secondImage];
    [self.contentView bringSubviewToFront:_firstImage];
    
    // 圆角
    _ownerImage.layer.cornerRadius = CGRectGetWidth(_ownerImage.frame) / 2;
    _ownerImage.layer.masksToBounds = YES;
    self.ownerImage.layer.shouldRasterize = YES;
    self.ownerImage.layer.rasterizationScale = [UIScreen mainScreen].scale;
    _thirdImage.layer.cornerRadius = CGRectGetWidth(_thirdImage.frame) / 2;
    self.thirdImage.layer.shouldRasterize = YES;
    self.contentView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    _secondImage.layer.cornerRadius = CGRectGetWidth(_secondImage.frame) / 2;
    self.secondImage.layer.shouldRasterize = YES;
    self.secondImage.layer.rasterizationScale = [UIScreen mainScreen].scale;
    _firstImage.layer.cornerRadius = CGRectGetWidth(_firstImage.frame) / 2;
    self.firstImage.layer.shouldRasterize = YES;
    self.firstImage.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    [_talkerCount sizeToFit];
    _talkerCount.frame = CGRectMake(0, 0, CGRectGetWidth(_talkerCount.frame), CGRectGetHeight(_talkerCount.frame));
    CGFloat x = self.thirdImage.center.x + CGRectGetWidth(_talkerCount.frame) / 2 + CGRectGetWidth(_firstImage.frame) / 2 + 9;
    CGFloat y = self.thirdImage.center.y;
    _talkerCount.center = CGPointMake([NSNumber numberWithFloat:x].intValue, [NSNumber numberWithFloat:y].intValue);
    _jionGroup.frame = CGRectMake(CGRectGetWidth(self.contentView.frame) - 97 , CGRectGetMaxY(lineView.frame) + 7, 90, CGRectGetHeight(self.contentView.frame) - CGRectGetMaxY(lineView.frame) - 14);
    jionGroupView.frame = CGRectMake(0, 0, CGRectGetWidth(_jionGroup.frame), CGRectGetHeight(_jionGroup.frame));
    
    _tagViewBand.frame = CGRectMake(_tagViewBand.offset_x * _mainImage.frame.size.width, _tagViewBand.offset_y * _mainImage.frame.size.height, CGRectGetWidth(_tagViewBand.frame), CGRectGetHeight(_tagViewBand.frame));
    _tagViewTime.frame = CGRectMake(_tagViewTime.offset_x * _mainImage.frame.size.width, _tagViewTime.offset_y * _mainImage.frame.size.height, CGRectGetWidth(_tagViewTime.frame), CGRectGetHeight(_tagViewTime.frame));
    _tagViewLocation.frame = CGRectMake(_tagViewLocation.offset_x * _mainImage.frame.size.width, _tagViewLocation.offset_y * _mainImage.frame.size.height, CGRectGetWidth(_tagViewLocation.frame), CGRectGetHeight(_tagViewLocation.frame));
}

- (void)updateViewWith:(QueryContent *)content {
//    @property (nonatomic, strong, readonly) UIImageView *ownerImage;
//    @property (nonatomic, strong, readonly) UILabel *ownerNameLable;
//    @property (nonatomic, strong, readonly) UILabel *ownerTags;
//    @property (nonatomic, strong, readonly) UILabel *ownerDate;
//    @property (nonatomic, strong, readonly) UIImageView *mainImage;
//    @property (nonatomic, strong, readonly) UILabel *descriptionLabel;
//    @property (nonatomic, strong, readonly) UILabel *praiseCount;
//    @property (nonatomic, strong, readonly) UILabel *usefulCount;
//    @property (nonatomic, strong, readonly) UIImageView *firstImage;
//    @property (nonatomic, strong, readonly) UIImageView *secondImage;
//    @property (nonatomic, strong, readonly) UIImageView *thirdImage;
//    @property (nonatomic, strong, readonly) UILabel *talkerCount;
//    @property (nonatomic, strong, readonly) UITextField *jionGroup;
    
    self.content = content;
    
    self.ownerNameLable.text = content.owner_name;
    self.descriptionLabel.text = content.content_description;
    self.ownerDate.text = [Tools compareCurrentTime:content.content_post_date];
    self.talkerCount.text = [NSString stringWithFormat:@"%d人正在圈聊", self.content.group_chat_count.intValue];
    
    // 设置头像
    NSString *bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    NSString *defaultHeadPath = [resourceBundle pathForResource:[NSString stringWithFormat:@"default_user"] ofType:@"png"];
    self.ownerImage.image = [TmpFileStorageModel enumImageWithName:self.content.owner_photo withDownLoadFinishBolck:^(BOOL success, UIImage *img) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self) {
                    self.ownerImage.image = img;
                    NSLog(@"owner img download success");
                }
            });
        }
    }];
    
    if (self.ownerImage.image == nil) {
        self.ownerImage.image = [UIImage imageNamed:defaultHeadPath];
    }
    
    // 设置大图
    for (QueryContentItem *item in self.content.items) {
        if (item.item_type.unsignedIntegerValue != PostPreViewMovie) {
            self.mainImage.image = [TmpFileStorageModel enumImageWithName:item.item_name withDownLoadFinishBolck:^(BOOL success, UIImage *img) {
                if (success) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (self) {
                            self.mainImage.image = img;
                            NSLog(@"owner img download success");
                        }
                    });
                }
            }];
            if (self.mainImage.image == nil) {
                NSString *defaultMainPath = [resourceBundle pathForResource:[NSString stringWithFormat:@"chat_mine_bg"] ofType:@"png"];
                self.mainImage.image = [UIImage imageNamed:defaultMainPath];
            }
            break;
        }
    }
    _videoSign.hidden = YES;
    _queryContentItem = nil;
    for (QueryContentItem *item in self.content.items) {
        if (item.item_type.unsignedIntegerValue == PostPreViewMovie) {
            _queryContentItem = item;
            _videoSign.hidden = NO;
        }
    }
    
    _gpuImageView.hidden = YES;
    
    praiseImage.image = self.content.isLike.integerValue == 0 ? [UIImage imageNamed:[resourceBundle pathForResource:@"home_like_default" ofType:@"png"]] : [UIImage imageNamed:[resourceBundle pathForResource:@"home_like_like" ofType:@"png"]] ;
    
    // 添加标签
    self.tagViewLocation.hidden = YES;
    self.tagViewBand.hidden = YES;
    self.tagViewTime.hidden = YES;

    QueryContent *tmp = (QueryContent*)_content;
    for (QueryContentTag *tag in tmp.tags) {
        NSLog(@"MonkeyHengLog: %@ === %d", @"tag", tag.tag_type.intValue);
        switch (tag.tag_type.intValue) {
            case TagTypeBrand:
                self.tagViewBand.hidden = NO;
                self.tagViewBand.content = tag.tag_content;
                self.tagViewBand.offset_x = tag.tag_offset_x.floatValue;
                self.tagViewBand.offset_y = tag.tag_offset_y.floatValue;
                break;
            case TagTypeTime:
                self.tagViewTime.hidden = NO;
                self.tagViewTime.content = tag.tag_content;
                self.tagViewTime.offset_x = tag.tag_offset_x.floatValue;
                self.tagViewTime.offset_y = tag.tag_offset_y.floatValue;
                break;
            case TagTypeLocation:
                self.tagViewLocation.hidden = NO;
                self.tagViewLocation.content = tag.tag_content;
                self.tagViewLocation.offset_x = tag.tag_offset_x.floatValue;
                self.tagViewLocation.offset_y = tag.tag_offset_y.floatValue;
                break;
            default:
                break;
        }
    }
}

- (void)mainImageTap {
    if (_queryContentItem != nil && _gpuImageMovie.progress == 0) {
        NSURL* url = [TmpFileStorageModel enumFileWithName:_queryContentItem.item_name andType:_queryContentItem.item_type.unsignedIntegerValue withDownLoadFinishBlock:^(BOOL success, NSURL *path) {
            if (success) {
                _gpuImageView.hidden = NO;
                _videoSign.hidden = YES;
                _gpuImageMovie = [[GPUImageMovie alloc] initWithURL:path];
                _gpuImageMovie.playAtActualSpeed = YES;
                _gpuImageMovie.shouldRepeat = YES;
                [_gpuImageMovie addTarget:_gpuImageView];
                [_gpuImageMovie startProcessing];
            } else {
                NSLog(@"down load movie %@ failed", _queryContentItem.item_name);
            }
        }];
        if (url) {
            _gpuImageMovie = [[GPUImageMovie alloc] initWithURL:url];
            _gpuImageView.hidden = NO;
            _videoSign.hidden = YES;
            _gpuImageMovie.playAtActualSpeed = YES;
            _gpuImageMovie.shouldRepeat = YES;
            [_gpuImageMovie addTarget:_gpuImageView];
            [_gpuImageMovie startProcessing];
        }
    }
    if (_gpuImageMovie.progress != 0) {
        [self stopViedo];
    }
}

- (void)stopViedo {
    NSLog(@"停止播放视频");
    _gpuImageView.hidden = YES;
    _videoSign.hidden = NO;
    [_gpuImageMovie endProcessing];
    [_gpuImageMovie cancelProcessing];
    [_gpuImageMovie removeAllTargets];
}

- (void)praiseImageTap {
    NSLog(@"heart btn did selected");
    if (self.content.isLike.integerValue == 1) {
        [_delegate didSelectNotLikeBtn:_content complete:^(BOOL success) {
            if (!success) {
                [[[UIAlertView alloc] initWithTitle:@"通知" message:@"由于某些不可抗力，出现了错误" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
            } else {
                NSString *bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
                NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
                praiseImage.image = [UIImage imageNamed:[resourceBundle pathForResource:@"home_like_default" ofType:@"png"]];
            }
        }];
    } else {
        [_delegate didSelectLikeBtn:_content complete:^(BOOL success) {
            if (!success) {
                [[[UIAlertView alloc] initWithTitle:@"通知" message:@"由于某些不可抗力，出现了错误" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
            } else {
                NSString *bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
                NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
                praiseImage.image = [UIImage imageNamed:[resourceBundle pathForResource:@"home_like_like" ofType:@"png"]];
            }
        }];
    }
}

- (void)pushGroupTap {
    NSLog(@"推了一个");
    [_delegate didSelectCollectionBtn:_content];
}

- (void)jionGroupTap {
    NSLog(@"加入圈聊");
    [_delegate didSelectJoinGroupBtn:_content];
}

@end
