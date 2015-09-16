//
//  DongDaFollowBtn.h
//  BabySharing
//
//  Created by Alfred Yang on 16/09/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelDefines.h"

@protocol DongDaFollowBtnDelegate <NSObject>
- (void)btnSelected;
@end

@interface DongDaFollowBtn : UIView

@property (nonatomic, setter=changeRelations:) UserPostOwnerConnections relations;
@property (nonatomic, weak) id<DongDaFollowBtnDelegate> delegate;

+ (CGSize)preferredSize;
+ (CGRect)preferredRect;
@end
