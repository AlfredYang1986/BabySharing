//
//  ImageFilterBase.h
//  BabySharing
//
//  Created by Alfred Yang on 3/9/16.
//  Copyright © 2016 BM. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "GPUImage.h"

@class GPUImageFilter;

@interface ImageFilterFactory : NSObject
+ (GPUImageFilter*)normal;

+ (GPUImageFilter*)blackWhite;
+ (GPUImageFilter*)scene;
+ (GPUImageFilter*)avater;
+ (GPUImageFilter*)food;
@end
