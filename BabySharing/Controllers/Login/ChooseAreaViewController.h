//
//  ChooseAreaViewController.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 30/12/2014.
//  Copyright (c) 2014 YY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AreaNode : NSObject
@property (nonatomic, strong) NSString* areaCode;
@property (nonatomic, strong) NSString* areaName;

- (id)initWithAreaName:(NSString*)name andAreaCode:(NSString*)code;
@end

@interface ChooseAreaViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *areaTableView;
@property (strong, nonatomic) AreaNode* selectNode;
@end
