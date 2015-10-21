//
//  PhotoTagTariangleLayer.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 13/06/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface PhotoTagTariangleLayer : CALayer

- (id)init;
- (CGRect)getPreferRect:(CGFloat)hit_height;
@end
