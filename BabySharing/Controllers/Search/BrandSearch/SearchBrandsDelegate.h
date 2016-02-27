//
//  SearchBrandsDelegate.h
//  BabySharing
//
//  Created by Alfred Yang on 1/20/16.
//  Copyright © 2016 BM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "SearhViewControllerActionsDelegate.h"

@interface SearchBrandsDelegate : NSObject <SearchDataCollectionProtocol, SearchActionsProtocol, SearchViewControllerProtocol>

@property (weak, nonatomic) id<SearchViewControllerProtocol> delegate;
@property (weak, nonatomic) id<SearchActionsProtocol> actions;

@end
