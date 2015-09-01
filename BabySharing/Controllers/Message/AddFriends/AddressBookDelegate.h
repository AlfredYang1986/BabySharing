//
//  AddressBookDelegate.h
//  BabySharing
//
//  Created by Alfred Yang on 7/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AddressBookDelegate : NSObject <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>

- (BOOL)isAddressDelegateReady;
@end
