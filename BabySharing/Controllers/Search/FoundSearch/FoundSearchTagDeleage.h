//
//  FoundSearchTagDeleage.h
//  BabySharing
//
//  Created by Alfred Yang on 2/18/16.
//  Copyright © 2016 BM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FoundSearchProtocol.h"

@class FoundSearchModel;
@class FoundSearchController;

@interface FoundSearchTagDeleage : NSObject <UITableViewDelegate, UITableViewDataSource, FoundSearchProtocol>

@property (weak, nonatomic) FoundSearchModel* fm;
@property (weak, nonatomic) FoundSearchController* controller;

@end
