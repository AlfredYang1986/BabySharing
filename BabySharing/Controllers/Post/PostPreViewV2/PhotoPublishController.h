//
//  PhotoPublishController.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 13/06/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostDefine.h"

@interface PhotoPublishController : UIViewController

@property (nonatomic, strong) UIImage* preViewImg;
@property (nonatomic, strong) NSArray* already_taged;

@property (nonatomic, weak) NSURL* movie_url;
@property (nonatomic) PostPreViewType type;
@end
