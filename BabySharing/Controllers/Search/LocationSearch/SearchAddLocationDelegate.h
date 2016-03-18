//
//  SearchAddLocationDelegate.h
//  BabySharing
//
//  Created by Alfred Yang on 1/20/16.
//  Copyright © 2016 BM. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SearhViewControllerActionsDelegate.h"

@interface SearchAddLocationDelegate : NSObject <SearchDataCollectionProtocol>

@property (strong, nonatomic) id<SearchViewControllerProtocol> delegate;
@property (strong, nonatomic) id<SearchActionsProtocol> actions;
@end
