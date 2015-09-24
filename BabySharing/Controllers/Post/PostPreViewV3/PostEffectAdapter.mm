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
    reVal.backgroundColor = [UIColor grayColor];
    
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
UIButton* addPhotoEffectBtn(NSString* title, CGRect bounds, CGPoint center, NSObject* callBackObj, SEL callBack) {
   
    /**
     * it is magic, don't touch
     */
    UIButton* btn = [[UIButton alloc]initWithFrame:bounds];
    btn.center = center;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [btn addTarget:callBackObj action:callBack forControlEvents:UIControlEventTouchDown];
  
    /**
     * title text
     */
    CATextLayer* tl = [CATextLayer layer];
    tl.string = title;
    tl.foregroundColor = [UIColor colorWithRed:0.1373 green:0.1255 blue:0.1216 alpha:1.f].CGColor;
    tl.backgroundColor = [UIColor clearColor].CGColor;
    tl.fontSize = 11.f;
    
    CGSize s = [title sizeWithFont:[UIFont systemFontOfSize:11.f] constrainedToSize:CGSizeMake(FLT_MAX, FLT_MAX)];
    tl.frame = CGRectMake(0, bounds.size.height - s.height, bounds.size.width, s.height);
    tl.alignmentMode = @"center";
    [btn.layer addSublayer:tl];

    /**
     * image preview
     */
    UIImage* img = [callBackObj performSelector:callBack withObject:btn];
    CALayer * il = [CALayer layer];
    CGFloat mar = 0;
    CGFloat len = MIN(bounds.size.height - s.height - mar, bounds.size.width);
    il.frame = CGRectMake((bounds.size.width - len) / 2, (bounds.size.height - s.height - mar - len) / 2, len, len);
    il.contents = (id)img.CGImage;
    il.cornerRadius = len / 2;
    il.masksToBounds = YES;
    [btn.layer addSublayer:il];
    
    btn.tag = -1;
    return btn;
}

UIButton* addTagBtn(NSString* title, CGRect bounds, CGPoint center, NSObject* callBackObj, SEL callBack, UIImage* img) {

    UIButton* btn = [[UIButton alloc]initWithFrame:bounds];
    btn.center = center;
    [btn setImage:img forState:UIControlStateNormal];
    [btn addTarget:callBackObj action:callBack forControlEvents:UIControlEventTouchDown];
    [btn setTitle:title forState:UIControlStateNormal];
    
//    btn.layer.borderWidth = 1.f;
//    btn.layer.borderColor = [UIColor blueColor].CGColor;
    return btn;
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
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat margin = 10;
    CGFloat button_height = height - 2 * margin;

    UIView* reVal = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAX(width, 4 * (margin + button_height)), height)];
    reVal.backgroundColor = [UIColor colorWithRed:0.9050 green:0.9050 blue:0.9050 alpha:1.f];
  
    [reVal addSubview:addPhotoEffectBtn(@"Tilt", CGRectMake(0, 0, button_height, button_height), CGPointMake(margin + button_height / 2, height / 2), adapter, @selector(didSelectEffectFilterForPhoto:))];
    [reVal addSubview:addPhotoEffectBtn(@"Sketch", CGRectMake(0, 0, button_height, button_height), CGPointMake(2 * margin + button_height * 3/ 2, height / 2), adapter, @selector(didSelectEffectFilterForPhoto:))];
    [reVal addSubview:addPhotoEffectBtn(@"Color", CGRectMake(0, 0, button_height, button_height), CGPointMake(3 * margin + button_height * 5/ 2, height / 2), adapter, @selector(didSelectEffectFilterForPhoto:))];
    [reVal addSubview:addPhotoEffectBtn(@"Smooth", CGRectMake(0, 0, button_height, button_height), CGPointMake(4 * margin + button_height * 7/ 2, height / 2), adapter, @selector(didSelectEffectFilterForPhoto:))];

    return reVal;
}


UIView* tagForPhoto(PostEffectAdapter* adapter, CGFloat height) {
    
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];

    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat button_height = height / 3;

    UIView* reVal = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    reVal.backgroundColor = [UIColor grayColor];
    
    [reVal addSubview:addTagBtn(@"地点", CGRectMake(0, 0, 3 * button_height, button_height), CGPointMake(reVal.frame.size.width / 2 - 10 - 3 * button_height, reVal.frame.size.height / 2), adapter, @selector(didSelectTagForPhoto:), [UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"Location"] ofType:@"png"]])];
    [reVal addSubview:addTagBtn(@"时间", CGRectMake(0, 0, 3 * button_height, button_height), CGPointMake(reVal.frame.size.width / 2, reVal.frame.size.height / 2), adapter, @selector(didSelectTagForPhoto:), [UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"Time"] ofType:@"png"]])];
    [reVal addSubview:addTagBtn(@"标签", CGRectMake(0, 0, 3 * button_height, button_height), CGPointMake(reVal.frame.size.width / 2 + 10 + 3 * button_height, reVal.frame.size.height / 2), adapter, @selector(didSelectTagForPhoto:), [UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"Tag"] ofType:@"png"]])];
    
    return reVal;
}

UIView* pasteForPhoto(PostEffectAdapter* adapter, CGFloat height) {
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat button_height = height / 2;
    
    UIView* reVal = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    reVal.backgroundColor = [UIColor grayColor];
    
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
    return thisViewIsNotImplemented(height);
}

UIView* editForMovie(PostEffectAdapter* adapter, CGFloat height) {
    return thisViewIsNotImplemented(height);
}

UIView* asserateForMovie(PostEffectAdapter* adapter, CGFloat height) {
    return thisViewIsNotImplemented(height);
}

UIView* coverForMovie(PostEffectAdapter* adapter, CGFloat height) {
    return thisViewIsNotImplemented(height);
}

UIView* soundForMovie(PostEffectAdapter* adapter, CGFloat height) {
    return thisViewIsNotImplemented(height);
}

/*******************************************************************/

/*******************************************************************/
/**
 * photo effects
 */
UIImage* tilShiftEffect(UIImage* source, PostEffectAdapter* obj) {
    [obj.ip removeAllTargets];
    [obj.ip addTarget:obj.tiltShiftFilter];
    [obj.tiltShiftFilter useNextFrameForImageCapture];
    [obj.ip processImage];
    return [obj.tiltShiftFilter imageFromCurrentFramebuffer];
}

UIImage* sketchEffect(UIImage* source, PostEffectAdapter* obj) {
    [obj.ip removeAllTargets];
    [obj.ip addTarget:obj.sketchFilter];
    [obj.sketchFilter useNextFrameForImageCapture];
    [obj.ip processImage];
    return [obj.sketchFilter imageFromCurrentFramebuffer];
}

UIImage* colorInvertEffect(UIImage* source, PostEffectAdapter* obj) {
    [obj.ip removeAllTargets];
    [obj.ip addTarget:obj.colorInvertFilter];
    [obj.colorInvertFilter useNextFrameForImageCapture];
    [obj.ip processImage];
    return [obj.colorInvertFilter imageFromCurrentFramebuffer];
}

UIImage* smoothToonEffect(UIImage* source, PostEffectAdapter* obj) {
    [obj.ip removeAllTargets];
    [obj.ip addTarget:obj.smoothToonFilter];
    [obj.smoothToonFilter useNextFrameForImageCapture];
    [obj.ip processImage];
    return [obj.smoothToonFilter imageFromCurrentFramebuffer];
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

@synthesize delegate = _delegate;
@synthesize ip = _ip;
@synthesize tiltShiftFilter = _tiltShiftFilter;
@synthesize sketchFilter = _sketchFilter;
@synthesize colorInvertFilter = _colorInvertFilter;
@synthesize smoothToonFilter = _smoothToonFilter;

- (void)setUp {
    if ([_delegate currentType] == PostPreViewPhote) {
        if (_tiltShiftFilter == nil) {
            _tiltShiftFilter = [[GPUImageTiltShiftFilter alloc] init];
            [_tiltShiftFilter setTopFocusLevel:1.f];
            [_tiltShiftFilter setBottomFocusLevel:1.f];
            [_tiltShiftFilter setFocusFallOffRate:0.2];
        }
        
        if (_sketchFilter == nil) {
            _sketchFilter = [[GPUImageSketchFilter alloc] init];
        }
        
        if (_colorInvertFilter == nil) {
            _colorInvertFilter  = [[GPUImageColorInvertFilter alloc] init];
        }
        
        if (_smoothToonFilter == nil) {
            _smoothToonFilter = [[GPUImageSmoothToonFilter alloc] init];
        }
        
        if (_ip == nil) {
            _ip = [[GPUImagePicture alloc]initWithImage:[_delegate originImage]];
        }
    }
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

- (UIImage*)didSelectEffectFilterForPhoto:(UIButton*)sender {
    static const vector<effectNode> vec = {
        effectNode{"Tilt", &tilShiftEffect},
        effectNode{"Sketch", &sketchEffect},
        effectNode{"Color", &colorInvertEffect},
        effectNode{"Smooth", &smoothToonEffect},
    };
    
    UIImage* result = nil;
    for (int index = 0; index < vec.size(); ++index) {
        if (strcmp([sender.titleLabel.text UTF8String], vec[index].name) == 0) {
            result = vec[index].fp(nil, self);
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
        tagNode{"时间", TagTypeTime, &timeTagView},
        tagNode{"标签", TagTypeTags, &otherTagView},
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
@end