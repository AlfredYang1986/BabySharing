//
//  PostPublichViewController.h
//  BabySharing
//
//  Created by Alfred Yang on 12/17/15.
//  Copyright © 2015 BM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostDefine.h"

@interface PostPublichViewController : UIViewController
@property (nonatomic, strong) UIImage* preViewImg;
@property (nonatomic, strong) NSArray* already_taged;

@property (nonatomic, weak) NSURL* movie_url;
@property (nonatomic) PostPreViewType type;
@end
