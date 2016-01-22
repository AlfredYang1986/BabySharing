//
//  PhotoTagEditView.m
//  BabySharing
//
//  Created by Alfred Yang on 1/22/16.
//  Copyright © 2016 BM. All rights reserved.
//

#import "PhotoTagEditView.h"

@implementation PhotoTagEditView

#define EDIT_VIEW_WIDTH         94
#define EDIT_VIEW_HEIGHT        45

@synthesize delegate = _delegate;
@synthesize tag_type = _tag_type;

- (void)setUpView {
    
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    
    [self setBackgroundImage:[UIImage imageNamed:[resourceBundle pathForResource:@"post_edit_tag_bg" ofType:@"png"]] forState:UIControlStateNormal];
    self.bounds = CGRectMake(0, 0, EDIT_VIEW_WIDTH, EDIT_VIEW_HEIGHT);
    
    UIButton* editBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, EDIT_VIEW_WIDTH / 2 , EDIT_VIEW_HEIGHT)];
    editBtn.backgroundColor = [UIColor clearColor];
    [editBtn addTarget:self action:@selector(editBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:editBtn];
    
    UIButton* delBtn = [[UIButton alloc]initWithFrame:CGRectMake(EDIT_VIEW_WIDTH / 2, 0, EDIT_VIEW_WIDTH / 2, EDIT_VIEW_HEIGHT)];
    delBtn.backgroundColor = [UIColor clearColor];
    [delBtn addTarget:self action:@selector(delBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:delBtn];
}

- (void)editBtnClick {
    [_delegate didSelectedEditBtnWithType:_tag_type];
}

- (void)delBtnClick {
    [_delegate didSelectedDeleteBtnWithType:_tag_type];
}
@end
