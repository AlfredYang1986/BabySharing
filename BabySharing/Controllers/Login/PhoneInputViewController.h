//
//  PhoneInputViewController.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 26/12/2014.
//  Copyright (c) 2014 YY. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LoginModel.h"

@interface PhoneInputViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *phoneCodeFiled;
@property (nonatomic, weak) LoginModel* lm;

@property (nonatomic, weak) NSString* inputing_phone_number;
@end
