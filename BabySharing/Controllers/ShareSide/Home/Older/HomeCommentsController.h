//
//  HomeCommentsController.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 17/01/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QueryModel.h"

#import "ShareSideBaseController.h"

@class QueryContent;

@interface HomeCommentsController : ShareSideBaseController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) QueryModel* qm;
@property (weak, nonatomic) QueryContent* current_content;
@property (weak, nonatomic) NSString* current_user_id;
@property (weak, nonatomic) NSString* current_auth_token;
@end
