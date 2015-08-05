//
//  ConnectionModel.h
//  BabySharing
//
//  Created by Alfred Yang on 5/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class AppDelegate;

@interface ConnectionModel : NSObject

@property (strong, nonatomic) UIManagedDocument* doc;
@property (strong, nonatomic) NSArray* querydata;
@property (weak, nonatomic, readonly) AppDelegate* delegate;

#pragma mark -- constractor
- (id)initWithDelegate:(AppDelegate*)app;
@end
