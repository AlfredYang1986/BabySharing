//
//  FoundHotTagsCell.m
//  BabySharing
//
//  Created by Alfred Yang on 8/12/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import "FoundHotTagsCell.h"
#import "RecommandTag.h"

#define MARGIN                  13
#define MARGIN_VER              12

// 内部
#define ICON_WIDTH              11
#define ICON_HEIGHT             11

#define TAG_HEIGHT              25
#define TAG_MARGIN              10
#define TAG_CORDIUS             5
#define TAG_MARGIN_BETWEEN      10.5

#define PREFERRED_HEIGHT        62

@implementation FoundHotTagsCell

@synthesize isDarkTheme = _isDarkTheme;

- (id)init {
    self = [super init];
    if (self) {
        CALayer* layer = [CALayer layer];
        layer.borderWidth = 1.f;
        layer.borderColor = [UIColor colorWithWhite:0.5922 alpha:0.25].CGColor;
        layer.frame = CGRectMake(0, PREFERRED_HEIGHT - 1, [UIScreen mainScreen].bounds.size.width, 1);
        [self.layer addSublayer:layer];
    }
    return self;   
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CALayer* layer = [CALayer layer];
        layer.borderWidth = 1.f;
        layer.borderColor = [UIColor colorWithWhite:0.5922 alpha:0.25].CGColor;
        layer.frame = CGRectMake(0, PREFERRED_HEIGHT - 1, [UIScreen mainScreen].bounds.size.width, 1);
        [self.layer addSublayer:layer];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code

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

- (void)setHotTagsTest:(NSArray*)arr {

    int index = 0;
    CGFloat offset = 0;
    for (NSString* tmp in arr) {
        
        UIFont* font = [UIFont systemFontOfSize:11.f];
        CGSize sz_font = [tmp sizeWithFont:font constrainedToSize:CGSizeMake(FLT_MAX, FLT_MAX)];
        CGSize sz = CGSizeMake(TAG_MARGIN /*+ ICON_WIDTH*/ + sz_font.width + TAG_MARGIN, TAG_HEIGHT);
        
        UIView* btn = [[UIView alloc]initWithFrame:CGRectMake(0, 0, sz.width, sz.height)];
       
        UILabel* label = [[UILabel alloc]init];
        label.font = font;
        label.text = tmp; //tmp.tag_name;
        label.textColor = _isDarkTheme ? [UIColor whiteColor] : [UIColor brownColor];
        label.frame = CGRectMake(TAG_MARGIN /*+ ICON_WIDTH*/, 0, sz_font.width, TAG_HEIGHT);
        label.textAlignment = NSTextAlignmentLeft;
        [btn addSubview:label];
        
        btn.layer.borderColor = _isDarkTheme ?[UIColor whiteColor].CGColor : [UIColor colorWithWhite:0.5922 alpha:1.f].CGColor;
        btn.layer.borderWidth = 1.f;
        btn.layer.cornerRadius = TAG_CORDIUS;
        btn.clipsToBounds = YES;
        
//        btn.center = CGPointMake(MARGIN + btn.frame.size.width / 2 + index * (MARGIN + btn.frame.size.width), MARGIN_VER + btn.frame.size.height / 2);
        btn.center = CGPointMake(MARGIN + btn.frame.size.width / 2 + offset, MARGIN_VER + btn.frame.size.height / 2);
        offset += btn.frame.size.width + TAG_MARGIN_BETWEEN;

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
    
    UIImage* image0 = [UIImage imageNamed:[resourceBundle pathForResource:@"tag_time_dark" ofType:@"png"]];
    UIImage* image1 = [UIImage imageNamed:[resourceBundle pathForResource:@"tag_location_dark" ofType:@"png"]];
    int index = 0;
    CGFloat offset = 0;
    for (RecommandTag* tmp in arr) {
       
        UIFont* font = [UIFont systemFontOfSize:11.f];
        CGSize sz_font = [tmp.tag_name sizeWithFont:font constrainedToSize:CGSizeMake(FLT_MAX, FLT_MAX)];
        CGSize sz = CGSizeMake(TAG_MARGIN + ICON_WIDTH + sz_font.width + TAG_MARGIN, TAG_HEIGHT);
        
        UIView* btn = [[UIView alloc]initWithFrame:CGRectMake(0, 0, sz.width, sz.height)];
        
        UIImageView* img = [[UIImageView alloc]initWithFrame:CGRectMake(TAG_MARGIN / 2, TAG_MARGIN / 4, ICON_WIDTH, ICON_HEIGHT)];
        img.center = CGPointMake(TAG_MARGIN / 2 + img.frame.size.width / 2, TAG_HEIGHT / 2);
        if (tmp.tag_type.integerValue == 0)
            img.image = image0;
        else
            img.image = image1;
        
        [btn addSubview:img];
        
        UILabel* label = [[UILabel alloc]init];
        label.font = font;
        label.text = tmp.tag_name;
        label.textColor = [UIColor colorWithWhite:0.3059 alpha:1.f];
        label.frame = CGRectMake(TAG_MARGIN + ICON_WIDTH, 0, sz_font.width, TAG_HEIGHT);
        label.textAlignment = NSTextAlignmentLeft;
        [btn addSubview:label];
        
        btn.layer.borderColor = [UIColor colorWithWhite:0.6078 alpha:1.f].CGColor;
        btn.layer.borderWidth = 1.f;
        btn.layer.cornerRadius = TAG_CORDIUS;
        btn.clipsToBounds = YES;
        
//        btn.center = CGPointMake(MARGIN + btn.frame.size.width / 2 + index * (MARGIN + btn.frame.size.width), MARGIN_VER + btn.frame.size.height / 2);
        btn.center = CGPointMake(MARGIN + btn.frame.size.width / 2 + offset, MARGIN_VER + btn.frame.size.height / 2);
        offset += btn.frame.size.width + TAG_MARGIN_BETWEEN;
        
        if (offset >= [UIScreen mainScreen].bounds.size.width - 10)
            break;
        
        [self addSubview:btn];
        ++index;
    }
}

- (void)clearAllTags {
    while (self.subviews.count > 0) {
        [self.subviews.firstObject removeFromSuperview];
    }
}
@end
