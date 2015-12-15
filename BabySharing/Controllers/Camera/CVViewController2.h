//
//  CVViewController2.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 26/05/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraActionProtocol.h"

//@protocol CapturePhotos <NSObject>
//
//- (void)didCapturePhotoInPath:(NSString*)path;
//- (void)didCapturePhoto:(UIImage*)img;
//
//@end

@interface CVViewController2 : UIViewController
@property (weak, nonatomic) id<CameraActionProtocol> delegate;
@end
