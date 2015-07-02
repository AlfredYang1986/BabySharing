//
//  QueryOwnerCell.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 12/01/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QueryDetailActionDelegate.h"

@interface QueryOwnerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *owner_img;
@property (weak, nonatomic) IBOutlet UILabel *owner_name;
@property (weak, nonatomic) IBOutlet UILabel *owner_tags;
@property (weak, nonatomic) IBOutlet UILabel *content_share_number;

@property (weak, nonatomic) NSString* owner_id;
@property (weak, nonatomic) id<QueryDetailActionDelegate> delegate;

+ (CGFloat)preferHeight;
@end
