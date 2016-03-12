//
//  LoginViewsDelegate.h
//  BabySharing
//
//  Created by Alfred Yang on 1/12/16.
//  Copyright © 2016 BM. All rights reserved.
//

#ifndef LoginViewsDelegate_h
#define LoginViewsDelegate_h

#import <UIKit/UIKit.h>

@protocol LoginInputViewDelegate <NSObject>
#pragma mark -- button actions
- (void)didSelectAreaCodeBtn;
- (void)didSelectConfirmBtn;
- (void)didSelectNextBtn;

#pragma mark -- text delegate
//- (void)didStartEditing;
//- (void)didEndEditing;

#pragma mark -- SNS actions
- (void)didSelectQQBtn;
- (void)didSelectWeiboBtn;
- (void)didSelectWechatBtn;

#pragma mark -- user privacy actions
- (void)didSelectUserPrivacyBtn;
@end

#endif /* LoginViewsDelegate_h */
