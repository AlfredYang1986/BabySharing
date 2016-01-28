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
    _imgView.layer.borderColor = [UIColor colorWithWhite:0.5922 alpha:1.f].CGColor;
    _imgView.layer.cornerRadius = 25.f;
    _imgView.clipsToBounds = YES;
    _imgView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(senderImgSelected:)];
    [_imgView addGestureRecognizer:tap];
    
    CALayer* line = [CALayer layer];
    line.borderColor = [UIColor colorWithWhite:0.5922 alpha:0.30].CGColor;
    line.borderWidth = 1.f;
    line.frame = CGRectMake(10.5, 80 - 1, [UIScreen mainScreen].bounds.size.width - 10.5 * 2, 1);
    [self.layer addSublayer:line];
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
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    NSString * filePath = [resourceBundle pathForResource:[NSString stringWithFormat:@"User"] ofType:@"png"];
    
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

- (void)setDetailTarget:(NSString*)screen_name andActionType:(NotificationActionType)type andConnectContent:(NSString*)Post_id {
    switch (type) {
        case NotificationActionTypeFollow: {
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[screen_name stringByAppendingString:@" 关注了你"]];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(0,screen_name.length)];
            _nameLabel.attributedText = str;
           
            UIImageView* tmp = [_connectContentView viewWithTag:-1];
            if (tmp == nil) {
                tmp = [[UIImageView alloc]init];
                [_connectContentView addSubview:tmp];
            }
            
            NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
            NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
            NSString* filepath = [resourceBundle pathForResource:@"friend_relation_follow" ofType:@"png"];
            tmp.frame = CGRectMake(0, 0, 50, 22);
            tmp.center = CGPointMake(25, 25);
            tmp.image = [UIImage imageNamed:filepath];
           
            tmp.userInteractionEnabled = YES;
            UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(relationBtnClicked:)];
            [tmp addGestureRecognizer:tap];
            }
            break;
        case NotificationActionTypeUnFollow:
        case NotificationActionTypeLike:
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
@end
