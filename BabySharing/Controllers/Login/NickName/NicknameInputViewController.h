//
//  NicknameInputViewController.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 26/12/2014.
//  Copyright (c) 2014 YY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginModel.h"
//#import "FixBackGroundSegueController.h"

typedef enum : NSUInteger {
    DongDaGenderMother,
    DongDaGenderFather,
} DongDaGender;

//@interface NicknameInputViewController : FixBackGroundSegueController
@interface NicknameInputViewController : UIViewController

@property (nonatomic, weak) LoginModel* lm;
@property (nonatomic, strong) NSMutableDictionary* login_attr;
@property (nonatomic) BOOL isSNSLogIn;

@property (nonatomic) DongDaGender gender;
@end
