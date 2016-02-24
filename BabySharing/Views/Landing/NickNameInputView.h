//
//  NickNameInputView.h
//  BabySharing
//
//  Created by Alfred Yang on 17/07/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NickNameInputViewDelegate <NSObject>

//- (void)didStartInputName;
//- (void)didEndInputName;
//- (void)didStartInputTags;

- (void)didStartEditingScreenName;
- (void)didEndEditingScreenName;
- (void)didEditRoleTag;
- (void)didClickNextBtn;

- (NSString*)getPreScreenName;
- (NSString*)getPreRoleTag;
@end

@interface NickNameInputView : UIView <UITextFieldDelegate, UITextFieldDelegate>

@property (nonatomic, weak) id<NickNameInputViewDelegate> delegate;

@property (nonatomic, weak, setter=setScreenName:, getter=getScreenName) NSString* screen_name;
@property (nonatomic, weak, setter=setRoleTag:, getter=getRoleTag) NSString* role_tag;

- (void)setUpWithFrame:(CGRect)rect;
- (void)endInputName;

@end
