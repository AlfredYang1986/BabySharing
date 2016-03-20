//
//  SearchAddDelegate.h
//  BabySharing
//
//  Created by Alfred Yang on 20/11/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "SearhViewControllerActionsDelegate.h"

@interface SearchAddRoleTagDelegate : NSObject <SearchDataCollectionProtocol>

@property (strong, nonatomic) id<SearchViewControllerProtocol> delegate;
@property (strong, nonatomic) id<SearchActionsProtocol> actions;
@end
