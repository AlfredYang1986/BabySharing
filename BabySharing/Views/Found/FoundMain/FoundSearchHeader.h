//
//  FoundSearchHeader.h
//  BabySharing
//
//  Created by Alfred Yang on 8/12/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoundSearchHeader : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UILabel *headLabell;
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (strong, nonatomic) UIView *line1;
@property (strong, nonatomic) UIView *line;
+ (CGFloat)prefferredHeight;
@end
