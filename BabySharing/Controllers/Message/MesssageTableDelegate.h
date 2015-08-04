//
//  MesssageTableDelegate.h
//  BabySharing
//
//  Created by Alfred Yang on 4/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MesssageTableDelegate : NSObject <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) UITableView* queryView;
@end
