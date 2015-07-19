//
//  ChooseAreaViewController.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 30/12/2014.
//  Copyright (c) 2014 YY. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AreaViewControllerDelegate <NSObject>
- (void)didSelectArea:(NSString*)code;
@end

@interface ChooseAreaViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISearchBar *areaSearchBar;
@property (weak, nonatomic) IBOutlet UITableView *areaTableView;

@property (nonatomic, weak) id<AreaViewControllerDelegate> delegate;
@end
