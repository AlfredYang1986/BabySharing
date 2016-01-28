//
//  MessageNotificationDetailCell.h
//  BabySharing
//
//  Created by Alfred Yang on 10/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EnumDefines.h"

@class Notifications;

@protocol MessageNotificationCellDelegate <NSObject>

- (void)didSelectedSender:(Notifications*)notify;
- (void)didSelectedReceiver:(Notifications*)notify;
- (void)didselectedPostContent:(Notifications*)notify;
- (void)didselectedRelationsBtn:(Notifications*)notify;
@end

@interface MessageNotificationDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *detailView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) Notifications* notification;
@property (weak, nonatomic) id<MessageNotificationCellDelegate> delegate;

+ (CGFloat)preferedHeight;

- (void)setUserImage:(NSString*)photo_name;
- (NSString*)getActtionTmplate:(NotificationActionType)type;

- (void)setDetailTarget:(NSString*)screen_name andActionType:(NotificationActionType)type andConnectContent:(NSString*)Post_id;
- (void)setTimeLabel:(NSDate*)time_label;
@end
