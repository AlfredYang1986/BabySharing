//
//  CycleDetailController.m
//  BabySharing
//
//  Created by Alfred Yang on 12/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "CycleDetailController.h"

@interface CycleDetailController ()

@property (weak, nonatomic) IBOutlet UITextView *themeField;
@property (weak, nonatomic) IBOutlet UIView *userListView;

@end

@implementation CycleDetailController

@synthesize cycleDetails = _cycleDetails;
@synthesize themeField = _themeField;
@synthesize userListView = _userListView;

- (void)viewDidLoad {
    _themeField.text = @"";
   
    if (_cycleDetails) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"修改" style:UIBarButtonItemStylePlain target:self action:@selector(updateCycleDetailBtnSelected)];
    } else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(createCycleDetailBtnSelected)];
    }
}

- (void)updateCycleDetailBtnSelected {
    
}

- (void)createCycleDetailBtnSelected {
    
}

@end
