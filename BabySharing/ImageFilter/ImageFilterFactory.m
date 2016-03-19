//
//  ImageFilterBase.m
//  BabySharing
//
//  Created by Alfred Yang on 3/9/16.
//  Copyright © 2016 BM. All rights reserved.
//

#import "ImageFilterFactory.h"
#import "GPUImage.h"

static GPUImagePicture* staticPicture;

@implementation ImageFilterFactory {

}

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
    

    
    [filter_saturation addTarget:filter_contrast];
    [filter_contrast addTarget:filter_brightness];
//    [filter_brightness addTarget:filter_curve];
    
    [filters setInitialFilters:[NSArray arrayWithObject:filter_saturation]];
    [filters setTerminalFilter:filter_brightness];
   
    return filters;
}

+ (GPUImageFilterGroup *)scene {
    GPUImageFilterGroup *filters = [[GPUImageFilterGroup alloc] init];
    
    
    GPUImageBrightnessFilter* filter_brightness = [[GPUImageBrightnessFilter alloc]init]; // 亮度
    filter_brightness.brightness = 0.2f;
    
    GPUImageContrastFilter *filter_contrast = [[GPUImageContrastFilter alloc] init]; // 对比度
    filter_contrast.contrast = 1.0f;

    GPUImageSaturationFilter *filter_saturation = [[GPUImageSaturationFilter alloc] init]; //饱和度
    filter_saturation.saturation = 0.72f;
  
    GPUImageRGBFilter *filter_RGB = [[GPUImageRGBFilter alloc]init];    // 色彩平衡
    filter_RGB.red = 1.04f;
    filter_RGB.green = 1.f;
    filter_RGB.blue = 1.03f;
    
    
    //    GPUImageHueFilter *filter_hue = [[GPUImageHueFilter alloc]init];
    //    filter_hue.hue = 10.f;
    
    //    GPUImageToneCurveFilter * filter_curve = [[GPUImageToneCurveFilter alloc] init]; // 曲线
    //    filter_curve.rgbCompositeControlPoints = [NSArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(0.f, 0.f)],
    //                                              [NSValue valueWithCGPoint:CGPointMake(0.4283, 0.5647)],
    //                                              [NSValue valueWithCGPoint:CGPointMake(1.f, 1.f)], nil];
    
    [filter_brightness addTarget:filter_contrast];
    [filter_contrast addTarget:filter_saturation];
    [filter_saturation addTarget:filter_RGB];
    
    [filters setInitialFilters:[NSArray arrayWithObject:filter_brightness]];
    [filters setTerminalFilter:filter_RGB];
    
    return filters;
}

+ (GPUImageFilterGroup *)avater {

    GPUImageFilterGroup *filters = [[GPUImageFilterGroup alloc] init];
   
//    GPUImageSaturationFilter *filter_saturation = [[GPUImageSaturationFilter alloc] init]; //饱和度
//    filter_saturation.saturation = 1.2f;
//    
//    GPUImageBrightnessFilter* filter_brightness = [[GPUImageBrightnessFilter alloc]init]; // 亮度
//    filter_brightness.brightness = 0.12f;
//    
//    GPUImageToneCurveFilter * filter_curve = [[GPUImageToneCurveFilter alloc] init]; // 曲线
//    filter_curve.rgbCompositeControlPoints = [NSArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(0.f, 0.f)],
//                                              [NSValue valueWithCGPoint:CGPointMake(0.2667, 0.2667)],
//                                              [NSValue valueWithCGPoint:CGPointMake(0.5490, 0.5490)],
//                                              [NSValue valueWithCGPoint:CGPointMake(1.f, 1.f)], nil];
//    
////    GPUImageContrastFilter *filter_contrast = [[GPUImageContrastFilter alloc] init]; // 对比度
////    filter_contrast.contrast = 1.0f;
//    
//    GPUImageRGBFilter *filter_RGB = [[GPUImageRGBFilter alloc]init];    // 色彩平衡
//    filter_RGB.red = 1.f;
//    filter_RGB.green = 0.98f;
//    filter_RGB.blue = 1.f;
//    
//    [filter_saturation addTarget:filter_brightness];
//    [filter_brightness addTarget:filter_curve];
//    [filter_curve addTarget:filter_RGB];
//    
////    GPUImageSolidColorGenerator* filter_solid_color = [[GPUImageSolidColorGenerator alloc]init];
////    [filter_solid_color setColorRed:0.9804 green:0.9176 blue:0.8824 alpha:1.f];
////    UIImage* img = [filter_solid_color imageFromCurrentFramebuffer];
//    
//    if (staticPicture == nil) {
//        NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
//        NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
//        
//        UIImage *inputImage = [UIImage imageNamed:[resourceBundle pathForResource:@"face" ofType:@"png"]];
//        staticPicture = [[GPUImagePicture alloc] initWithImage:inputImage smoothlyScaleOutput:YES];
//    }
//    
//    GPUImageSoftLightBlendFilter* filter_soft_light = [[GPUImageSoftLightBlendFilter alloc]init]; // 柔光
//    [filter_RGB addTarget:filter_soft_light];
//    
//    [staticPicture addTarget:filter_soft_light];
//    
//    [filters setInitialFilters:[NSArray arrayWithObject:filter_saturation]];
//    [filters setTerminalFilter:filter_soft_light];
    
    return filters;
}

+ (GPUImageFilterGroup *)food {
    GPUImageFilterGroup *filters = [[GPUImageFilterGroup alloc] init];
    
    GPUImageSaturationFilter *filter_saturation = [[GPUImageSaturationFilter alloc] init]; //饱和度
    filter_saturation.saturation = 1.2f;
    
    GPUImageBrightnessFilter* filter_brightness = [[GPUImageBrightnessFilter alloc]init]; // 亮度
    filter_brightness.brightness = 0.12f;
    
    GPUImageToneCurveFilter * filter_curve = [[GPUImageToneCurveFilter alloc] init]; // 曲线
    filter_curve.rgbCompositeControlPoints = [NSArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(0.f, 0.f)],
                                              [NSValue valueWithCGPoint:CGPointMake(0.2667, 0.2667)],
                                              [NSValue valueWithCGPoint:CGPointMake(0.5490, 0.5490)],
                                              [NSValue valueWithCGPoint:CGPointMake(1.f, 1.f)], nil];
    
    //    GPUImageContrastFilter *filter_contrast = [[GPUImageContrastFilter alloc] init]; // 对比度
    //    filter_contrast.contrast = 1.0f;
    
    GPUImageRGBFilter *filter_RGB = [[GPUImageRGBFilter alloc]init];    // 色彩平衡
    filter_RGB.red = 1.f;
    filter_RGB.green = 0.98f;
    filter_RGB.blue = 1.f;
    
    [filter_saturation addTarget:filter_brightness];
    [filter_brightness addTarget:filter_curve];
    [filter_curve addTarget:filter_RGB];
    
    [filters setInitialFilters:[NSArray arrayWithObject:filter_saturation]];
    [filters setTerminalFilter:filter_RGB];
    
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
