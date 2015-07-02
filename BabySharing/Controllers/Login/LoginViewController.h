//
//  LoginViewController.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 20/12/2014.
//  Copyright (c) 2014 YY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginModel.h"

@interface LoginViewController : UIViewController

@property (nonatomic, weak) LoginModel* lm;
@property (weak, nonatomic) IBOutlet UITextField *phoneNoFiled;
@property (weak, nonatomic) IBOutlet UITextField *areaFiled;

@property (nonatomic, strong) NSString* areaCodeSelected;

- (void)dismissLoginViewController: (id)sender;

@end
