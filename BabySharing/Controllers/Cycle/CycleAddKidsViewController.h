//
//  CycleAddKidsViewController.h
//  BabySharing
//
//  Created by Alfred Yang on 13/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "CycleDefines.h"

@protocol addKidsProtocol <NSObject>
- (void)changeKidsInfo:(NSArray*)kids;
@end

@interface CycleAddKidsViewController : UIViewController

@property (weak, nonatomic) id<addKidsProtocol> delegate;
@property (strong, nonatomic) NSMutableArray* kids;
@end
