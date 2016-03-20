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
#import "Tools.h"

#define MARGIN  8
#define IMG_WIDTH       38
#define IMG_HEIGHT      IMG_WIDTH
#define CONTENT_WIDTH   50
#define CONTENT_HEIGHT  CONTENT_WIDTH
#define MARGIN_RIGHT    10.5

#define LINE_MARGIN     4

#define TIME_POSITION_MODIFY            3

@interface MessageNotificationDetailCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIView *connectContentView;

@end

@implementation MessageNotificationDetailCell

@synthesize imageView = _imageView;
@synthesize connectContentView = _connectContentView;
@synthesize notification = _notification;
@synthesize delegate = _delegate;

@synthesize postTimeLabel = _postTimeLabel;
@synthesize detailLabel = _detailLabel;

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
    
    _detailLabel = [[UILabel alloc]init];
    _detailLabel.font = [UIFont systemFontOfSize:13.f];
    _detailLabel.numberOfLines = 0;
    [self addSubview:_detailLabel];

    _postTimeLabel = [[UILabel alloc]init];
    _postTimeLabel.font = [UIFont systemFontOfSize:11.f];
    [self addSubview:_postTimeLabel];
    _postTimeLabel.textColor = [UIColor colorWithWhite:151.f / 255.f alpha:1.f];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize sz = [_detailLabel.text sizeWithFont:_detailLabel.font constrainedToSize:CGSizeMake(FLT_MAX, FLT_MAX)];
    CGFloat max_width = [UIScreen mainScreen].bounds.size.width - IMG_WIDTH - CONTENT_WIDTH - 3 * MARGIN;
    if (sz.width > max_width) {
        _detailLabel.frame = CGRectMake(0, 0, MIN(max_width, _detailLabel.frame.size.width), 2 * _detailLabel.frame.size.height);
        _detailLabel.center = CGPointMake(IMG_WIDTH + 2 * MARGIN + _detailLabel.frame.size.width / 2, [MessageNotificationDetailCell preferedHeight] / 2);
    } else {
        _detailLabel.frame = CGRectMake(0, 0, MIN(max_width, _detailLabel.frame.size.width), _detailLabel.frame.size.height);
        _detailLabel.center = CGPointMake(IMG_WIDTH + 2 * MARGIN + _detailLabel.frame.size.width / 2, [MessageNotificationDetailCell preferedHeight] / 2 - MARGIN);
    }
    
    if (_detailLabel.frame.origin.x + _detailLabel.frame.size.width + _postTimeLabel.frame.size.width + 3 * MARGIN > [UIScreen mainScreen].bounds.size.width - 50) {
        CGFloat offset = sz.width - _detailLabel.frame.size.width > 0 ? sz.width - _detailLabel.frame.size.width + MARGIN : 0;
        _postTimeLabel.frame = CGRectMake(_detailLabel.frame.origin.x + offset, _detailLabel.frame.origin.y + _detailLabel.frame.size.height + (offset == 0 ? 0 : -1) * (_postTimeLabel.frame.size.height) - TIME_POSITION_MODIFY, _postTimeLabel.frame.size.width, _postTimeLabel.frame.size.height);
        
    } else {
        _detailLabel.center = CGPointMake(IMG_WIDTH + 2 * MARGIN + _detailLabel.frame.size.width / 2, [MessageNotificationDetailCell preferedHeight] / 2);
        _postTimeLabel.center = CGPointMake(_detailLabel.center.x + _detailLabel.frame.size.width / 2 + _postTimeLabel.frame.size.width / 2 + MARGIN, _detailLabel.center.y);
    }
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
    if (screen_name == nil) {
        screen_name = self.notification.sender_screen_name;
    }
    switch (type) {
        case NotificationActionTypeFollow: {
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[screen_name stringByAppendingString:@" 关注了你"]];
//            [str addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(0,screen_name.length)];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:70.f / 255.f green:219.f / 255.f blue:202.f / 255.f alpha:1.f] range:NSMakeRange(0,screen_name.length)];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:151.f / 255.f alpha:1.f] range:NSMakeRange(screen_name.length + 1, 4)];
            
            NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineSpacing:LINE_MARGIN];
            [str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
            
            _detailLabel.attributedText = str;
           
            UIImageView* tmp = [_connectContentView viewWithTag:-1];
            if (tmp == nil) {
                tmp = [[UIImageView alloc] init];
                [_connectContentView addSubview:tmp];

                tmp.frame = CGRectMake(0, 0, 45, 20.5);
                tmp.center = CGPointMake(25 - 2, 25);
               
                tmp.userInteractionEnabled = YES;
                UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(relationBtnClicked:)];
                [tmp addGestureRecognizer:tap];
            }
            
            NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
            NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
            NSString* filepath = [resourceBundle pathForResource:@"command_following" ofType:@"png"];
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
            
            NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineSpacing:LINE_MARGIN];
            [str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
            
            _detailLabel.attributedText = str;
            
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
        case NotificationActionTypePush: {
            NSString* sender_name = _notification.sender_screen_name;
            NSString* receiver_id = _notification.receiver_screen_name;
            
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[[[sender_name stringByAppendingString:@" 推了 "] stringByAppendingString:receiver_id] stringByAppendingString:@" 的照片"]];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:70.f / 255.f green:219.f / 255.f blue:202.f / 255.f alpha:1.f] range:NSMakeRange(0,sender_name.length)];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:70.f / 255.f green:219.f / 255.f blue:202.f / 255.f alpha:1.f] range:NSMakeRange(sender_name.length + 4, receiver_id.length)];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:151.f / 255.f alpha:1.f] range:NSMakeRange(sender_name.length, 4)];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:151.f / 255.f alpha:1.f] range:NSMakeRange(sender_name.length + 4 + receiver_id.length, 4)];
            
            NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineSpacing:LINE_MARGIN];
            [str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
            
            _detailLabel.attributedText = str;
            
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
        case NotificationActionTypeUnlike: {
            NSString* sender_name = _notification.sender_screen_name;
            NSString* receiver_id = _notification.receiver_screen_name;
            
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[[[sender_name stringByAppendingString:@" 收回了赞 "] stringByAppendingString:receiver_id] stringByAppendingString:@" 的照片"]];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:70.f / 255.f green:219.f / 255.f blue:202.f / 255.f alpha:1.f] range:NSMakeRange(0,sender_name.length)];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:70.f / 255.f green:219.f / 255.f blue:202.f / 255.f alpha:1.f] range:NSMakeRange(sender_name.length + 6, receiver_id.length)];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:151.f / 255.f alpha:1.f] range:NSMakeRange(sender_name.length, 6)];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:151.f / 255.f alpha:1.f] range:NSMakeRange(sender_name.length + 6 + receiver_id.length, 4)];

            NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineSpacing:LINE_MARGIN];
            [str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
            
            _detailLabel.attributedText = str;
            
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
        case NotificationActionTypeUnpush:
            break;
            
        default:
            break;
    }
    [_detailLabel sizeToFit];
}

- (void)setTimeLabel:(NSDate*)time_label {
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.formatterBehavior = NSDateFormatterBehavior10_4;
//    formatter.dateStyle = NSDateFormatterShortStyle;
//    formatter.timeStyle = NSDateFormatterShortStyle;
//    
//    _postTimeLabel.text = [formatter stringForObjectValue:time_label];
//    [_postTimeLabel sizeToFit];
    
    _postTimeLabel.text = [Tools compareCurrentTime:time_label];
    [_postTimeLabel sizeToFit];
}

- (void)setRelationShip:(UserPostOwnerConnections)connetions {
    
}

- (void)relationBtnClicked:(UITapGestureRecognizer*)gesture {
//    [_delegate didselectedRelationsBtn:_notification];
    [_delegate didSelectedRelationBtn:self.notification.sender_id complete:^(BOOL success) {
        if (success) {
            NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
            NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
            NSString* filepath = [resourceBundle pathForResource:@"command_follow" ofType:@"png"];
            UIImageView *imgeView = (UIImageView *)gesture.view;
            imgeView.image = [UIImage imageNamed:filepath];
        };
    }];
}

- (void)senderImgSelected:(UITapGestureRecognizer*)geture {
    [_delegate didSelectedSender:_notification];
}

- (void)postContentClicked:(UITapGestureRecognizer*)geture {
    [_delegate didselectedPostContent:_notification];
}
@end
