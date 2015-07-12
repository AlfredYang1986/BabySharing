//
//  PhotoPreViewEffectControllerViewController.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 11/06/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotopreViewEditView.h"

@interface PhotoPreViewEffectController : UIViewController <PhotoPreViewEditProtocol, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic, setter=setEditImage:) UIImage* edting_img;

- (void)setEditImage:(UIImage*)img;
@end
