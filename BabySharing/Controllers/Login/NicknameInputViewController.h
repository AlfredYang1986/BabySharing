//
//  NicknameInputViewController.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 26/12/2014.
//  Copyright (c) 2014 YY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginModel.h"

@interface NicknameInputViewController : UIViewController

@property (nonatomic, weak) LoginModel* lm;
@property (nonatomic, strong) NSDictionary* login_attr;
@property (nonatomic) BOOL isSNSLogIn;
@end
