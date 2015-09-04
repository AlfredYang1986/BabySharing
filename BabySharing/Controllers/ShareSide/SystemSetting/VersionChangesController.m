//
//  VersionChangesController.m
//  BabySharing
//
//  Created by Alfred Yang on 4/09/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "VersionChangesController.h"

@implementation VersionChangesController

- (void)viewDidLoad {
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}
@end
