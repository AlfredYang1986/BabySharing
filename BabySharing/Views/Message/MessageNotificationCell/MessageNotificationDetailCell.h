//
//  MessageNotificationDetailCell.h
//  BabySharing
//
//  Created by Alfred Yang on 10/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EnumDefines.h"

@interface MessageNotificationDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *detailView;

+ (CGFloat)preferedHeight;

- (void)setUserImage:(NSString*)photo_name;
- (NSString*)getActtionTmplate:(NotificationActionType)type;
@end
