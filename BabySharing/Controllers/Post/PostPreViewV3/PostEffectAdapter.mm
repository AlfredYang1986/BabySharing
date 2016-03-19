//
//  PostEffectAdapter.m
//  BabySharing
//
//  Created by Alfred Yang on 13/07/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "PostEffectAdapter.h"
#import "GPUImage.h"

#import "PhotoTagView.h"

#import "ImageFilterFactory.h"

#include <vector>
using std::vector;

struct tableNode {
    const char* title;
    int type;
    UIView* (*fp)(PostEffectAdapter*, CGFloat);
};

struct effectNode {
    const char* name;
    UIImage* (*fp)(UIImage*, PostEffectAdapter*);
};

struct movieEffectNode {
    const char* name;
    void (*fp)(PostEffectAdapter*);
};

struct tagNode {
    const char* name;
    TagType tag_type;
    void (*fp)(PostEffectAdapter*, UIImage*);
};

/*******************************************************************/
/**
 * not implement
 */
UIView* thisViewIsNotImplemented(CGFloat height) {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat margin = height / 4;
    CGFloat button_height = height / 2;

    UIView* reVal = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAX(width, 4 * (margin + button_height)), height)];
//    reVal.backgroundColor = [UIColor colorWithRed:0.9050 green:0.9050 blue:0.9050 alpha:1.f];
    reVal.backgroundColor = [UIColor colorWithWhite:0.1098 alpha:1.f];
    
    UILabel* label = [[UILabel alloc]init];
    label.text = @"This View is not implemented";
    [label sizeToFit];
    [reVal addSubview:label];
    label.center = CGPointMake(reVal.frame.size.width / 2, reVal.frame.size.height / 2);
    
    return reVal;
}

/*******************************************************************/

/*******************************************************************/
/**
 * for photos
 */
UIButton* addPhotoEffectBtn(NSString* title, CGRect bounds, CGPoint center, NSObject* callBackObj, SEL callBack, SEL callBack2 = nil) {
  
    if (callBack2 == nil) {
        callBack2 = callBack;
    }
    
    /**
     * it is magic, don't touch
     */
    UIButton* btn = [[UIButton alloc]initWithFrame:bounds];
    btn.center = center;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [btn addTarget:callBackObj action:callBack2 forControlEvents:UIControlEventTouchUpInside];
  
    /**
     * title text
     */
    CATextLayer* tl = [CATextLayer layer];
    tl.string = title;
    tl.foregroundColor = [UIColor whiteColor].CGColor; //[UIColor colorWithRed:0.1373 green:0.1255 blue:0.1216 alpha:1.f].CGColor;
    tl.backgroundColor = [UIColor clearColor].CGColor;
    tl.fontSize = 11.f;
    
    CGSize s = [title sizeWithFont:[UIFont systemFontOfSize:11.f] constrainedToSize:CGSizeMake(FLT_MAX, FLT_MAX)];
    tl.frame = CGRectMake(0, bounds.size.height - s.height, bounds.size.width, s.height);
    tl.alignmentMode = @"center";
    tl.contentsScale = 2.f;
    [btn.layer addSublayer:tl];

    /**
     * image preview
     */
    UIImage* img = [callBackObj performSelector:callBack withObject:btn];
//    CALayer * il = [CALayer layer];
    UIImageView* il = [[UIImageView alloc]init];
    CGFloat mar = 0;
    CGFloat len = MIN(bounds.size.height - s.height - mar, bounds.size.width);
    il.frame = CGRectMake((bounds.size.width - len) / 2, (bounds.size.height - s.height - mar - len) / 2, len, len);
//    il.contents = (id)img.CGImage;
    il.image = img;
//    il.cornerRadius = len / 2;
    il.layer.cornerRadius = 4.f;
    il.layer.borderColor = [UIColor colorWithRed:0.3126 green:0.7529 blue:0.6941 alpha:1.f].CGColor;
    if ([title isEqualToString:@"Origin"]) {
        il.layer.borderWidth = 2.f;
    } else {
        il.layer.borderWidth = 0.f;
    }
    il.layer.masksToBounds = YES;
//    [btn.layer addSublayer:il];
    il.tag = -5;
    [btn addSubview:il];
    btn.tag = -1;
    
    return btn;
}

UIView* addTagBtn(NSString* title, CGRect bounds, CGPoint center, NSObject* callBackObj, SEL callBack, UIImage* img) {

#define TAG_BTN_WIDTH                   50
#define TAG_BTN_HEIGHT                  50

#define TAG_ICON_WIDTH                  25
#define TAG_ICON_HEIGHT                 TAG_ICON_WIDTH
    
#define TAG_LABEL_WIDTH                 TAG_BTN_WIDTH
#define TAG_LABEL_HEIGHT                20
#define TAG_LABEL_FONT_SIXE             14.f

#define TAG_VIEW_WIDTH                  TAG_BTN_WIDTH
#define TAG_VIEW_HEIGHT                 TAG_BTN_HEIGHT + TAG_LABEL_HEIGHT

    UIView* reVal = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TAG_VIEW_WIDTH, TAG_VIEW_HEIGHT)];
    
    UIButton* tag_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, TAG_BTN_WIDTH, TAG_BTN_WIDTH)];
//    tag_btn.backgroundColor = [UIColor colorWithWhite:0.1098 alpha:0.7];
    tag_btn.layer.cornerRadius = TAG_BTN_WIDTH / 2;
    tag_btn.clipsToBounds = YES;
    tag_btn.titleLabel.text = title;
    tag_btn.titleLabel.hidden = YES;
    
    CALayer* icon = [CALayer layer];
    icon.contents = (id)img.CGImage;
//    icon.frame = CGRectMake(0, 0, TAG_ICON_WIDTH, TAG_ICON_HEIGHT);
    icon.frame = CGRectMake(0, 0, TAG_BTN_WIDTH, TAG_BTN_WIDTH);
    icon.position = CGPointMake(TAG_BTN_WIDTH / 2, TAG_BTN_HEIGHT / 2);
    [tag_btn.layer addSublayer:icon];
    
    [tag_btn addTarget:callBackObj action:callBack forControlEvents:UIControlEventTouchUpInside];
    [reVal addSubview:tag_btn];
    
    UILabel* tag_label = [[UILabel alloc] initWithFrame:CGRectMake(0, TAG_BTN_HEIGHT + 2, TAG_LABEL_WIDTH, TAG_LABEL_HEIGHT)];
    tag_label.font = [UIFont systemFontOfSize:14.f];
    tag_label.textColor = [UIColor whiteColor];

    tag_label.textAlignment = NSTextAlignmentCenter;
    tag_label.text = title;
    [reVal addSubview:tag_label];
    reVal.center = center;
    
    return reVal;
}

UIButton* addPasteBtn(CGRect bounds, CGPoint center, NSObject* callBackObj, SEL callBack, UIImage* img) {
    UIButton* btn = [[UIButton alloc]initWithFrame:bounds];
    btn.center = center;
    [btn setBackgroundImage:img forState:UIControlStateNormal];
    [btn addTarget:callBackObj action:callBack forControlEvents:UIControlEventTouchDown];
    
    btn.layer.borderWidth = 1.f;
    btn.layer.borderColor = [UIColor blueColor].CGColor;
    btn.layer.cornerRadius = 4.f;
    btn.clipsToBounds = YES;
    return btn;
}

UIView* effectFilterForPhoto(PostEffectAdapter* adapter, CGFloat height) {
    
    /**
     * 4 filter effect
     */
#define MAGIC_NUMBER    0.4f
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat margin = 0;
    CGFloat button_height = (height - 2 * margin) * MAGIC_NUMBER;

    CGFloat preferred_width = MIN(width, 5 * (margin + button_height));
    CGFloat edge_margin = ABS(width - preferred_width) / 2;
//    UIView* reVal = [[UIView alloc]initWithFrame:CGRectMake(0, 0, preferred_width, height)];
    UIView* reVal = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    reVal.backgroundColor = [UIColor colorWithWhite:0.1098 alpha:1.f];
//    reVal.backgroundColor = [UIColor darkGrayColor];
//    reVal.backgroundColor = [UIColor colorWithRed:0.9050 green:0.9050 blue:0.9050 alpha:1.f];
  
    [reVal addSubview:addPhotoEffectBtn(@"黑白", CGRectMake(0, 0, button_height, button_height), CGPointMake(edge_margin + margin + button_height / 2, height / 2), adapter, @selector(didSelectEffectFilterForPhoto:))];
    [reVal addSubview:addPhotoEffectBtn(@"exposure", CGRectMake(0, 0, button_height, button_height), CGPointMake(edge_margin + 2 * margin + button_height * 3/ 2, height / 2), adapter, @selector(didSelectEffectFilterForPhoto:))];
    [reVal addSubview:addPhotoEffectBtn(@"normal", CGRectMake(0, 0, button_height, button_height), CGPointMake(edge_margin + 3 * margin + button_height * 5/ 2, height / 2), adapter, @selector(didSelectEffectFilterForPhoto:))];
    [reVal addSubview:addPhotoEffectBtn(@"contrast", CGRectMake(0, 0, button_height, button_height), CGPointMake(edge_margin + 4 * margin + button_height * 7/ 2, height / 2), adapter, @selector(didSelectEffectFilterForPhoto:))];
    [reVal addSubview:addPhotoEffectBtn(@"group", CGRectMake(0, 0, button_height, button_height), CGPointMake(edge_margin + 5 * margin + button_height * 9/ 2, height / 2), adapter, @selector(didSelectEffectFilterForPhoto:))];

    return reVal;
}


UIView* tagForPhoto(PostEffectAdapter* adapter, CGFloat height) {
    
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];

    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat screen_height = [UIScreen mainScreen].bounds.size.height;
    CGFloat button_height = height / 3;

    UIView* reVal = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
//    reVal.backgroundColor = [UIColor colorWithRed:0.9050 green:0.9050 blue:0.9050 alpha:1.f];
//    reVal.backgroundColor = [UIColor darkGrayColor];
    reVal.backgroundColor = [UIColor colorWithWhite:0.1098 alpha:1.f];
    
   
    UILabel* label = [[UILabel alloc]init];
    label.text = @"记录时刻，标记生活";
    label.textColor = [UIColor lightGrayColor];
    [label sizeToFit];
    [reVal addSubview:label];
    label.center = CGPointMake(reVal.frame.size.width / 2, reVal.frame.size.height / 2);
    
#define FAKE_NAVIGATION_BAR_HEIGHT      64
#define FUNC_BAR_HEIGHT                 47
    
    CGFloat main_content_height = screen_height - FAKE_NAVIGATION_BAR_HEIGHT - FUNC_BAR_HEIGHT - height;
    
    UIView* bg = [[UIView alloc]initWithFrame:CGRectMake(0, FAKE_NAVIGATION_BAR_HEIGHT, width, main_content_height)];
    bg.tag = -9;
    bg.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.2f];
   
#define TAG_BTN_MARGIN_BETWEEN          (50 + TAG_BTN_WIDTH)
    [bg addSubview:addTagBtn(@"品牌", CGRectMake(0, 0, 3 * button_height, button_height), CGPointMake(bg.frame.size.width / 2 - TAG_BTN_MARGIN_BETWEEN, bg.frame.size.height / 2), adapter, @selector(didSelectTagForPhoto:), [UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"post_band_tag"] ofType:@"png"]])];
    
    [bg addSubview:addTagBtn(@"时刻", CGRectMake(0, 0, 3 * button_height, button_height), CGPointMake(bg.frame.size.width / 2, bg.frame.size.height / 2), adapter, @selector(didSelectTagForPhoto:), [UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"post_time_tag"] ofType:@"png"]])];
    
    [bg addSubview:addTagBtn(@"地点", CGRectMake(0, 0, 3 * button_height, button_height), CGPointMake(bg.frame.size.width / 2 + TAG_BTN_MARGIN_BETWEEN, bg.frame.size.height / 2), adapter, @selector(didSelectTagForPhoto:), [UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"post_location_tag"] ofType:@"png"]])];
    
    [adapter.content_parent_view addSubview:bg];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:adapter action:@selector(didSelectHideTagView:)];
    [bg addGestureRecognizer:tap];

    return reVal;
}

UIView* pasteForPhoto(PostEffectAdapter* adapter, CGFloat height) {
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat button_height = height / 2;
    
    UIView* reVal = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    reVal.backgroundColor = [UIColor colorWithRed:0.9050 green:0.9050 blue:0.9050 alpha:1.f];
    
    [reVal addSubview:addPasteBtn(CGRectMake(0, 0, button_height, button_height), CGPointMake(reVal.frame.size.width / 2 - 10 - 2 * button_height, reVal.frame.size.height / 2), adapter, @selector(didSelectPasteForPhoto:), [UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"Dice1"] ofType:@"png"]])];
    [reVal addSubview:addPasteBtn(CGRectMake(0, 0, button_height, button_height), CGPointMake(reVal.frame.size.width / 2, reVal.frame.size.height / 2), adapter, @selector(didSelectPasteForPhoto:), [UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"Dice2"] ofType:@"png"]])];
    [reVal addSubview:addPasteBtn(CGRectMake(0, 0, button_height, button_height), CGPointMake(reVal.frame.size.width / 2 + 10 + 2 * button_height, reVal.frame.size.height / 2), adapter, @selector(didSelectPasteForPhoto:), [UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"Dice2"] ofType:@"png"]])];
    
    return reVal;
}

UIView* toolForPhoto(PostEffectAdapter* adapter, CGFloat height) {
    return thisViewIsNotImplemented(height);
}
/*******************************************************************/

/*******************************************************************/
/**
 * for movies
 */
UIView* effectFilterForMovie(PostEffectAdapter* adapter, CGFloat height) {
    /**
     * 4 filter effect
     */
//#define MAGIC_NUMBER    0.4f
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat margin = 0;
    CGFloat button_height = (height - 2 * margin) * MAGIC_NUMBER;
    
    CGFloat preferred_width = MIN(width, 5 * (margin + button_height));
    CGFloat edge_margin = ABS(width - preferred_width) / 2;
    //    UIView* reVal = [[UIView alloc]initWithFrame:CGRectMake(0, 0, preferred_width, height)];
    UIView* reVal = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    reVal.backgroundColor = [UIColor colorWithWhite:0.1098 alpha:1.f];
    //    reVal.backgroundColor = [UIColor darkGrayColor];
    //    reVal.backgroundColor = [UIColor colorWithRed:0.9050 green:0.9050 blue:0.9050 alpha:1.f];
    
    [reVal addSubview:addPhotoEffectBtn(@"黑白", CGRectMake(0, 0, button_height, button_height), CGPointMake(edge_margin + margin + button_height / 2, height / 2), adapter, @selector(didSelectEffectFilterForPhoto:), @selector(didSelectEffectFilterForMovie:))];
    [reVal addSubview:addPhotoEffectBtn(@"exposure", CGRectMake(0, 0, button_height, button_height), CGPointMake(edge_margin + 2 * margin + button_height * 3/ 2, height / 2), adapter, @selector(didSelectEffectFilterForPhoto:), @selector(didSelectEffectFilterForMovie:))];
    [reVal addSubview:addPhotoEffectBtn(@"normal", CGRectMake(0, 0, button_height, button_height), CGPointMake(edge_margin + 3 * margin + button_height * 5/ 2, height / 2), adapter, @selector(didSelectEffectFilterForPhoto:), @selector(didSelectEffectFilterForMovie:))];
    [reVal addSubview:addPhotoEffectBtn(@"contrast", CGRectMake(0, 0, button_height, button_height), CGPointMake(edge_margin + 4 * margin + button_height * 7/ 2, height / 2), adapter, @selector(didSelectEffectFilterForPhoto:), @selector(didSelectEffectFilterForMovie:))];
    [reVal addSubview:addPhotoEffectBtn(@"group", CGRectMake(0, 0, button_height, button_height), CGPointMake(edge_margin + 5 * margin + button_height * 9/ 2, height / 2), adapter, @selector(didSelectEffectFilterForPhoto:), @selector(didSelectEffectFilterForMovie:))];
    
    return reVal;
}

UIView* editForMovie(PostEffectAdapter* adapter, CGFloat height) {
    return thisViewIsNotImplemented(height);
}

UIView* asserateForMovie(PostEffectAdapter* adapter, CGFloat height) {
    return thisViewIsNotImplemented(height);
}

UIView* coverForMovie(PostEffectAdapter* adapter, CGFloat height) {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    UIView* reVal = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    reVal.backgroundColor = [UIColor colorWithWhite:0.1098 alpha:1.f];
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:adapter.movie_url options:nil];
  
    /**
     * 1. get total length of the asset
     */
    CGFloat seconds = asset.duration.value / asset.duration.timescale;   // seconds
//    NSInteger steps = seconds > 10 ? 10 : seconds;
    NSInteger steps = 10;
    NSError *error = nil;
    CMTime actualTime;
    
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
   
    /**
     * 2. get thumb through movie
     */
    NSMutableArray* thumbs = [[NSMutableArray alloc]initWithCapacity:steps];
    for (int index = 0; index < steps; ++index) {
        CMTime time = CMTimeMakeWithSeconds(seconds / steps * index, 600);
        CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
        [thumbs addObject:[[UIImage alloc] initWithCGImage:image]];
        CGImageRelease(image);
    }
   
    /**
     * 3. create container view
     */
#define THUMB_SMALL_HEIGHT          31
#define THUMB_SMALL_WIDTH           THUMB_SMALL_HEIGHT

#define THUMB_LARGE_WIDTH           61
#define THUMB_LARGE_HEIGHT          THUMB_LARGE_WIDTH
    
    UIView* container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, THUMB_SMALL_WIDTH * steps, THUMB_SMALL_HEIGHT)];
   
    UIView* large = nil;
    for (int index = 0; index < steps; ++index) {
        UIImageView* tmp = [[UIImageView alloc]initWithFrame:CGRectMake(index * THUMB_SMALL_WIDTH, 0, THUMB_SMALL_WIDTH, THUMB_SMALL_HEIGHT)];
        tmp.image = [thumbs objectAtIndex:index];
        tmp.userInteractionEnabled = YES;
        tmp.tag = -999;
        [container addSubview:tmp];

        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:adapter action:@selector(didClickThumb:)];
        [tmp addGestureRecognizer:tap];
        
        if (index == 1) {
            CGPoint ct = tmp.center;
            tmp.bounds = CGRectMake(0, 0, THUMB_LARGE_WIDTH, THUMB_LARGE_HEIGHT);
            tmp.center = ct;
            
            tmp.layer.borderColor = [UIColor colorWithRed:0.2745 green:0.8566 blue:0.7922 alpha:1.f].CGColor;
            tmp.layer.borderWidth = 2.f;
          
            large = tmp;
        }
    }
   
    [container bringSubviewToFront:large];
    container.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, height / 2);
    
    [reVal addSubview:container];
    return reVal;
}

UIView* soundForMovie(PostEffectAdapter* adapter, CGFloat height) {
    return thisViewIsNotImplemented(height);
}

/*******************************************************************/

/*******************************************************************/
/**
 * photo effects
 */
UIImage* blackAndWhiteEffect(UIImage* source, PostEffectAdapter* obj) {
    GPUImagePicture* tmp = [[GPUImagePicture alloc]initWithImage:source];
    [tmp addTarget:obj.blackWhite];
    [obj.blackWhite useNextFrameForImageCapture];
    [tmp processImage];
    return [obj.blackWhite imageFromCurrentFramebuffer];
}

void blackAndWhiteEffectMovie(PostEffectAdapter* obj) {
    GPUImageMovie* m = [obj.delegate getInput];
    GPUImageView* v = [obj.delegate getOutput];
    
    [m endProcessing];
    [obj.blackWhite removeAllTargets];
    [m removeAllTargets];
    [m addTarget:obj.blackWhite];
    [obj.blackWhite addTarget:v];
    
    [m startProcessing];
}

UIImage* saturationEffect(UIImage* source, PostEffectAdapter* obj) {
    GPUImagePicture* tmp = [[GPUImagePicture alloc]initWithImage:source];
    [tmp addTarget:obj.saturation];
    [obj.saturation useNextFrameForImageCapture];
    [tmp processImage];
    return [obj.saturation imageFromCurrentFramebuffer];
}

void saturationEffectMovie(PostEffectAdapter* obj) {
    GPUImageMovie* m = [obj.delegate getInput];
    GPUImageView* v = [obj.delegate getOutput];

    [m endProcessing];
    [obj.saturation removeAllTargets];
    [m removeAllTargets];
    [m addTarget:obj.saturation];
    [obj.saturation addTarget:v];
    
    [m startProcessing];
}

UIImage* exposureEffect(UIImage* source, PostEffectAdapter* obj) {
    GPUImagePicture* tmp = [[GPUImagePicture alloc]initWithImage:source];
    [tmp addTarget:obj.exposure];
    [obj.exposure useNextFrameForImageCapture];
    [tmp processImage];
    return [obj.exposure imageFromCurrentFramebuffer];
}

void exposureEffectMovie(PostEffectAdapter* obj) {
    GPUImageMovie* m = [obj.delegate getInput];
    GPUImageView* v = [obj.delegate getOutput];
    
    [m endProcessing];
    [obj.exposure removeAllTargets];
    [m removeAllTargets];
    [m addTarget:obj.exposure];
    [obj.exposure addTarget:v];
    
    [m startProcessing];
}

UIImage* contrastEffect(UIImage* source, PostEffectAdapter* obj) {
    GPUImagePicture* tmp = [[GPUImagePicture alloc]initWithImage:source];
    [tmp addTarget:obj.contrast];
    [obj.contrast useNextFrameForImageCapture];
    [tmp processImage];
    return [obj.contrast imageFromCurrentFramebuffer];
}

void contrastEffectMovie(PostEffectAdapter* obj) {
    GPUImageMovie* m = [obj.delegate getInput];
    GPUImageView* v = [obj.delegate getOutput];
    
    [m endProcessing];
    [obj.contrast removeAllTargets];
    [m removeAllTargets];
    [m addTarget:obj.contrast];
    [obj.contrast addTarget:v];
    
    [m startProcessing];
}

UIImage* groupEffect(UIImage* source, PostEffectAdapter* obj) {
    GPUImagePicture* tmp = [[GPUImagePicture alloc]initWithImage:source];
    [tmp addTarget:obj.group];
    [obj.group useNextFrameForImageCapture];
    [tmp processImage];
    return [obj.group imageFromCurrentFramebuffer];
}

void groupEffectMovie(PostEffectAdapter* obj) {
    GPUImageMovie* m = [obj.delegate getInput];
    GPUImageView* v = [obj.delegate getOutput];
    
    [m endProcessing];
    [obj.group removeAllTargets];
    [m removeAllTargets];
    [m addTarget:obj.group];
    [obj.group addTarget:v];
    
    [m startProcessing];
}

UIImage* normalEffect(UIImage* source, PostEffectAdapter* obj) {
//    [obj.ip removeAllTargets];
//    [obj.ip addTarget:obj.normal];
//    [obj.normal useNextFrameForImageCapture];
//    [obj.ip processImage];
//    return [obj.normal imageFromCurrentFramebuffer];
    return source;
}

void normalEffectMovie(PostEffectAdapter* obj) {
    GPUImageMovie* m = [obj.delegate getInput];
    GPUImageView* v = [obj.delegate getOutput];
    
    [m endProcessing];
    [obj.normal removeAllTargets];
    [m removeAllTargets];
    [m addTarget:obj.normal];
    [obj.normal addTarget:v];
    
    [m startProcessing];
}
/*******************************************************************/

/*******************************************************************/
/**
 * tags
 */
void locationTagView(PostEffectAdapter* obj, UIImage* tag_img) {
    [obj.delegate queryTagContetnWithTagType:TagTypeLocation andImg:tag_img];
}

void timeTagView(PostEffectAdapter* obj, UIImage* tag_img) {
    [obj.delegate queryTagContetnWithTagType:TagTypeTime andImg:tag_img];
}

void otherTagView(PostEffectAdapter* obj, UIImage* tag_img) {
    [obj.delegate queryTagContetnWithTagType:TagTypeTags andImg:tag_img];
}

void brandTagView(PostEffectAdapter* obj, UIImage* tag_img) {
    [obj.delegate queryTagContetnWithTagType:TagTypeBrand andImg:tag_img];
}
/*******************************************************************/
@implementation PostEffectAdapter {
    // for effort of the image
//    GPUImagePicture* ip;
//    
//    // filters
//    GPUImageTiltShiftFilter* tiltShiftFilter;
//    GPUImageSketchFilter* sketchFilter;
//    GPUImageColorInvertFilter* colorInvertFilter;
//    GPUImageSmoothToonFilter* smoothToonFilter;
}

@synthesize movie_url = _movie_url;
@synthesize content_parent_view = _content_parent_view;
@synthesize delegate = _delegate;
//@synthesize ip = _ip;

//@synthesize originFilter = _originFilter;
//@synthesize tiltShiftFilter = _tiltShiftFilter;
//@synthesize sketchFilter = _sketchFilter;
//@synthesize colorInvertFilter = _colorInvertFilter;
//@synthesize smoothToonFilter = _smoothToonFilter;

@synthesize normal = _normal;
@synthesize saturation = _saturation;
@synthesize exposure = _exposure;
@synthesize contrast = _contrast;
@synthesize group = _group;

@synthesize blackWhite = _blackWhite;

- (void)setUp {
//    if ([_delegate currentType] == PostPreViewPhote) {
        if (_normal == nil) {
            _normal = [ImageFilterFactory normal];
        }
        
        if (_saturation == nil) {
            _saturation = [ImageFilterFactory saturation];
        }

        if (_blackWhite == nil) {
            _blackWhite = [ImageFilterFactory blackWhite];
        }
        
        if (_exposure == nil) {
            _exposure = [ImageFilterFactory exposure];
        }
        
        if (_contrast == nil) {
            _contrast = [ImageFilterFactory contrast];
        }
        
        if (_originFilter == nil) {
            _group = [ImageFilterFactory testGroup1];
        }
        
//        if (_ip == nil) {
//            _ip = [[GPUImagePicture alloc]initWithImage:[_delegate originImage]];
//        }
//    }
}

- (void)setProtocol:(id<PostEffectAdapterProtocol>)delegate {
    _delegate = delegate;
    [self setUp];
}

- (id)initWithDelegate:(id<PostEffectAdapterProtocol>)del {
    self = [super init];
    if (self) {
        self.delegate = del;
    }
    return self;
}

- (UIView*)getFunctionViewByTitle:(NSString*)title andType:(PostPreViewType)type andPreferedHeight:(CGFloat)height {

    static const vector<tableNode> vec = {
        /**
         * for photos
         */
        tableNode {"滤镜", 0, &effectFilterForPhoto},
        tableNode {"标签", 0, &tagForPhoto},
        tableNode {"贴图", 0, &pasteForPhoto},
        tableNode {"工具", 0, &toolForPhoto},
        
        /**
         * for movies
         */
        tableNode {"滤镜", 1, &effectFilterForMovie},
        tableNode {"剪切", 1, &editForMovie},
        tableNode {"变速", 1, &asserateForMovie},
        tableNode {"封面", 1, &coverForMovie},
        tableNode {"声音", 1, &soundForMovie},
    };
   
    UIView* result = nil;
    for (int index = 0; index < vec.size(); ++index) {
        if (strcmp([title UTF8String], vec[index].title) == 0 && type == vec[index].type) {
            result = vec[index].fp(self, height);
            break;
        }
    }
    return result;
}

- (void)didSelectEffectFilterForMovie:(UIButton*)sender {
    static const vector<movieEffectNode> vec = {
        movieEffectNode{"黑白", &blackAndWhiteEffectMovie},
        movieEffectNode{"saturation", &saturationEffectMovie},
        movieEffectNode{"exposure", &exposureEffectMovie},
        movieEffectNode{"contrast", &contrastEffectMovie},
        movieEffectNode{"group", &groupEffectMovie},
        movieEffectNode{"normal", &normalEffectMovie},
    };
    
    for (UIView* tmp in sender.superview.subviews) {
        UIView* img = [tmp viewWithTag:-5];
        img.layer.borderWidth = 2.f;
    }
    
    for (int index = 0; index < vec.size(); ++index) {
        if (strcmp([sender.titleLabel.text UTF8String], vec[index].name) == 0) {
            vec[index].fp(self);
            break;
        }
    }
}

- (UIImage*)didSelectEffectFilterForPhoto:(UIButton*)sender {
    static const vector<effectNode> vec = {
        effectNode{"黑白", &blackAndWhiteEffect},
        effectNode{"saturation", &saturationEffect},
        effectNode{"exposure", &exposureEffect},
        effectNode{"contrast", &contrastEffect},
        effectNode{"group", &groupEffect},
        effectNode{"normal", &normalEffect},
    };
  
    for (UIView* tmp in sender.superview.subviews) {
        UIView* img = [tmp viewWithTag:-5];
        img.layer.borderWidth = 0.f;
    }
   
    UIView* img_c = [sender viewWithTag:-5];
    img_c.layer.borderWidth = 2.f;
    
    UIImage* result = nil;
    for (int index = 0; index < vec.size(); ++index) {
        if (strcmp([sender.titleLabel.text UTF8String], vec[index].name) == 0) {
            if ([_delegate currentType] == PostPreViewMovie) {
                result = vec[index].fp([self getMovieThumb], self);
            } else {
                result = vec[index].fp([_delegate originImage], self);
            }
            break;
        }
    }
    if (result && sender.tag < 0) {
        [_delegate imageWithEffect:result];
    }
    return result;
}

- (void)didSelectTagForPhoto:(UIButton*)sender {
    static const vector<tagNode> vec = {
        tagNode{"地点", TagTypeLocation, &locationTagView},
        tagNode{"时刻", TagTypeTime, &timeTagView},
        tagNode{"标签", TagTypeTags, &otherTagView},
        tagNode{"品牌", TagTypeBrand, &brandTagView},
    };
    
    for (int index = 0; index < vec.size(); ++index) {
        if (strcmp([sender.titleLabel.text UTF8String], vec[index].name) == 0) {
            vec[index].fp(self, sender.imageView.image);
            break;
        }
    }
}

- (void)didSelectPasteForPhoto:(UIButton*)sender {
    [_delegate pasteWithImage:[sender backgroundImageForState:UIControlStateNormal]];
}

- (void)didSelectHideTagView:(UITapGestureRecognizer*)gesture {
    gesture.view.hidden = YES;
}

- (void)didClickThumb:(UITapGestureRecognizer*)gesture {
    /**
     * 1. 变小所有
     */
    UIView* container = gesture.view.superview;
    for (UIView* tmp in container.subviews) {
        CGPoint ct = tmp.center;
        tmp.bounds = CGRectMake(0, 0, THUMB_SMALL_WIDTH, THUMB_SMALL_HEIGHT);
        tmp.center = ct;
        
        tmp.layer.borderWidth = 0.f;
    }
   
    /**
     * 2. 变大一个
     */
    CGPoint ct = gesture.view.center;
    gesture.view.bounds = CGRectMake(0, 0, THUMB_LARGE_WIDTH, THUMB_LARGE_HEIGHT);
    gesture.view.center = ct;
    [container bringSubviewToFront:gesture.view];
    
    gesture.view.layer.borderWidth = 2.f;
    gesture.view.layer.borderColor = [UIColor colorWithRed:0.2745 green:0.8566 blue:0.7922 alpha:1.f].CGColor;
    
    [_delegate didChangeCoverPage:((UIImageView*)gesture.view).image];
}

//- (UIImage*)getMovieThumbWithView:(UIView*)view {
- (UIImage*)getMovieThumb {
    UIView* view = [_delegate queryViewWithTitle:@"封面"];
    UIImageView* tmp = [view viewWithTag:-999];
    return tmp.image;
}
@end