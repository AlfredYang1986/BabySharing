//
//  CVMovieControllerViewController.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 26/05/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoviePlayTrait.h"
#import "CameraActionProtocol.h"

@protocol CaptureMovie <NSObject>
- (void)didCaptureMovieInPath:(NSString*)path;
@end

@interface CVMovieController : UIViewController <MovieActionProtocol>

@property (nonatomic, weak) id<CameraActionProtocol> delegate;
@end
