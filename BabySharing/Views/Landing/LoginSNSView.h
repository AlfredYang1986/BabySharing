//
//  LoginSNSView.h
//  BabySharing
//
//  Created by Alfred Yang on 1/12/16.
//  Copyright © 2016 BM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewsDelegate.h"

@interface LoginSNSView : UIView

@property (nonatomic, weak) id<LoginInputViewDelegate> delegate;

- (id)initWithFrame:(CGRect)rect;
@end
