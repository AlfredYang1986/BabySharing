//
//  HomeCell.m
//  BabySharing
//
//  Created by monkeyheng on 16/3/10.
//  Copyright © 2016年 BM. All rights reserved.
//

#import "HomeCell.h"
#import "Tools.h"


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

@property (nonatomic, weak) QueryContent *content;

@end

@implementation HomeCell {
    UIImageView *praiseImage;
    UIImageView *jionImage;
    UIView *lineView;
    UIView *jionGroupView;
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
        [self.contentView addSubview:_ownerRole];
        
        _ownerDate = [[UILabel alloc] init];
        _ownerDate.font = [UIFont systemFontOfSize:11];
        _ownerDate.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_ownerDate];
        
        _mainImage = [[UIImageView alloc] init];
        [self.contentView addSubview:_mainImage];
//        self.number = [[UILabel alloc] init];
//        self.number.font = [UIFont systemFontOfSize:30];
//        [_mainImage addSubview:self.number];
        
        _descriptionLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_descriptionLabel];
        
        praiseImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        praiseImage.image = [UIImage imageNamed:[resourceBundle pathForResource:@"home_like" ofType:@"png"]];
        [self.contentView addSubview:praiseImage];
        
        [self.contentView addSubview:praiseImage];
        _praiseCount = [[UILabel alloc] init];
        
        [self.contentView addSubview:_praiseCount];
        _usefulCount = [[UILabel alloc] init];
        
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
        _talkerCount.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_talkerCount];
        
        _jionGroup = [[UITextField alloc] init];
        _jionGroup.enabled = YES;
        _jionGroup.font = [UIFont systemFontOfSize:13];
        _jionGroup.text = @" 加入圈聊";
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
    
        
        self.contentView.layer.cornerRadius = 19;
        self.contentView.layer.shadowColor = [UIColor blackColor].CGColor;
        self.contentView.layer.shadowOffset = CGSizeMake(1, 1);
        self.contentView.layer.shadowOpacity = 0.3;
        self.contentView.layer.shadowRadius = 1;
        self.contentView.layer.shouldRasterize = YES;
        self.contentView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        self.backgroundColor = [Tools colorWithRED:242.0 GREEN:242.0 BLUE:242.0 ALPHA:1.0];
        self.contentView.backgroundColor = [UIColor whiteColor];
        // 加入动作
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
    self.contentView.frame = CGRectInset(self.contentView.frame, 10, 5);
    _ownerImage.frame = CGRectMake(12, 8, 28, 28);
    _ownerImage.backgroundColor = [UIColor redColor];
    
    [_ownerNameLable sizeToFit];
    _ownerNameLable.frame = CGRectMake(50, 16, CGRectGetWidth(_ownerNameLable.frame), 14);
    [_ownerRole sizeToFit];
    _ownerRole.frame = CGRectMake(CGRectGetMaxX(_ownerNameLable.frame) + 10, 16, CGRectGetWidth(_ownerRole.frame) + 3, 14);
    
    _ownerDate.frame = CGRectMake(CGRectGetWidth(self.contentView.frame) - 60, 16, 50, 14);
    _mainImage.frame = CGRectMake(0, 46, CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame) - 176);
    _mainImage.backgroundColor = [UIColor redColor];
    
//    self.number.frame = CGRectMake(0, 0, _mainImage.frame.size.width, _mainImage.frame.size.height);
//    self.number.frame = CGRectInset(self.number.frame, 20, 20);
//    self.number.backgroundColor = [UIColor whiteColor];
    
    _descriptionLabel.frame = CGRectMake(10, CGRectGetMaxY(_mainImage.frame), CGRectGetWidth(self.contentView.frame) - 20, 30);
    praiseImage.frame = CGRectMake(17, CGRectGetMaxY(_descriptionLabel.frame) + 15, 25, 25);
    _praiseCount.frame = CGRectMake(57, CGRectGetMaxY(_descriptionLabel.frame) + 20, 30, 15);
    _praiseCount.backgroundColor = [UIColor redColor];
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
    
    _jionGroup.frame = CGRectMake(CGRectGetWidth(self.contentView.frame) - 95 , CGRectGetMaxY(lineView.frame) + 7, 82, CGRectGetHeight(self.contentView.frame) - CGRectGetMaxY(lineView.frame) - 14);
    jionGroupView.frame = CGRectMake(0, 0, CGRectGetWidth(_jionGroup.frame), CGRectGetHeight(_jionGroup.frame));
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
//    self.ownerRole.text
    self.descriptionLabel.text = content.content_description;
    self.ownerDate.text = [Tools compareCurrentTime:content.content_post_date];
}

- (void)mainImageTap {
    NSLog(@"播放视频");
}

- (void)stopViedo {
    NSLog(@"停止播放视频");
}

- (void)praiseImageTap {
    NSLog(@"给了个赞");
}

- (void)jionGroupTap {
    NSLog(@"加入圈聊");
    [_delegate didSelectJoinGroupBtn:_content];
}

@end
