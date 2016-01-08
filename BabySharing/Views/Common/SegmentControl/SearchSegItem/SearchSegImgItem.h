//
//  SearchSegImgItem.h
//  BabySharing
//
//  Created by Alfred Yang on 11/12/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchSegImgItem : UIView

@property (nonatomic, strong) UIImage* normal_img;
@property (nonatomic, strong) UIImage* selected_img;
@property (nonatomic, setter=changeStatus:) NSInteger status;

+ (CGSize)preferredSize;
@end
