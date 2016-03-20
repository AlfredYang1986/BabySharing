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

+ (GPUImageFilter*)normal {
    return [[GPUImageFilter alloc] init]; //默认
}

+ (GPUImageFilter*)blackWhite {
    GPUImageSaturationFilter *filter_saturation = [[GPUImageSaturationFilter alloc] init]; //饱和度
    filter_saturation.saturation = 0.f;
    
    GPUImageBrightnessFilter* filter_brightness = [[GPUImageBrightnessFilter alloc]init]; // 亮度
    filter_brightness.brightness = 0.15f;

    GPUImageContrastFilter *filter_contrast = [[GPUImageContrastFilter alloc] init]; // 对比度
    filter_contrast.contrast = 1.4f;
    
    GPUImageExposureFilter* filter_exposure = [[GPUImageExposureFilter alloc]init];
    filter_exposure.exposure = 0.12f;
    
    GPUImageToneCurveFilter * filter_curve = [[GPUImageToneCurveFilter alloc] init]; // 曲线
    filter_curve.rgbCompositeControlPoints = [NSArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(0.f, 0.f)],
                                              [NSValue valueWithCGPoint:CGPointMake(0.5098, 0.6627)],
                                              [NSValue valueWithCGPoint:CGPointMake(1.f, 1.f)], nil];

   
    [filter_saturation addTarget:filter_contrast];
    [filter_contrast addTarget:filter_brightness];
    [filter_brightness addTarget:filter_curve];
    [filter_curve addTarget:filter_exposure];

    return filter_saturation;
}

+ (GPUImageFilter*)scene {
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
    
    [filter_brightness addTarget:filter_contrast];
    [filter_contrast addTarget:filter_saturation];
    [filter_saturation addTarget:filter_RGB];
    
    return filter_brightness;
}

+ (GPUImageFilter*)avater {
    
    GPUImageBrightnessFilter* filter_brightness = [[GPUImageBrightnessFilter alloc]init]; // 亮度
    filter_brightness.brightness = 0.15f;
    
    GPUImageToneCurveFilter * filter_curve = [[GPUImageToneCurveFilter alloc] init]; // 曲线
    filter_curve.rgbCompositeControlPoints = [NSArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(0.f, 0.f)],
                                              [NSValue valueWithCGPoint:CGPointMake(0.5490, 0.7451)],
                                              [NSValue valueWithCGPoint:CGPointMake(1.f, 1.f)], nil];
    

    GPUImageHueFilter* filter_hue = [[GPUImageHueFilter alloc]init];
    filter_hue.hue = -6;
    
    GPUImageSaturationFilter *filter_saturation = [[GPUImageSaturationFilter alloc] init]; //饱和度
    filter_saturation.saturation = 1.1f;
    
    GPUImageExposureFilter* filter_exposure = [[GPUImageExposureFilter alloc]init];
    filter_exposure.exposure = 0.12f;
   
    GPUImageRGBFilter *filter_RGB = [[GPUImageRGBFilter alloc]init];    // 色彩平衡
    filter_RGB.red = 1.f;
    filter_RGB.green = 1.00f;
    filter_RGB.blue = 1.10f;

    GPUImageContrastFilter *filter_contrast = [[GPUImageContrastFilter alloc] init]; // 对比度
    filter_contrast.contrast = 1.0667f;
    
    [filter_exposure addTarget:filter_brightness];
    [filter_brightness addTarget:filter_saturation];
    [filter_saturation addTarget:filter_curve];
    [filter_curve addTarget:filter_RGB];
    [filter_RGB addTarget:filter_contrast];
    
    return filter_exposure;
}

//+ (GPUImageFilter*)avater {
//    GPUImageSaturationFilter *filter_saturation = [[GPUImageSaturationFilter alloc] init]; //饱和度
//    filter_saturation.saturation = 1.2f;
//    
//    GPUImageBrightnessFilter* filter_brightness = [[GPUImageBrightnessFilter alloc]init]; // 亮度
//    filter_brightness.brightness = 100.f;
//    
//    GPUImageToneCurveFilter * filter_curve = [[GPUImageToneCurveFilter alloc] init]; // 曲线
//    filter_curve.rgbCompositeControlPoints = [NSArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(0.f, 0.f)],
//                                              [NSValue valueWithCGPoint:CGPointMake(0.5, 0.5)],
////                                              [NSValue valueWithCGPoint:CGPointMake(0.5490, 0.5490)],
//                                              [NSValue valueWithCGPoint:CGPointMake(1.f, 1.f)], nil];
//    
//    //    GPUImageContrastFilter *filter_contrast = [[GPUImageContrastFilter alloc] init]; // 对比度
//    //    filter_contrast.contrast = 1.0f;
//    
//    GPUImageRGBFilter *filter_RGB = [[GPUImageRGBFilter alloc]init];    // 色彩平衡
//    filter_RGB.red = 1.f;
//    filter_RGB.green = 0.98f;
//    filter_RGB.blue = 1.f;
//   
////    GPUImageChromaKeyFilter* filter_chroma = [[GPUImageChromaKeyFilter alloc]init];
////    [filter_chroma setColorToReplaceRed:0.3 green:0.59 blue:0.11];
////    [filter_chroma addTarget:filter_saturation];
//    
//    [filter_saturation addTarget:filter_brightness];
//    [filter_brightness addTarget:filter_curve];
//    [filter_curve addTarget:filter_RGB];
//    
//    return filter_saturation;
//}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAlpha(context, 1.f);
    CGContextSetFillColorWithColor(context,color.CGColor);
    CGContextFillRect(context, rect);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

+ (GPUImageFilter*)food {
    GPUImageSaturationFilter *filter_saturation = [[GPUImageSaturationFilter alloc] init]; //饱和度
    filter_saturation.saturation = 1.2f;
    
    GPUImageBrightnessFilter* filter_brightness = [[GPUImageBrightnessFilter alloc]init]; // 亮度
    filter_brightness.brightness = 0.12f;
    
    GPUImageToneCurveFilter * filter_curve = [[GPUImageToneCurveFilter alloc] init]; // 曲线
    filter_curve.rgbCompositeControlPoints = [NSArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(0.f, 0.f)],
                                              [NSValue valueWithCGPoint:CGPointMake(0.2667, 0.2667)],
                                              [NSValue valueWithCGPoint:CGPointMake(0.5490, 0.5490)],
                                              [NSValue valueWithCGPoint:CGPointMake(1.f, 1.f)], nil];
    
    GPUImageRGBFilter *filter_RGB = [[GPUImageRGBFilter alloc]init];    // 色彩平衡
    filter_RGB.red = 1.f;
    filter_RGB.green = 0.98f;
    filter_RGB.blue = 1.f;
    
    [filter_saturation addTarget:filter_brightness];
    [filter_brightness addTarget:filter_curve];
    [filter_curve addTarget:filter_RGB];
    
    
    return filter_saturation;
}
@end
