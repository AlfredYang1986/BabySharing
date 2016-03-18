//
//  SearchAddController2.h
//  BabySharing
//
//  Created by Alfred Yang on 1/21/16.
//  Copyright © 2016 BM. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SearhViewControllerActionsDelegate.h"
#import "DongDaSearchBar2.h"

@interface SearchAddController2 : UIViewController <SearchViewControllerProtocol>

@property (strong, nonatomic, setter=setAddingDelegate:) id<SearchDataCollectionProtocol> delegate;
@property (weak, nonatomic) IBOutlet DongDaSearchBar2 *searchBar;
@end