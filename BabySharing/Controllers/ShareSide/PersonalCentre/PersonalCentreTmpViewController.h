//
//  PersonalCentreTmpViewController.h
//  BabySharing
//
//  Created by Alfred Yang on 3/1/16.
//  Copyright © 2016 BM. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PersonalCenterProtocol.h"

@interface PersonalCentreTmpViewController : UIViewController
@property (nonatomic, strong, setter=setProfileDelegate:) id<UITableViewDataSource, UITableViewDelegate, PersonalCenterCallBack> current_delegate;
@property (nonatomic, strong) NSString* owner_id;

@property (nonatomic) BOOL isPushed;
@end
