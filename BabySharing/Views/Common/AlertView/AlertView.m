//
//  AlertView.m
//  BabySharing
//
//  Created by monkeyheng on 16/3/20.
//  Copyright © 2016年 BM. All rights reserved.
//

#import "AlertView.h"

@implementation AlertView {
    cancel cancelBlock;
    confirm confirmBlock;
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelTitle otherButtonTitles:(NSString *)otherTitle {
    self = [super initWithTitle:title message:message delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:otherTitle, nil];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... {
    self = [super initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
    if (self) {
        self.delegate = self;
    }
    return self;
}

- (void)show:(cancel)cancel confirm:(confirm)confirm {
    [super show];
    confirmBlock = confirm;
    cancelBlock = cancel;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        cancelBlock();
    } else {
        confirmBlock();
    }
}

@end
