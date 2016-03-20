//
//  AlertView.h
//  BabySharing
//
//  Created by monkeyheng on 16/3/20.
//  Copyright © 2016年 BM. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^cancel)();
typedef void(^confirm)();

@interface AlertView : UIAlertView<UIAlertViewDelegate>

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelTitle otherButtonTitles:(NSString *)otherTitle;
- (void)show:(cancel)cancel confirm:(confirm)confirm;

@end;
