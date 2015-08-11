//
//  TabBarController.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 20/12/2014.
//  Copyright (c) 2014 YY. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MessageModel.h"
#import "LoginModel.h"
#import "CameraActionProtocol.h"
#import "AlbumActionProtocol.h"

@interface TabBarController : UITabBarController <UITabBarDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITabBarControllerDelegate, AlbumActionDelegate, CameraActionProtocol>

@property (nonatomic, weak) LoginModel* lm;
@property (nonatomic, weak) MessageModel* mm;

- (void)showSecretSideOnController:(UIViewController*)parent;
- (void)unReadMessageCountChanged:(id)sender;
@end
