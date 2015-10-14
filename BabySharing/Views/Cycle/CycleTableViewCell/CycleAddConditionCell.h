//
//  CycleAddConditionCell.h
//  BabySharing
//
//  Created by Alfred Yang on 14/10/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CycleAddConditionCell : UITableViewCell

+ (CGFloat)prefferredHeight;

- (void)setTitle:(NSString*)title;
- (void)setContent:(NSString*)content;
@end
