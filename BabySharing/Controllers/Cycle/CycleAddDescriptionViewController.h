//
//  CycleAddDescriptionViewController.h
//  BabySharing
//
//  Created by Alfred Yang on 13/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CycleSyncDataProtocol.h"

@class LoginModel;

@interface CycleAddDescriptionViewController : UIViewController <CycleSyncDataProtocol>

@property (weak, nonatomic) LoginModel* lm;

@property (nonatomic) BOOL isEditable;
@property (weak, nonatomic) NSMutableDictionary* dic_description;
@end
