//
//  CycleDetailController.h
//  BabySharing
//
//  Created by Alfred Yang on 12/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol createUpdateDetailProtocol <NSObject>

- (void)createUpdateChatGroup:(BOOL)success;
@end

@interface CycleDetailController : UIViewController

@property (nonatomic, weak) id<createUpdateDetailProtocol> delegate;
@property (nonatomic, strong) NSDictionary* cycleDetails;
@end
