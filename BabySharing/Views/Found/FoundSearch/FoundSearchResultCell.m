//
//  FoundSearchResultCell.m
//  BabySharing
//
//  Created by Alfred Yang on 8/12/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import "FoundSearchResultCell.h"
#import "TmpFileStorageModel.h"
#import "RemoteInstance.h"
#import "TalkerHeaderView.h"
#import "Define.h"
#import "Tools.h"

#define RECOMMEND_COUNT         3

#define MARGIN                  13
#define MARGIN_VER              12
// 内部
#define ICON_WIDTH              15
#define ICON_HEIGHT             15

#define TAG_HEIGHT              25
#define TAG_MARGIN              10
#define TAG_CORDIUS             5
#define TAG_MARGIN_BETWEEN      10.5

@interface FoundSearchResultCell ()

@property (weak, nonatomic) IBOutlet UIImageView *nextIcon;
//@property (weak, nonatomic) IBOutlet UILabel *resultCountLabel;
@property (strong, nonatomic) UIView* btn;
@property (nonatomic, strong) TalkerHeaderView *headerView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *margin1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *margin2;
@property (weak, nonatomic) NSArray *imageArr;

@property (strong, nonatomic) UILabel *resultCountLabel;


@end

@implementation FoundSearchResultCell

//@synthesize resultCountLabel = _resultCountLabel;
@synthesize nextIcon = _nextIcon;

@synthesize isScreenPhoto = _isScreenPhoto;

- (void)awakeFromNib {
    // Initialization code
    
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    
    _nextIcon.image = [UIImage imageNamed:[resourceBundle pathForResource:@"found-more-friend-arror" ofType:@"png"]];
    
    _headerView = [[TalkerHeaderView alloc] init];
    _headerView.backgroundColor = [UIColor blackColor];
    
    CALayer* layer = [CALayer layer];
    layer.borderColor = [UIColor colorWithWhite:0.5922 alpha:0.25].CGColor;
    layer.borderWidth = 1.f;
    layer.frame = CGRectMake(0, [FoundSearchResultCell preferredHeight] - 1, [UIScreen mainScreen].bounds.size.width, 1);
    [self.layer addSublayer:layer];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUserPhotoImage:(NSArray *)img_arr {
    
    self.margin1.constant = -15;
    self.margin2.constant = -15;
    self.imageArr = img_arr;
     // 圆形头像
    
    [self setSearchResultCount:img_arr.count];
    
    _isScreenPhoto = YES;
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];

    for (int index = 0; index < MIN(RECOMMEND_COUNT, img_arr.count); ++index) {
        //        NSDictionary* iter = [img_arr objectAtIndex:index];
        NSDictionary* iter = [img_arr objectAtIndex:index];
        
        UIImageView* tmp = (UIImageView*)[self viewWithTag:-3 + index];
        tmp.layer.cornerRadius = 19.0f;
//        tmp.clipsToBounds = YES;
        tmp.layer.masksToBounds = YES;
//        tmp.bounds = CGRectMake(0, 0, 25, 25);
        tmp.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.3].CGColor;
        tmp.layer.borderWidth = 1.5;
        
        UIView *maskView = [tmp.subviews firstObject];
        if (maskView == nil) {
            maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 43, 43)];
            maskView.layer.borderColor = [UIColor whiteColor].CGColor;
            maskView.layer.borderWidth = 5;
            maskView.layer.cornerRadius = 43 / 2;
            [tmp addSubview:maskView];
        }
        maskView.hidden = NO;
        
        NSString * filePath = [resourceBundle pathForResource:[NSString stringWithFormat:@"default_user"] ofType:@"png"];
        NSString* photo_name = [iter objectForKey:@"screen_photo"];
        UIImage* userImg = [TmpFileStorageModel enumImageWithName:photo_name withDownLoadFinishBolck:^(BOOL success, UIImage *user_img) {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self) {
                        tmp.image = user_img;
                        NSLog(@"owner img download success");
                    }
                });
            } else {
                NSLog(@"down load owner image %@ failed", photo_name);
            }
        }];
//        self.headerView
        
        if (userImg == nil) {
            userImg = [UIImage imageNamed:filePath];
        }
        [tmp setImage:userImg];
    }
}


- (void)setUserContentImages:(NSArray *)img_arr {
    // 方头像
//    CGFloat height = [FoundSearchResultCell preferredHeight] - 30;
//    if (img_arr.count > 0) {
//        _headerView.frame = CGRectMake(0, 0, height * img_arr.count, height);
//    }
//    
//    _headerView.imageArr = img_arr;
    
    [self setSearchResultCount:img_arr.count];
    self.margin1.constant = 4;
    self.margin2.constant = 4;
    
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    

    
    for (int index = 0; index < MIN(RECOMMEND_COUNT, img_arr.count); ++index) {
//        NSDictionary* iter = [img_arr objectAtIndex:index];
        NSDictionary* iter = [img_arr objectAtIndex:index];
        NSArray* items = [iter objectForKey:@"items"];
        NSDictionary* item = items.firstObject;
        
        UIImageView* tmp = (UIImageView*)[self viewWithTag:-3 + index];
        tmp.layer.cornerRadius = 3.f;
        tmp.clipsToBounds = YES;
        
        NSString * filePath = [resourceBundle pathForResource:[NSString stringWithFormat:@"default_user"] ofType:@"png"];
        NSString* photo_name = [item objectForKey:@"name"];
        UIImage* userImg = [TmpFileStorageModel enumImageWithName:photo_name withDownLoadFinishBolck:^(BOOL success, UIImage *user_img) {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self) {
                        tmp.image = user_img;
                        NSLog(@"owner img download success");
                    }
                });
            } else {
                NSLog(@"down load owner image %@ failed", photo_name);
            }
        }];
        
        if (userImg == nil) {
            userImg = [UIImage imageNamed:filePath];
        }
        [tmp setImage:userImg];
    }
}

- (void)setSearchTag:(NSString*)title andType:(NSNumber*)type {
    
    _tag_name = title;
    _tag_type = type;
    
    UIFont* font = [UIFont systemFontOfSize:11.f];
    CGSize size = CGSizeMake(320, 2000); //设置一个行高上限
    NSDictionary *attribute = @{NSFontAttributeName: font};
    CGSize sz_font = [title boundingRectWithSize:size options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
//    CGSize sz_font = [title sizeWithFont:font constrainedToSize:CGSizeMake(FLT_MAX, FLT_MAX)];
   
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    
    //    TagTypeLocation,
    //    TagTypeTime,
    //    TagTypeTags,
    //    TagTypeBrand,
    
//    0 
    UIImage* image0 = [UIImage imageNamed:[resourceBundle pathForResource:@"tag_location_dark" ofType:@"png"]];
//    1
    UIImage* image1 = [UIImage imageNamed:[resourceBundle pathForResource:@"tag_time_dark" ofType:@"png"]];
//    3
    UIImage* image2 = [UIImage imageNamed:[resourceBundle pathForResource:@"tag_brand_dark" ofType:@"png"]];
    
    UIImageView* img = [[UIImageView alloc]initWithFrame:CGRectMake(TAG_MARGIN / 2, TAG_MARGIN / 4, ICON_WIDTH, ICON_HEIGHT)];
    img.center = CGPointMake(TAG_MARGIN / 2 + img.frame.size.width / 2, TAG_HEIGHT / 2);
    
    if (type.integerValue == 0) {
        img.image = image0;
    } else if (type.integerValue == 1) {
        img.image = image1;
    } else if (type.integerValue == 3){
        img.image = image2;
    } else {

    }
    
    if (type.integerValue == -1) {
        CGSize sz = CGSizeMake(sz_font.width + TAG_MARGIN, TAG_HEIGHT);
        _btn = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sz.width, 16)];
        UILabel* label = [[UILabel alloc]init];
        label.font = font;
        label.text = title;
        label.textColor = [UIColor whiteColor];
        label.frame = CGRectMake(5, 0, sz_font.width, TAG_HEIGHT);
        label.textAlignment = NSTextAlignmentCenter;
        label.center = CGPointMake(CGRectGetWidth(_btn.frame) / 2, CGRectGetHeight(_btn.frame) / 2);
        [_btn addSubview:label];
        
        [_btn setBackgroundColor:[Tools colorWithRED:254.0 GREEN:192.0 BLUE:0.0 ALPHA:1.0]];
        _btn.layer.masksToBounds = YES;
        _btn.layer.cornerRadius = 3;
        _btn.layer.shouldRasterize = YES;
        _btn.layer.rasterizationScale = [UIScreen mainScreen].scale;
        _btn.center = CGPointMake(CGRectGetWidth(_btn.frame) / 2 + MARGIN, [FoundSearchResultCell preferredHeight] / 2);
        [self addSubview:_btn];
    } else {
        CGSize sz = CGSizeMake(TAG_MARGIN + ICON_WIDTH + sz_font.width + TAG_MARGIN, TAG_HEIGHT);
        
        _btn = [[UIView alloc]initWithFrame:CGRectMake(0, 0, sz.width, sz.height)];
        [_btn addSubview:img];
        UILabel* label = [[UILabel alloc]init];
        label.font = font;
        label.text = title;
        label.textColor = [UIColor colorWithWhite:0.3059 alpha:1.f];
        label.frame = CGRectMake(TAG_MARGIN + ICON_WIDTH, 0, sz_font.width, TAG_HEIGHT);
        label.textAlignment = NSTextAlignmentLeft;
        [_btn addSubview:label];
        _btn.layer.borderColor = [UIColor colorWithWhite:0.6078 alpha:1.f].CGColor;
        _btn.layer.borderWidth = 1.f;
        _btn.layer.cornerRadius = TAG_CORDIUS;
        _btn.clipsToBounds = YES;
        _btn.center = CGPointMake(MARGIN + _btn.frame.size.width / 2, [FoundSearchResultCell preferredHeight] / 2);
        [self addSubview:_btn];
    }
    
//    [_btn addSubview:img];
//    
//    UILabel* label = [[UILabel alloc]init];
//    label.font = font;
//    label.text = title;
//    label.textColor = [UIColor colorWithWhite:0.3059 alpha:1.f];
//    label.frame = CGRectMake(TAG_MARGIN + ICON_WIDTH, 0, sz_font.width, TAG_HEIGHT);
//    label.textAlignment = NSTextAlignmentLeft;
//    [_btn addSubview:label];
//    
//    _btn.layer.borderColor = [UIColor colorWithWhite:0.6078 alpha:1.f].CGColor;
//    _btn.layer.borderWidth = 1.f;
//    _btn.layer.cornerRadius = TAG_CORDIUS;
//    _btn.clipsToBounds = YES;
//    _btn.center = CGPointMake(MARGIN + _btn.frame.size.width / 2, [FoundSearchResultCell preferredHeight] / 2);
//    [self addSubview:_btn];

//    3-17夜 也许没用
//    CGFloat width = self.frame.size.width;;
//    UIView* tmp = [self viewWithTag:-1];
//    if (width - MARGIN - sz.width - tmp.frame.origin.x > self.resultCountLabel.frame.size.width + 20) {
//        self.resultCountLabel.hidden = NO;
//    }
}

- (void)setSearchResultCount:(NSInteger)count {
    if (count > 0) {
        self.resultCountLabel.text = self.type == SearchRole ? [NSString stringWithFormat:@"已有%ld个人认领了该角色", (long)count] : [NSString stringWithFormat:@"共%ld个分享", (long)count];
        [self.resultCountLabel sizeToFit];
        self.resultCountLabel.hidden = NO;
    } else {
        self.resultCountLabel.hidden = YES;
    }

}

+ (CGFloat)preferredHeight {
    return 80;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _btn.center = _btn.center;
    self.resultCountLabel.center = CGPointMake(CGRectGetMaxX(_btn.frame) + 10 + self.resultCountLabel.frame.size.width / 2, CGRectGetMidY(_btn.frame));
    _headerView.center = CGPointMake(CGRectGetWidth(self.contentView.frame) - CGRectGetWidth(_headerView.frame) / 2 - 20, CGRectGetMinY(self.contentView.frame));
    for (int i = 0; i < 3; i++) {
        UIView *view = (UIView*)[self viewWithTag:-3 + i];
        [view.subviews firstObject].hidden = YES;
    }
    for (int i = 0; i < self.imageArr.count; i++) {
        UIView *view = (UIView*)[self viewWithTag:-3 + i];
        [view.subviews firstObject].hidden = NO;
        [view.subviews firstObject].center = CGPointMake(CGRectGetWidth(view.frame) / 2, CGRectGetHeight(view.frame) / 2);
    }
}

- (UILabel *)resultCountLabel {
    if (_resultCountLabel == nil) {
        _resultCountLabel = [[UILabel alloc] init];
        _resultCountLabel.font = [UIFont systemFontOfSize:11.0];
        _resultCountLabel.textColor = TextColor;
        [self addSubview:_resultCountLabel];
    }
    return _resultCountLabel;
}
@end
