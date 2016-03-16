//
//  ShareSideBaseController.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 24/04/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "ShareSideBaseController.h"
#import "ModelDefines.h"

@implementation ShareSideBaseController

- (void)viewDidLoad {
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Changing" style:UIBarButtonItemStyleDone target:self action:@selector(didSelectChangingBtn:)];
}

#pragma mark -- Changing Side
- (void)didSelectChangingBtn:(id)sender {
    NSDictionary* dic = [[NSDictionary alloc]initWithObjects:[[NSArray alloc]initWithObjects:self, nil] forKeys:[[NSArray alloc]initWithObjects:@"parent", nil]];
    [[NSNotificationCenter defaultCenter] postNotificationName:kDongDaNotificationkeySideChange object:self userInfo:dic];
}
@end
