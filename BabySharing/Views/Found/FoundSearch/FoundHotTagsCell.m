//
//  FoundHotTagsCell.m
//  BabySharing
//
//  Created by Alfred Yang on 8/12/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import "FoundHotTagsCell.h"
#import "RecommandTag.h"
#import "RecommandRoleTag.h"
#import "FoundHotTagBtn.h"
#import "Tools.h"
#import "Define.h"

#define MARGIN                  13
#define MARGIN_VER              12

// 内部
#define ICON_WIDTH              12
#define ICON_HEIGHT             12

#define TAG_HEIGHT              25
#define TAG_MARGIN              10
#define TAG_CORDIUS             5
#define TAG_MARGIN_BETWEEN      10.5

#define PREFERRED_HEIGHT        62

@implementation FoundHotTagsCell {
    CALayer* line;
}

@synthesize isDarkTheme = _isDarkTheme;
@synthesize isHiddenSepline = _isHiddenSepline;
@synthesize ver_margin = _ver_margin;
@synthesize delegate = _delegate;

- (id)init {
    self = [super init];
    if (self) {
        line = [CALayer layer];
        line.borderWidth = 1.f;
        line.borderColor = [UIColor colorWithWhite:0.5922 alpha:0.25].CGColor;
        line.frame = CGRectMake(0, PREFERRED_HEIGHT - 1, [UIScreen mainScreen].bounds.size.width, 1);
//        [self.layer addSublayer:line];
        
        _ver_margin = MARGIN_VER;
    }
    return self;   
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        line = [CALayer layer];
        line.borderWidth = 1.f;
        line.borderColor = [UIColor colorWithWhite:0.5922 alpha:0.25].CGColor;
        line.frame = CGRectMake(0, PREFERRED_HEIGHT - 1, [UIScreen mainScreen].bounds.size.width, 1);
//        [self.layer addSublayer:line];

        _ver_margin = MARGIN_VER;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)preferredHeight {
    return PREFERRED_HEIGHT;
}

+ (CGFloat)preferredHeightWithTags:(NSArray*)arr {
    return PREFERRED_HEIGHT;
}

- (void)setHiddenLine:(BOOL)b {
    _isHiddenSepline = b;
    line.hidden = _isHiddenSepline;
}

- (void)setHotTagsText:(NSArray *)arr {
    [self clearAllTags];
    
    int index = 0;
    CGFloat offset = 0;
    for (NSString* tmp in arr) {
        
        UIFont* font = [UIFont systemFontOfSize:16.f];
        CGSize sz_font = [tmp sizeWithFont:font constrainedToSize:CGSizeMake(FLT_MAX, FLT_MAX)];
        CGSize sz = CGSizeMake(TAG_MARGIN /*+ ICON_WIDTH*/ + sz_font.width + TAG_MARGIN, TAG_HEIGHT);
        
        FoundHotTagBtn* btn = [[FoundHotTagBtn alloc]initWithFrame:CGRectMake(0, 0, sz.width, sz.height + 4)];
        btn.tag_name = tmp;//.tag_name;
        
        UILabel* label = [[UILabel alloc] init];
        label.font = font;
        label.text = tmp; //tmp.tag_name;
//        label.textColor = _isDarkTheme ? [UIColor whiteColor] : [UIColor brownColor];
        label.textColor = TextColor;
        label.frame = CGRectMake(TAG_MARGIN /*+ ICON_WIDTH*/, 0 + 2, sz_font.width, TAG_HEIGHT);
        label.textAlignment = NSTextAlignmentLeft;
        [btn addSubview:label];
        
        btn.layer.borderColor = _isDarkTheme ? [UIColor whiteColor].CGColor : TextColor.CGColor;
        btn.layer.borderWidth = 1.f;
        btn.layer.cornerRadius = TAG_CORDIUS;
        btn.clipsToBounds = YES;
        
        //        btn.center = CGPointMake(MARGIN + btn.frame.size.width / 2 + index * (MARGIN + btn.frame.size.width), MARGIN_VER + btn.frame.size.height / 2);
        btn.center = CGPointMake(MARGIN + btn.frame.size.width / 2 + offset, _ver_margin + btn.frame.size.height / 2 + 3);
        offset += btn.frame.size.width + TAG_MARGIN_BETWEEN;
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(roleTagBtnSelected:)];
        [btn addGestureRecognizer:tap];
        
        if (offset >= [UIScreen mainScreen].bounds.size.width - 10)
            break;
        
        [self addSubview:btn];
        ++index;
    }
}

- (void)setHotTagsTest:(NSArray*)arr {

    [self clearAllTags];

    int index = 0;
    CGFloat offset = 0;
    for (RecommandRoleTag* tmp in arr) {
        
        UIFont* font = [UIFont systemFontOfSize:11.f];
//        CGSize sz_font = [tmp.tag_name sizeWithFont:font constrainedToSize:CGSizeMake(FLT_MAX, FLT_MAX)];
        CGSize size = CGSizeMake(320, 2000); //设置一个行高上限
        NSDictionary *attribute = @{NSFontAttributeName: font};
        CGSize sz_font = [tmp.tag_name boundingRectWithSize:size options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        CGSize sz = CGSizeMake(TAG_MARGIN /*+ ICON_WIDTH*/ + sz_font.width + TAG_MARGIN, TAG_HEIGHT);
        
        FoundHotTagBtn* btn = [[FoundHotTagBtn alloc]initWithFrame:CGRectMake(0, 0, sz.width, sz.height)];
        btn.tag_name = tmp.tag_name;
       
        UILabel* label = [[UILabel alloc]init];
        label.font = font;
        label.text = tmp.tag_name;
//        label.textColor = _isDarkTheme ? [UIColor whiteColor] : [UIColor brownColor];
        label.textColor = _isDarkTheme ? [UIColor whiteColor] : TextColor;
        label.frame = CGRectMake(TAG_MARGIN /*+ ICON_WIDTH*/, 0, sz_font.width, TAG_HEIGHT);
        label.textAlignment = NSTextAlignmentLeft;
        [btn addSubview:label];
        
        btn.layer.borderColor = _isDarkTheme ?[UIColor whiteColor].CGColor : [UIColor colorWithWhite:0.5922 alpha:1.0f].CGColor;
        btn.layer.borderWidth = 1.f;
        btn.layer.cornerRadius = TAG_CORDIUS;
        btn.clipsToBounds = YES;
        
//        btn.center = CGPointMake(MARGIN + btn.frame.size.width / 2 + index * (MARGIN + btn.frame.size.width), MARGIN_VER + btn.frame.size.height / 2);
//        btn.center = CGPointMake(MARGIN + btn.frame.size.width / 2 + offset, _ver_margin + btn.frame.size.height / 2);
        btn.center = CGPointMake(MARGIN + btn.frame.size.width / 2 + offset, 66 / 2 - 10);
        offset += btn.frame.size.width + TAG_MARGIN_BETWEEN;

        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(roleTagBtnSelected:)];
        [btn addGestureRecognizer:tap];
        
        if (offset >= [UIScreen mainScreen].bounds.size.width - 10)
            break;
        
        [self addSubview:btn];
        ++index;
    }
}

- (void)setHotTags:(NSArray*)arr {
    
    [self clearAllTags];
    
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
    

    int index = 0;
    CGFloat offset = 0;
    for (RecommandTag* tmp in arr) {
        UIFont* font = [UIFont systemFontOfSize:11.f];
        
        CGSize size = CGSizeMake(320, 2000); //设置一个行高上限
        NSDictionary *attribute = @{NSFontAttributeName: font};
        CGSize sz_font = [tmp.tag_name boundingRectWithSize:size options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
//        CGSize sz_font = [tmp.tag_name sizeWithFont:font constrainedToSize:CGSizeMake(FLT_MAX, FLT_MAX)];
        CGSize sz = CGSizeMake(TAG_MARGIN + ICON_WIDTH + sz_font.width + TAG_MARGIN, TAG_HEIGHT);
        
//        UIView* btn = [[UIView alloc]initWithFrame:CGRectMake(0, 0, sz.width, sz.height)];
        FoundHotTagBtn* btn = [[FoundHotTagBtn alloc]initWithFrame:CGRectMake(0, 0, sz.width, sz.height)];
        btn.tag_name = tmp.tag_name;
        btn.tag_type = tmp.tag_type.intValue;
        
        UIImageView* img = [[UIImageView alloc] initWithFrame:CGRectMake(TAG_MARGIN / 2, TAG_MARGIN / 4, ICON_WIDTH, ICON_HEIGHT)];
        img.center = CGPointMake(TAG_MARGIN / 2 + img.frame.size.width / 2, TAG_HEIGHT / 2 + 1);
        if (tmp.tag_type.integerValue == 0) {
            img.image = image0;
        } else if (tmp.tag_type.integerValue == 1) {
            img.image = image1;
        } else if (tmp.tag_type.integerValue == 3){
            img.image = image2;
        }
    
        [btn addSubview:img];
        
        UILabel* label = [[UILabel alloc]init];
        label.font = font;
        label.text = tmp.tag_name;
//        label.textColor = [UIColor colorWithWhite:0.3059 alpha:1.f];
        label.textColor = [UIColor colorWithRed:74.0 / 255.0 green:74.0 / 255.0 blue:74.0 / 255.0 alpha:0.9f];
        label.frame = CGRectMake(TAG_MARGIN + ICON_WIDTH, 0, sz_font.width, TAG_HEIGHT);
        label.textAlignment = NSTextAlignmentLeft;
        [btn addSubview:label];
        
//        btn.layer.borderColor = [UIColor colorWithWhite:0.6078 alpha:1.f].CGColor;
        btn.layer.borderColor = [UIColor colorWithRed:74.0 / 255.0 green:74.0 / 255.0 blue:74.0 / 255.0 alpha:0.45f].CGColor;
        btn.layer.borderWidth = 1.f;
        btn.layer.cornerRadius = TAG_CORDIUS;
        btn.clipsToBounds = YES;
        
//        btn.center = CGPointMake(MARGIN + btn.frame.size.width / 2 + index * (MARGIN + btn.frame.size.width), MARGIN_VER + btn.frame.size.height / 2);
//        btn.center = CGPointMake(MARGIN + btn.frame.size.width / 2 + offset, _ver_margin + btn.frame.size.height / 2);
        btn.center = CGPointMake(MARGIN + btn.frame.size.width / 2 + offset, 66 / 2 - 10
                                 );
        offset += btn.frame.size.width + TAG_MARGIN_BETWEEN;
        
        if (offset >= [UIScreen mainScreen].bounds.size.width - 10)
            break;
       
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tagBtnSelected:)];
        [btn addGestureRecognizer:tap];
        
        [self addSubview:btn];
        ++index;
    }
}

- (void)clearAllTags {
    while (self.subviews.count > 0) {
        [self.subviews.firstObject removeFromSuperview];
    }
}

- (void)tagBtnSelected:(UITapGestureRecognizer*)tap {
    FoundHotTagBtn* tmp = (FoundHotTagBtn*)tap.view;
    [_delegate recommandTagBtnSelected:tmp.tag_name adnType:tmp.tag_type];
}

- (void)roleTagBtnSelected:(UITapGestureRecognizer*)tap {
    FoundHotTagBtn* tmp = (FoundHotTagBtn*)tap.view;
    [_delegate recommandRoleTagBtnSelected:tmp.tag_name];
}
@end
