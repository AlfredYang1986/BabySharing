//
//  CycleAddHometownController.h
//  BabySharing
//
//  Created by Alfred Yang on 28/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol addHometownProtocol <NSObject>
- (void)addHometown:(NSString*)hometown;
@end

@interface CycleAddHometownController : UIViewController

@property (nonatomic, weak) id<addHometownProtocol> delegate;
@property (nonatomic, weak) NSString* ori_hometown;
@end
