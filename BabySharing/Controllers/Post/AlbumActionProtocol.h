//
//  AlbumActionProtocol.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 10/06/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#ifndef YYBabyAndMother_AlbumActionProtocol_h
#define YYBabyAndMother_AlbumActionProtocol_h

typedef NS_ENUM(NSInteger, AlbumControllerType) {
    AlbumControllerTypePhoto,
    AlbumControllerTypeMovie,
    AlbumControllerTypeCompire,
};


@protocol AlbumActionDelegate <NSObject>
- (void)didCameraBtn: (UIViewController*)pv;
- (void)didMovieBtn: (UIViewController*)pv;
- (void)didCompareBtn: (UIViewController*)pv;
- (void)postViewController:(UIViewController*)pv didPostSueecss:(BOOL)success;
@end

#endif
