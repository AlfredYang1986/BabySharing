//
//  PhotoPreViewController.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 11/06/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoPreViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *preImgView;
@property (weak, nonatomic) IBOutlet UIView *floatingView;
@property (weak, nonatomic) IBOutlet UIButton *scaleBtn;

//@property (weak, nonatomic) UIImage* img;
@property (strong, nonatomic) NSArray* photoArray;
@end
