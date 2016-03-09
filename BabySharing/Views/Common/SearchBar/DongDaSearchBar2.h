//
//  DongDaSearchBar2.h
//  BabySharing
//
//  Created by Alfred Yang on 1/21/16.
//  Copyright © 2016 BM. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^postLayoutBlock)(CGSize cancel_btn_sz);

@interface DongDaSearchBar2 : UISearchBar

@property (nonatomic, weak, getter=getTextFiled, readonly) UITextField* textField;
@property (nonatomic, weak, getter=getCancelBtn, readonly) UIButton* cancleBtn;
@property (nonatomic, weak, setter=setSearchBarBackgroundColor:) UIColor* sb_bg;
@property (nonatomic, setter=setShowsSearchIcon:) BOOL showsSearchIcon;

- (void)setPostLayoutSize:(CGSize)cancel_btn_sz;

@end
