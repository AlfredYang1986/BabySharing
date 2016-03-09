//
//  ImageFilterBase.h
//  BabySharing
//
//  Created by Alfred Yang on 3/9/16.
//  Copyright © 2016 BM. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "GPUImage.h"

@class GPUImageFilterGroup;

@interface ImageFilterFactory : NSObject
+ (GPUImageFilterGroup *)normal;
+ (GPUImageFilterGroup *)saturation;
+ (GPUImageFilterGroup *)exposure;
+ (GPUImageFilterGroup *)contrast;
+ (GPUImageFilterGroup *)testGroup1;
@end
