//
//  SearchLocationDelegate.h
//  BabySharing
//
//  Created by Alfred Yang on 1/20/16.
//  Copyright © 2016 BM. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SearhViewControllerActionsDelegate.h"

@interface SearchLocationDelegate : NSObject <SearchDataCollectionProtocol, SearchActionsProtocol, SearchViewControllerProtocol>

@property (weak, nonatomic) id<SearchViewControllerProtocol> delegate;
@property (weak, nonatomic) id<SearchActionsProtocol> actions;

- (void)setInitialSearchBarText:(NSString*)text;
@end
