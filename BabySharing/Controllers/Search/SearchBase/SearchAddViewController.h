//
//  SearchAddViewController.h
//  BabySharing
//
//  Created by Alfred Yang on 20/11/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearhViewControllerActionsDelegate.h"

@interface SearchAddViewController : UIViewController <SearchViewControllerProtocol>

@property (strong, nonatomic, setter=setAddingDelegate:) id<SearchDataCollectionProtocol> delegate;
@end
