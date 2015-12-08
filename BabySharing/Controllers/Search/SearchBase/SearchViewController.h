//
//  SearchViewController.h
//  BabySharing
//
//  Created by Alfred Yang on 20/11/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearhViewControllerActionsDelegate.h"

@interface SearchViewController : UIViewController <SearchViewControllerProtocol>

@property (strong, nonatomic, setter=setDataDelegate:) id<SearchDataCollectionProtocol> delegate;
@end
