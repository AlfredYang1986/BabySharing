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

@property (weak, nonatomic) IBOutlet UIView *img;
@property (weak, nonatomic) IBOutlet UITextField *nicknameTextbox;

@property (nonatomic, weak) LoginModel* lm;

@property (nonatomic, weak) NSDictionary* login_attr;
@end
