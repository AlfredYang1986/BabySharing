//
//  CycleAddDOBViewController.h
//  BabySharing
//
//  Created by Alfred Yang on 13/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "CycleDefines.h"

@protocol addDOBProtocol <NSObject>
- (void)didChangeDOB:(NSDate*)dob andAge:(NSInteger)age andHoroscrope:(Horoscrope)horoscrope;
@end

@interface CycleAddDOBViewController : UIViewController

@property (nonatomic, weak) id<addDOBProtocol> delegate;
//@property (nonatomic, weak) NSMutableDictionary* dic_description;

@property (nonatomic) NSInteger age;
@property (nonatomic) Horoscrope horoscrope;
@property (nonatomic, strong) NSDate* dob;
@end
