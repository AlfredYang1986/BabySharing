//
//  CycleOverCell.h
//  BabySharing
//
//  Created by Alfred Yang on 18/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CycleOverCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *themeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *themeImg;

+ (CGFloat)preferredHeight;
@end
