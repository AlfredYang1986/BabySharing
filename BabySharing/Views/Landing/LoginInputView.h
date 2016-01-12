//
//  loginInputView.h
//  BabySharing
//
//  Created by Alfred Yang on 9/07/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewsDelegate.h"

@interface LoginInputView : UIView <UITextFieldDelegate>

@property (nonatomic, weak) id<LoginInputViewDelegate> delegate;

- (id)initWithFrame:(CGRect)rect;

- (NSString*)getInputPhoneNumber;
- (NSString*)getInputConfirmCode;

- (void)sendConfirmCodeRequestSuccess;
- (void)endEditing;

- (BOOL)isEditing;

- (void)setAreaCode:(NSString*)code;
@end
