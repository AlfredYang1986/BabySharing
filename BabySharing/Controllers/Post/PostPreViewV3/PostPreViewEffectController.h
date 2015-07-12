//
//  PostPreViewEffectController.h
//  BabySharing
//
//  Created by Alfred Yang on 12/07/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostDefine.h"

@interface PostPreViewEffectController : UIViewController

@property (nonatomic) PostPreViewType type;
@property (nonatomic, strong) UIImage* cutted_img;
@end
