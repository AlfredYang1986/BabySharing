//
//  PhotoTagEditView.h
//  BabySharing
//
//  Created by Alfred Yang on 1/22/16.
//  Copyright © 2016 BM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoTagEnumDefines.h"
#import "OBShapedButton.h"

@protocol PhotoTagEditViewDelegate <NSObject>
- (void)didSelectedEditBtnWithType:(TagType)tag_type;
- (void)didSelectedDeleteBtnWithType:(TagType)tag_type;
@end

@interface PhotoTagEditView : OBShapedButton

@property (nonatomic, weak) id<PhotoTagEditViewDelegate> delegate;
@property (nonatomic) TagType tag_type;

- (void)setUpView;
@end
