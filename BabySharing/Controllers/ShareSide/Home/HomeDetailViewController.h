//
//  HomeDetailViewController.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 12/01/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QueryModel.h"
#import "ConnectionModel.h"
#import "QueryDetailActionDelegate.h"

#import "ShareSideBaseController.h"

@class QueryContent;

@interface HomeDetailViewController : ShareSideBaseController <UITableViewDelegate, UITableViewDataSource, QueryDetailActionDelegate, UITextFieldDelegate>
@property (nonatomic, weak) QueryModel* qm;
@property (nonatomic, weak, readonly) ConnectionModel* cm;
@property (nonatomic, weak) QueryContent* current_content;
@property (weak, nonatomic) NSString* current_user_id;
@property (weak, nonatomic) NSString* current_auth_token;

@property (nonatomic, weak) id player;
@property (nonatomic, weak) id current_image;
@end
