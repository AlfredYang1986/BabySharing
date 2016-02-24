//
//  RoleLable.h
//  BabySharing
//
//  Created by monkeyheng on 16/2/23.
//  Copyright © 2016年 BM. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RoleLableDelegate <NSObject>

- (void)deleteRolable;

@end

@interface RoleLable : UIView

@end
