//
//  QueryDescriptionCellTableViewCell.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 5/06/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QueryDescriptionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *user_description;
@property (weak, nonatomic) IBOutlet UILabel *content_tags;

+ (CGFloat)preferHeight;
@end
