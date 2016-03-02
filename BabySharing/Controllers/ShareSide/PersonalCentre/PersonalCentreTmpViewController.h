//
//  PersonalCentreTmpViewController.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 23/01/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonalCenterProtocol.h"

@interface PersonalCentreTmpViewController : UIViewController

@property (nonatomic, strong, setter=setProfileDelegate:) id<UITableViewDataSource, UITableViewDelegate, PersonalCenterCallBack> current_delegate;
@property (nonatomic, strong) NSString* owner_id;
@property (nonatomic) BOOL isPushed;

@end
