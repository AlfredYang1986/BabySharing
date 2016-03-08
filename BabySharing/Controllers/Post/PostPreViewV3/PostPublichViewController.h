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
@property (nonatomic, strong) UIImage *share_img;
@property (nonatomic, weak) NSURL* movie_url;
// 封面--》服务器没有接口
@property (nonatomic, weak) UIImage *coverImage;
@property (nonatomic) PostPreViewType type;
@end
