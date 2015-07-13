//
//  PostEffectAdapter.m
//  BabySharing
//
//  Created by Alfred Yang on 13/07/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "PostEffectAdapter.h"
#import "GPUImage.h"

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

/*******************************************************************/
/**
 * for photos
 */
UIButton* addPhotoEffectBtn(NSString* title, CGRect bounds, CGPoint center, NSObject* callBackObj, SEL callBack) {
    UIButton* btn = [[UIButton alloc]initWithFrame:bounds];
    btn.center = center;
    [btn addTarget:callBackObj action:callBack forControlEvents:UIControlEventTouchDown];
    [btn setTitle:title forState:UIControlStateNormal];
    
    btn.layer.borderWidth = 1.f;
    btn.layer.borderColor = [UIColor blueColor].CGColor;
    return btn;
}

UIView* effectFilterForPhoto(PostEffectAdapter* adapter, CGFloat height) {
    
    /**
     * 4 filter effect
     */
    CGFloat margin = height / 4;
    CGFloat button_height = height / 2;

    UIView* reVal = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 4 * (margin + button_height), height)];
  
    [reVal addSubview:addPhotoEffectBtn(@"Tilt", CGRectMake(0, 0, button_height, button_height), CGPointMake(margin + button_height / 2, height / 2), adapter, @selector(didSelectEffectFilterForPhoto:))];
    [reVal addSubview:addPhotoEffectBtn(@"Sketch", CGRectMake(0, 0, button_height, button_height), CGPointMake(2 * margin + button_height * 3/ 2, height / 2), adapter, @selector(didSelectEffectFilterForPhoto:))];
    [reVal addSubview:addPhotoEffectBtn(@"Color", CGRectMake(0, 0, button_height, button_height), CGPointMake(3 * margin + button_height * 5/ 2, height / 2), adapter, @selector(didSelectEffectFilterForPhoto:))];
    [reVal addSubview:addPhotoEffectBtn(@"Smooth", CGRectMake(0, 0, button_height, button_height), CGPointMake(4 * margin + button_height * 7/ 2, height / 2), adapter, @selector(didSelectEffectFilterForPhoto:))];

    return reVal;
}



UIView* tagForPhoto(CGFloat height) {
    return nil;
}

UIView* pasteForPhoto(CGFloat height) {
    return nil;
}

UIView* toolForPhoto(CGFloat height) {
    return nil;
}
/*******************************************************************/

/*******************************************************************/
/**
 * for movies
 */
UIView* effectFilterForMovie(CGFloat height) {
    return nil;
}

UIView* editForMovie(CGFloat height) {
    return nil;
}

UIView* asserateForMovie(CGFloat height) {
    return nil;
}

UIView* coverForMovie(CGFloat height) {
    return nil;
}

UIView* soundForMovie(CGFloat height) {
    return nil;
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
//        tableNode {"标签", 0, &tagForPhoto},
//        tableNode {"贴图", 0, &pasteForPhoto},
//        tableNode {"工具", 0, &toolForPhoto},
        
        /**
         * for movies
         */
//        tableNode {"滤镜", 1, &effectFilterForMovie},
//        tableNode {"标签", 1, &editForMovie},
//        tableNode {"贴图", 1, &asserateForMovie},
//        tableNode {"封面", 1, &coverForMovie},
//        tableNode {"声音", 1, &soundForMovie},
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

- (void)didSelectEffectFilterForPhoto:(UIButton*)sender {
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
    if (result) {
        [_delegate imageWithEffect:result];
    }
}
@end