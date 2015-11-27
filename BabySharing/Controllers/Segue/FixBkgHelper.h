//
//  FixBkgHelper.h
//  BabySharing
//
//  Created by Alfred Yang on 27/11/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INTUAnimationEngine.h"

@interface FixBkgHelper : NSObject

- (CGPoint)moveLeftFromPoint:(CGPoint)start WithStep:(CGFloat)step InProgress:(CGFloat)progress;
@end
