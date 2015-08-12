//
//  DropDownMnue.h
//  BabySharing
//
//  Created by Alfred Yang on 12/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WEPopoverController.h"

@class DropDownMenu;

@protocol DropDownMenuProcotol
- (void)dropDownMenu:(DropDownMenu*)menu didSelectMuneItemAtIndex:(NSInteger)index;
@end

@interface DropDownMenu : UITableViewController

@property (nonatomic, weak) id<DropDownMenuProcotol> dropdownDelegate;

- (void)setMenuText:(NSArray*)text_arr;
- (WEPopoverContainerViewProperties*)improvedContainerViewProperties;
@end
