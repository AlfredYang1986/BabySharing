//
//  CameraActionProtocol.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 10/06/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#ifndef YYBabyAndMother_CameraActionProtocol_h
#define YYBabyAndMother_CameraActionProtocol_h

#import "AlbumActionProtocol.h"

@protocol CameraActionProtocol <NSObject>
- (void)didSelectAlbumBtn:(UIViewController*)cur andCurrentType:(AlbumControllerType)type;
- (void)didSelectMovieBtn2:(UIViewController*)cur;
- (void)didSelectCameraBtn2:(UIViewController*)cur;
- (void)didSelectAlbumBtn2:(UIViewController*)cur;
@end


#endif
