//
//  SearchAddBrandsDelegate.h
//  BabySharing
//
//  Created by Alfred Yang on 1/20/16.
//  Copyright © 2016 BM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "SearhViewControllerActionsDelegate.h"

@interface SearchAddBrandsDelegate : NSObject <SearchDataCollectionProtocol>

@property (weak, nonatomic) id<SearchViewControllerProtocol> delegate;
@property (weak, nonatomic) id<SearchActionsProtocol> actions;

- (void)pushExistingData:(NSArray *)data localTag:(NSArray *)localTag;
- (void)pushExistingData:(NSArray *)data;

@end
