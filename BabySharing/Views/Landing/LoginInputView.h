//
//  loginInputView.h
//  BabySharing
//
//  Created by Alfred Yang on 9/07/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginInputViewDelegate <NSObject>
#pragma mark -- button actions
- (void)didSelectAreaCodeBtn;
- (void)didSelectConfirmBtn;
- (void)didSelectNextBtn;

#pragma mark -- text delegate
- (void)didStartEditing;
- (void)didEndEditing;

#pragma mark -- SNS actions
- (void)didSelectQQBtn;
- (void)didSelectWeiboBtn;
- (void)didSelectWechatBtn;
@end

@interface LoginInputView : UIView <UITextFieldDelegate>

@property (nonatomic, weak) id<LoginInputViewDelegate> delegate;

- (id)initWithFrame:(CGRect)rect;

- (NSString*)getInputPhoneNumber;
- (NSString*)getInputConfirmCode;

- (void)sendConfirmCodeRequestSuccess;
- (void)endEditing;

- (BOOL)isEditing;
@end
