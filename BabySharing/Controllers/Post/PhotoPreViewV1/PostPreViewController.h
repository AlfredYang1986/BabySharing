//
//  PostPreViewController.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 4/01/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostDefine.h"

@interface PostPreViewController : UIViewController {
    NSInteger curImage;
}

@property (nonatomic) PostPreViewType type;
@property (nonatomic, strong) NSArray* postArray;     // UIImage Array
@property (nonatomic, strong) NSURL* movieURL;

- (void)didSwipeImagePreview:(UISwipeGestureRecognizer*)sender;
@end
