//
//  MessageNotificationDetailCell.m
//  BabySharing
//
//  Created by Alfred Yang on 10/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "MessageNotificationDetailCell.h"
#import "TmpFileStorageModel.h"
#import "Notifications.h"

@interface MessageNotificationDetailCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIView *connectContentView;

@end

@implementation MessageNotificationDetailCell

@synthesize imageView = _imageView;
@synthesize connectContentView = _connectContentView;
@synthesize notification = _notification;
@synthesize delegate = _delegate;

+ (CGFloat)preferedHeight {
//    return 66;
    return 80;
}

- (void)awakeFromNib {
    // Initialization code
    _imgView.layer.borderWidth = 1.5f;
    _imgView.layer.borderColor = [UIColor colorWithWhite:0.5922 alpha:0.25f].CGColor;
    _imgView.layer.cornerRadius = 19.f;
    _imgView.clipsToBounds = YES;
    _imgView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(senderImgSelected:)];
    [_imgView addGestureRecognizer:tap];
    
    CALayer* line = [CALayer layer];
    line.borderColor = [UIColor colorWithWhite:0.5922 alpha:0.30].CGColor;
    line.borderWidth = 1.f;
    line.frame = CGRectMake(10.5, 80 - 1, [UIScreen mainScreen].bounds.size.width - 10.5 * 2, 1);
    [self.layer addSublayer:line];

    _detailView.textColor = [UIColor colorWithWhite:151.f / 255.f alpha:1.f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSString*)getActtionTmplate:(NotificationActionType)type {
    
    NSString* reVal = @"not implemented";
    switch (type) {
        case NotificationActionTypeFollow:
//            reVal = @"%@ is now following you";
            reVal = @"is now following you";
            break;
        case NotificationActionTypeUnFollow:
        case NotificationActionTypeLike:
        case NotificationActionTypePush:
        case NotificationActionTypeMessage:
            break;
            
        default:
            break;
    }
    return reVal;
}

- (void)setUserImage:(NSString*)photo_name {
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    NSString * filePath = [resourceBundle pathForResource:[NSString stringWithFormat:@"default_user"] ofType:@"png"];
    
    UIImage* userImg = [TmpFileStorageModel enumImageWithName:photo_name withDownLoadFinishBolck:^(BOOL success, UIImage *user_img) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self) {
                    self.imgView.image = user_img;
                    NSLog(@"owner img download success");
                }
            });
        } else {
            NSLog(@"down load owner image %@ failed", photo_name);
        }
    }];
    
    if (userImg == nil) {
        userImg = [UIImage imageNamed:filePath];
    }
    [self.imgView setImage:userImg];
}

- (void)UIImageView:(UIImageView*)imgView setPostImage:(NSString*)photo_name {
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    NSString * filePath = [resourceBundle pathForResource:[NSString stringWithFormat:@"default_user"] ofType:@"png"];
    
    UIImage* userImg = [TmpFileStorageModel enumImageWithName:photo_name withDownLoadFinishBolck:^(BOOL success, UIImage *user_img) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self) {
                    imgView.image = user_img;
                    NSLog(@"owner img download success");
                }
            });
        } else {
            NSLog(@"down load owner image %@ failed", photo_name);
        }
    }];
    
    if (userImg == nil) {
        userImg = [UIImage imageNamed:filePath];
    }
    [imgView setImage:userImg];
}

- (void)setDetailTarget:(NSString*)screen_name andActionType:(NotificationActionType)type andConnectContent:(NSString*)Post_id {
    switch (type) {
        case NotificationActionTypeFollow: {
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[screen_name stringByAppendingString:@" 关注了你"]];
//            [str addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(0,screen_name.length)];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:70.f / 255.f green:219.f / 255.f blue:202.f / 255.f alpha:1.f] range:NSMakeRange(0,screen_name.length)];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:151.f / 255.f alpha:1.f] range:NSMakeRange(screen_name.length + 1, 4)];
            _nameLabel.attributedText = str;
           
            UIImageView* tmp = [_connectContentView viewWithTag:-1];
            if (tmp == nil) {
                tmp = [[UIImageView alloc]init];
                [_connectContentView addSubview:tmp];

                tmp.frame = CGRectMake(0, 0, 45, 20.5);
                tmp.center = CGPointMake(25 - 2, 25);
               
                tmp.userInteractionEnabled = YES;
                UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(relationBtnClicked:)];
                [tmp addGestureRecognizer:tap];
            }
            
            NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
            NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
            NSString* filepath = [resourceBundle pathForResource:@"command_follow" ofType:@"png"];
            tmp.image = [UIImage imageNamed:filepath];

            }
            break;
        case NotificationActionTypeUnFollow:
        case NotificationActionTypeLike: {
            
            NSString* sender_name = _notification.sender_screen_name;
            NSString* receiver_id = _notification.receiver_screen_name;
            
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[[[sender_name stringByAppendingString:@" 赞了 "] stringByAppendingString:receiver_id] stringByAppendingString:@" 的照片"]];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:70.f / 255.f green:219.f / 255.f blue:202.f / 255.f alpha:1.f] range:NSMakeRange(0,sender_name.length)];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:70.f / 255.f green:219.f / 255.f blue:202.f / 255.f alpha:1.f] range:NSMakeRange(sender_name.length + 4, receiver_id.length)];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:151.f / 255.f alpha:1.f] range:NSMakeRange(sender_name.length, 4)];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:151.f / 255.f alpha:1.f] range:NSMakeRange(sender_name.length + 4 + receiver_id.length, 4)];
            _nameLabel.attributedText = str;
            
            UIImageView* tmp = [_connectContentView viewWithTag:-1];
            if (tmp == nil) {
                tmp = [[UIImageView alloc]init];
                [_connectContentView addSubview:tmp];

                tmp.frame = CGRectMake(0, 0, 45, 45);
                tmp.center = CGPointMake(25, 25);
                tmp.layer.borderColor = [UIColor colorWithWhite:0.5922 alpha:0.3].CGColor;
                tmp.layer.borderWidth = 1.f;
                tmp.layer.cornerRadius = 5.f;
                tmp.clipsToBounds = YES;
                
                tmp.userInteractionEnabled = YES;
                UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(postContentClicked:)];
                [tmp addGestureRecognizer:tap];
            }
            
            [self UIImageView:tmp setPostImage:_notification.action_post_item];
            

            }
            break;
        case NotificationActionTypePush:
        case NotificationActionTypeMessage:
            break;
            
        default:
            break;
    }
}

- (void)setTimeLabel:(NSDate*)time_label {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.formatterBehavior = NSDateFormatterBehavior10_4;
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    
    _detailView.text = [formatter stringForObjectValue:time_label];
}

- (void)relationBtnClicked:(UITapGestureRecognizer*)gesture {
    [_delegate didselectedRelationsBtn:_notification];
}

- (void)senderImgSelected:(UITapGestureRecognizer*)geture {
    [_delegate didSelectedSender:_notification];
}

- (void)postContentClicked:(UITapGestureRecognizer*)geture {
    [_delegate didselectedPostContent:_notification];
}
@end
