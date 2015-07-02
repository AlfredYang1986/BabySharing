//
//  HomeTagsController.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 19/06/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTagsController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) NSString* tag_name;
@property (nonatomic) NSInteger tag_type;
@end
