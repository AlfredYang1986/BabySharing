//
//  PhotoTagsController.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 12/06/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoAddTagController.h"

@interface PhotoTagsController : UIViewController <addingTagsProtocol, UIAlertViewDelegate>
@property (strong, nonatomic) UIImage* taging_img;
@end
