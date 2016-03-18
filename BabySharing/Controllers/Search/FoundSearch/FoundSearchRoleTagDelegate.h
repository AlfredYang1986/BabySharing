//
//  FoundSearchRoleTagDelegate.h
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

@interface FoundSearchRoleTagDelegate : NSObject <UITableViewDataSource, UITableViewDelegate, FoundSearchProtocol>

@property (weak, nonatomic) FoundSearchModel* fm;
@property (weak, nonatomic) FoundSearchController* controller;
@property (strong, nonatomic) NSString* current_search;
@end
