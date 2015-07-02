//
//  TabBarController.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 20/12/2014.
//  Copyright (c) 2014 YY. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LoginModel.h"
#import "CameraActionProtocol.h"
#import "AlbumActionProtocol.h"

@interface TabBarController : UITabBarController <UITabBarDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITabBarControllerDelegate, AlbumActionDelegate, CameraActionProtocol>

@property (nonatomic, weak) LoginModel* lm;

- (void)showSecretSideOnController:(UIViewController*)parent;
@end
