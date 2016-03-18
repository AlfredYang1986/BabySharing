//
//  SearchViewController.h
//  BabySharing
//
//  Created by Alfred Yang on 20/11/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearhViewControllerActionsDelegate.h"
#import "DongDaSearchBar2.h"

@interface SearchViewController : UIViewController <SearchViewControllerProtocol>

@property (strong, nonatomic, setter=setDataDelegate:) id<SearchDataCollectionProtocol> delegate;
@property (weak, nonatomic) IBOutlet DongDaSearchBar2 *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *queryView;
@property (nonatomic) BOOL isNeedAsyncData;
@property (nonatomic) BOOL isShowsSearchIcon;

@property (strong, nonatomic) NSString* pre_text;
@end
