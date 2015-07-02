//
//  PhotoTagView.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 13/06/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "PhotoTagView.h"
#import "PhotoTagRoundPointLayer.h"
#import "PhotoTagTariangleLayer.h"

#define VER_MARGIN      10
#define HER_MARGIN      10

@interface PhotoTagView ()

@end

@implementation PhotoTagView {
    PhotoTagRoundPointLayer* pointLayer;
    PhotoTagTariangleLayer* triLayer;
    CATextLayer * contentLayer;
    CALayer* imgLayer;
    UIFont* font;
    CGSize content_size;
}

@synthesize status = _status;
@synthesize content = _content;
@synthesize type = _type;
@synthesize typeImg = _typeImg;

@synthesize offset_x = _offset_x;
@synthesize offset_y = _offset_y;

- (id)init {
    self = [super init];
    if (self) {
        [self setUpTagView];
    }
    
    return self;
}

- (id)initWithTagName:(NSString*)name {
    self = [super init];
    if (self) {
        self.content = name;
        [self setUpTagView];
    }
    
    return self;
}

- (id)initWithTagName:(NSString*)name andType:(TagType)type {
    self = [super init];
    if (self) {
        self.content = name;
        self.type = type;
        [self setUpTagView];
    }
    
    return self;
}

- (void)layoutSublayersOfLayer:(CALayer *)layer {
    if (layer == self.layer) {
        CGRect rect = [self getTagViewPreferBounds];
        imgLayer.position = CGPointMake(rect.origin.x + imgLayer.bounds.size.width / 2, rect.origin.y + rect.size.height / 2);
        
        rect.origin.x += imgLayer.bounds.size.width;
        CGRect point_bounds = [pointLayer getPreferRect];
        pointLayer.position = CGPointMake(rect.origin.x + point_bounds.size.width / 2, rect.origin.y + rect.size.height / 2);
        CGRect tri_bounds = [triLayer getPreferRect:content_size.height];
        triLayer.position = CGPointMake(rect.origin.x + tri_bounds.size.width / 2 + point_bounds.size.width / 2, rect.origin.y + rect.size.height / 2);
        contentLayer.position = CGPointMake(rect.size.width - contentLayer.bounds.size.width / 2, rect.origin.y + rect.size.height / 2);
    }
}

- (void)setContentAndFontSize:(NSString*)str {
    _content = str;
    font = [UIFont systemFontOfSize:17.f];
    content_size = [_content sizeWithFont:font constrainedToSize:CGSizeMake(FLT_MAX, FLT_MAX)];
}

- (void)setTypeImg:(UIImage *)typeImg {
    _typeImg = typeImg;
    imgLayer.contents = (id)_typeImg.CGImage;
}

- (UIImage*)getTypeImg {
    if (_typeImg == nil) {
        NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
        NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
       
        switch (_type) {
            case TagTypeLocation:
                _typeImg = [UIImage imageNamed:[resourceBundle pathForResource:@"Location" ofType:@"png"]];
                break;
            case TagTypeTime:
                _typeImg = [UIImage imageNamed:[resourceBundle pathForResource:@"Time" ofType:@"png"]];
                break;
            case TagTypeTags:
                _typeImg = [UIImage imageNamed:[resourceBundle pathForResource:@"Tag" ofType:@"png"]];
                break;
            default:
                break;
        }
    }
    return _typeImg;
}

- (void)setUpTagView {
   
    self.backgroundColor = [UIColor clearColor];
    
    pointLayer = [PhotoTagRoundPointLayer layer];
    pointLayer.bounds = [pointLayer getPreferRect];
    
    triLayer = [PhotoTagTariangleLayer layer];
    triLayer.bounds = [triLayer getPreferRect:content_size.height + VER_MARGIN];
    
    
    contentLayer = [CATextLayer layer];
    contentLayer.fontSize = [font pointSize];
    contentLayer.bounds = CGRectMake(0, 0, content_size.width + HER_MARGIN, content_size.height + VER_MARGIN);
    contentLayer.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.6].CGColor;
    contentLayer.foregroundColor = [UIColor whiteColor].CGColor;
    contentLayer.string= _content;
    
    imgLayer = [CALayer layer];
    imgLayer.bounds = CGRectMake(0, 0, content_size.height, content_size.height);
    
    [imgLayer setNeedsDisplay];
    [pointLayer setNeedsDisplay];
    [triLayer setNeedsDisplay];
    [contentLayer setNeedsDisplay];
   
    [self.layer addSublayer:imgLayer];
    [self.layer addSublayer:contentLayer];
    [self.layer addSublayer:triLayer];
    [self.layer addSublayer:pointLayer];

    // need to put it after setNeedsDisplay
    imgLayer.contents = (id)self.typeImg.CGImage;
    
    self.bounds = [self getTagViewPreferBounds];
}

- (CGRect)getTagViewPreferBounds {
    // size of point layer
    CGRect pointLayerRect = [pointLayer getPreferRect];
    
    // size of trangle layer
    CGRect triLayerRect = [triLayer getPreferRect:content_size.height];
    
    CGFloat width = imgLayer.bounds.size.width + pointLayerRect.size.width / 2 + triLayerRect.size.width + contentLayer.bounds.size.width + 5;
    CGFloat height = content_size.height + VER_MARGIN;
    return CGRectMake(0, 0, width, height);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
