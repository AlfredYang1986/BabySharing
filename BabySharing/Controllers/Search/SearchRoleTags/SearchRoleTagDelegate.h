//
//  SearchRoleTagDelegate.h
//  BabySharing
//
//  Created by Alfred Yang on 20/11/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "SearhViewControllerActionsDelegate.h"

@interface SearchRoleTagDelegate : NSObject <SearchDataCollectionProtocol, SearchActionsProtocol, SearchViewControllerProtocol>

@property (weak, nonatomic) id<SearchViewControllerProtocol> delegate;
@property (weak, nonatomic) id<SearchActionsProtocol> actions;
@end
