//
//  ImageFilterBase.m
//  BabySharing
//
//  Created by Alfred Yang on 3/9/16.
//  Copyright © 2016 BM. All rights reserved.
//

#import "ImageFilterFactory.h"
#import "GPUImage.h"

@implementation ImageFilterFactory
+ (GPUImageFilterGroup *)normal {
    GPUImageFilter *filter = [[GPUImageFilter alloc] init]; //默认
    GPUImageFilterGroup *group = [[GPUImageFilterGroup alloc] init];
    [(GPUImageFilterGroup *) group setInitialFilters:[NSArray arrayWithObject: filter]];
    [(GPUImageFilterGroup *) group setTerminalFilter:filter];
    return group;
}

+ (GPUImageFilterGroup *)blackWhite {
    
    
    GPUImageFilterGroup *filters = [[GPUImageFilterGroup alloc] init];

    GPUImageSaturationFilter *filter_saturation = [[GPUImageSaturationFilter alloc] init]; //饱和度
    filter_saturation.saturation = 0.f;
    
    GPUImageBrightnessFilter* filter_brightness = [[GPUImageBrightnessFilter alloc]init]; // 亮度
    filter_brightness.brightness = 0.15f;

    GPUImageContrastFilter *filter_contrast = [[GPUImageContrastFilter alloc] init]; // 对比度
    filter_contrast.contrast = 1.5f;
    
//    GPUImageToneCurveFilter * filter_curve = [[GPUImageToneCurveFilter alloc] init]; // 曲线
//    filter_curve.rgbCompositeControlPoints = [NSArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(0.f, 0.f)],
//                                              [NSValue valueWithCGPoint:CGPointMake(0.4283, 0.5647)],
//                                              [NSValue valueWithCGPoint:CGPointMake(1.f, 1.f)], nil];
    
    [filter_saturation addTarget:filter_contrast];
    [filter_contrast addTarget:filter_brightness];
//    [filter_brightness addTarget:filter_curve];
    
    [filters setInitialFilters:[NSArray arrayWithObject:filter_saturation]];
    [filters setTerminalFilter:filter_brightness];
   
    return filters;
}

+ (GPUImageFilterGroup *)saturation {
    GPUImageSaturationFilter *filter = [[GPUImageSaturationFilter alloc] init]; //饱和度
    filter.saturation = 2.0f;
    GPUImageFilterGroup *group = [[GPUImageFilterGroup alloc] init];
    [(GPUImageFilterGroup *) group setInitialFilters:[NSArray arrayWithObject: filter]];
    [(GPUImageFilterGroup *) group setTerminalFilter:filter];
    return group;
}

+ (GPUImageFilterGroup *)exposure {
    GPUImageExposureFilter *filter = [[GPUImageExposureFilter alloc] init]; //曝光
    filter.exposure = 1.0f;
    GPUImageFilterGroup *group = [[GPUImageFilterGroup alloc] init];
    [(GPUImageFilterGroup *) group setInitialFilters:[NSArray arrayWithObject: filter]];
    [(GPUImageFilterGroup *) group setTerminalFilter:filter];
    return group;
}

+ (GPUImageFilterGroup *)contrast {
    GPUImageContrastFilter *filter = [[GPUImageContrastFilter alloc] init]; //对比度
    filter.contrast = 2.0f;
    GPUImageFilterGroup *group = [[GPUImageFilterGroup alloc] init];
    [(GPUImageFilterGroup *) group setInitialFilters:[NSArray arrayWithObject: filter]];
    [(GPUImageFilterGroup *) group setTerminalFilter:filter];
    return group;
}

+ (GPUImageFilterGroup *)testGroup1 {
    GPUImageFilterGroup *filters = [[GPUImageFilterGroup alloc] init];
    
    GPUImageExposureFilter *filter1 = [[GPUImageExposureFilter alloc] init]; //曝光
    filter1.exposure = 0.0f;
    GPUImageSaturationFilter *filter2 = [[GPUImageSaturationFilter alloc] init]; //饱和度
    filter2.saturation = 2.0f;
    GPUImageContrastFilter *filter3 = [[GPUImageContrastFilter alloc] init]; //对比度
    filter3.contrast = 2.0f;
    
    [filter1 addTarget:filter2];
    [filter2 addTarget:filter3];
    
    [(GPUImageFilterGroup *) filters setInitialFilters:[NSArray arrayWithObject: filter1]];
    [(GPUImageFilterGroup *) filters setTerminalFilter:filter3];
    return filters;
}
@end
