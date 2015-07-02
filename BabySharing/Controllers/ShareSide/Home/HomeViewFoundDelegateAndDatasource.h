//
//  HomeViewFoundDelegateAndDatasource.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 6/06/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HomeViewFoundDelegateAndDatasource : NSObject <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, weak, readonly) UITableView* tableView;

- (id)initWithTableView:(UITableView*)tableView;
@end
