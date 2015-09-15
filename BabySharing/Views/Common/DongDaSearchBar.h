//
//  DongDaSearchBar.h
//  BabySharing
//
//  Created by Alfred Yang on 15/09/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DongDaSearchBarDelegate <NSObject>

- (void)cancelBtnSelected;
- (void)searchTextChanged:(NSString*)searchText;
@end

@interface DongDaSearchBar : UIView

@property (nonatomic, setter=setSearchText:, getter=getSearchText) NSString* text;
@property (nonatomic, weak) id<DongDaSearchBarDelegate> delegate;

- (void)resignFirstResponder;
@end
