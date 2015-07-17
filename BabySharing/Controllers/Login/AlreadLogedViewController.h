//
//  AlreadLogedViewController.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 26/12/2014.
//  Copyright (c) 2014 YY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginModel.h"

@interface AlreadLogedViewController : UIViewController

@property (nonatomic, strong) NSDictionary* login_dic;

@property (weak, nonatomic) LoginModel* lm;
@property (strong, nonatomic) NSDictionary* login_attr;
@end
