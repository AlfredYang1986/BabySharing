//
//  FoundHotTagsCell.m
//  BabySharing
//
//  Created by Alfred Yang on 8/12/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import "FoundHotTagsCell.h"
#import "RecommandTag.h"

#define MARGIN 13
#define MARGIN_VER 16

// 内部
#define ICON_WIDTH 15
#define ICON_HEIGHT 15

#define TAG_HEIGHT 20
#define TAG_MARGIN 10

@implementation FoundHotTagsCell

@synthesize isDarkTheme = _isDarkTheme;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)preferredHeight {
    return 44;
}

- (void)setHotTagsTest:(NSArray*)arr {
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    
    UIImage* image0 = [UIImage imageNamed:[resourceBundle pathForResource:@"tag-time" ofType:@"png"]];
    UIImage* image1 = [UIImage imageNamed:[resourceBundle pathForResource:@"tag-location" ofType:@"png"]];
    int index = 0;
    for (NSString* tmp in arr) {
        
        UIFont* font = [UIFont systemFontOfSize:11.f];
//        CGSize sz_font = [tmp.tag_name sizeWithFont:font constrainedToSize:CGSizeMake(FLT_MAX, FLT_MAX)];
        CGSize sz_font = [tmp sizeWithFont:font constrainedToSize:CGSizeMake(FLT_MAX, FLT_MAX)];
        CGSize sz = CGSizeMake(TAG_MARGIN + ICON_WIDTH + sz_font.width + TAG_MARGIN, TAG_HEIGHT);
        
        UIView* btn = [[UIView alloc]initWithFrame:CGRectMake(0, 0, sz.width, sz.height)];
        
        UIImageView* img = [[UIImageView alloc]initWithFrame:CGRectMake(TAG_MARGIN / 2, TAG_MARGIN / 4, ICON_WIDTH, ICON_HEIGHT)];
//        if (tmp.tag_type.integerValue == 0)
//            img.image = image0;
//        else
            img.image = image1;
        
        [btn addSubview:img];
        
        UILabel* label = [[UILabel alloc]init];
        label.font = font;
        label.text = tmp; //tmp.tag_name;
        label.textColor = _isDarkTheme ? [UIColor whiteColor] : [UIColor brownColor];
        label.frame = CGRectMake(TAG_MARGIN + ICON_WIDTH, 0, sz_font.width, TAG_HEIGHT);
        label.textAlignment = NSTextAlignmentLeft;
        [btn addSubview:label];
        
        btn.layer.borderColor = _isDarkTheme ?[UIColor whiteColor].CGColor : [UIColor brownColor].CGColor;
        btn.layer.borderWidth = 1.f;
        btn.layer.cornerRadius = btn.frame.size.height / 2;
        btn.clipsToBounds = YES;
        
        btn.center = CGPointMake(MARGIN + btn.frame.size.width / 2 + index * (MARGIN + btn.frame.size.width), MARGIN_VER + btn.frame.size.height / 2);
        [self addSubview:btn];
        ++index;
    }
}

- (void)setHotTags:(NSArray*)arr {
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    
    UIImage* image0 = [UIImage imageNamed:[resourceBundle pathForResource:@"tag-time" ofType:@"png"]];
    UIImage* image1 = [UIImage imageNamed:[resourceBundle pathForResource:@"tag-location" ofType:@"png"]];
    int index = 0;
    for (RecommandTag* tmp in arr) {
       
        UIFont* font = [UIFont systemFontOfSize:11.f];
        CGSize sz_font = [tmp.tag_name sizeWithFont:font constrainedToSize:CGSizeMake(FLT_MAX, FLT_MAX)];
        CGSize sz = CGSizeMake(TAG_MARGIN + ICON_WIDTH + sz_font.width + TAG_MARGIN, TAG_HEIGHT);
        
        UIView* btn = [[UIView alloc]initWithFrame:CGRectMake(0, 0, sz.width, sz.height)];
        
        UIImageView* img = [[UIImageView alloc]initWithFrame:CGRectMake(TAG_MARGIN / 2, TAG_MARGIN / 4, ICON_WIDTH, ICON_HEIGHT)];
        if (tmp.tag_type.integerValue == 0)
            img.image = image0;
        else
            img.image = image1;
        
        [btn addSubview:img];
        
        UILabel* label = [[UILabel alloc]init];
        label.font = font;
        label.text = tmp.tag_name;
        label.textColor = [UIColor brownColor];
        label.frame = CGRectMake(TAG_MARGIN + ICON_WIDTH, 0, sz_font.width, TAG_HEIGHT);
        label.textAlignment = NSTextAlignmentLeft;
        [btn addSubview:label];
        
        btn.layer.borderColor = [UIColor brownColor].CGColor;
        btn.layer.borderWidth = 1.f;
        btn.layer.cornerRadius = btn.frame.size.height / 2;
        btn.clipsToBounds = YES;
        
        btn.center = CGPointMake(MARGIN + btn.frame.size.width / 2 + index * (MARGIN + btn.frame.size.width), MARGIN_VER + btn.frame.size.height / 2);
        [self addSubview:btn];
        ++index;
    }
}

@end
