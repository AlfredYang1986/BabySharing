//
//  CycleOverCell.m
//  BabySharing
//
//  Created by Alfred Yang on 18/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "CycleOverCell.h"
#import "OBShapedButton.h"
#import "Targets.h"
#import "TmpFileStoragemodel.h"
#import "GotyeOCAPI.h"
#import "Tools.h"
#import "AppDelegate.h"
#import "RemoteInstance.h"

@implementation CycleOverCell {
    OBShapedButton* brage;
}

@synthesize themeLabel = _themeLabel;
@synthesize themeImg = _themeImg;
@synthesize chatLabel = _chatLabel;
@synthesize timeLabel = _timeLabel;

@synthesize current_session = _current_session;
@synthesize screen_name = _screen_name;

+ (CGFloat)preferredHeight {
    return 80;
}

- (void)setSession:(Targets *)current_session {
    _current_session = current_session;
   
    [self changeImage];
    [self changeThemeText];
    [self changeUnreadLabel];
    NSLog(@"MonkeyHengLog: %@ === %lld", @"_current_session.group_id.longLongValue", _current_session.group_id.longLongValue);

    GotyeOCGroup* group = [GotyeOCGroup groupWithId:_current_session.group_id.longLongValue];
    GotyeOCMessage* m = [GotyeOCAPI getLastMessage:group];
   
    [self changeMessageTextWithMessage:m];
    [self changeTimeTextWithMessage:m];
  
    // TODO : 我日 以后改
    if (_screen_name == nil) {
        
        dispatch_queue_t q = dispatch_queue_create("name qu", nil);
        dispatch_async(q, ^{
            NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
           
            AppDelegate* app = [UIApplication sharedApplication].delegate;
            
            [dic setObject:app.lm.current_user_id forKey:@"user_id"];
            [dic setObject:app.lm.current_auth_token forKey:@"auth_token"];
            [dic setObject:m.sender.name forKey:@"query_id"];
            
            NSError * error = nil;
            NSData* jsonData =[NSJSONSerialization dataWithJSONObject:[dic copy] options:NSJSONWritingPrettyPrinted error:&error];
            
            NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:USER_SCREEN_NAME_WITH_ID]];
            
            if ([[result objectForKey:@"status"] isEqualToString:@"ok"]) {
                
                _screen_name = [result objectForKey:@"result"];
                NSLog(@"user screen name is %@", _screen_name);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self changeMessageTextWithMessage:m];
                });
                
            } else {
                //        NSDictionary* reError = [result objectForKey:@"error"];
                //        NSString* msg = [reError objectForKey:@"message"];
                //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:msg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                //        [alert show];
                //        return nil;
            }
        });
    }
}

- (void)changeUnreadLabel {
    GotyeOCGroup* group = [GotyeOCGroup groupWithId:_current_session.group_id.longLongValue];
    int count = [GotyeOCAPI getUnreadMessageCount:group];
    if (count > 0) {
        brage.hidden = NO;
        NSString* str = [NSString stringWithFormat:@"%d", count];
        [brage setTitle:str forState:UIControlStateNormal];
    } else {
        brage.hidden = YES;
    }
}

- (void)changeThemeText {
    _themeLabel.text = _current_session.target_name;
}

- (void)changeMessageTextWithMessage:(GotyeOCMessage*)m {
//    GotyeOCGroup* group = [GotyeOCGroup groupWithId:_current_session.group_id.longLongValue];
//    GotyeOCMessage* m = [GotyeOCAPI getLastMessage:group];
    if (![m.text isEqualToString:@""]) {
        _chatLabel.text = [[_screen_name stringByAppendingString:@" : "] stringByAppendingString:m.text];
    }
}

- (void)changeTimeTextWithMessage:(GotyeOCMessage *)m {
//    GotyeOCGroup* group = [GotyeOCGroup groupWithId:_current_session.group_id.longLongValue];
//    GotyeOCMessage* m = [GotyeOCAPI getLastMessage:group];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    NSTimeInterval now_time = [NSDate date].timeIntervalSince1970;
    if (now_time - m.date > 24 * 60 * 60) {
        [formatter setDateFormat:@"MM-dd"];
    } else {
        [formatter setDateFormat:@"hh:mm"];
    }
    NSLog(@"MonkeyHengLog: %f === %u", now_time, m.date);
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:m.date];
    
//    _timeLabel.text = [formatter stringFromDate:date];
    _timeLabel.text = [Tools compareCurrentTime:date];
}

- (void)changeImage {
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    NSString * filePath = [resourceBundle pathForResource:[NSString stringWithFormat:@"default_user"] ofType:@"png"];
    
    UIImage* userImg = [TmpFileStorageModel enumImageWithName:_current_session.post_thumb withDownLoadFinishBolck:^(BOOL success, UIImage *user_img) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self) {
                    self.themeImg.image = user_img;
                    NSLog(@"owner img download success");
                }
            });
        } else {
            NSLog(@"down load owner image %@ failed", _current_session.post_thumb);
        }
    }];
    
    if (userImg == nil) {
        userImg = [UIImage imageNamed:filePath];
    }
    [self.themeImg setImage:userImg];
}

- (void)awakeFromNib {
    // Initialization code
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    
//    _themeImg.image = [UIImage imageNamed:[resourceBundle pathForResource:@"default_user" ofType:@"png"]];
    _themeImg.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    _themeImg.layer.borderWidth = 1.f;
    _themeImg.layer.cornerRadius = 8.f;
    _themeImg.clipsToBounds = YES;
    
    brage = [[OBShapedButton alloc] init];
    [brage setBackgroundImage:[UIImage imageNamed:[resourceBundle pathForResource:@"chat_round" ofType:@"png"]] forState:UIControlStateNormal];
#define BRAGE_WIDTH     25
#define BRAGE_HEIGHT    BRAGE_WIDTH
    brage.frame = CGRectMake(0, 0, BRAGE_WIDTH, BRAGE_HEIGHT);
    brage.center = CGPointMake(48 + BRAGE_WIDTH / 2, 5.5 + BRAGE_HEIGHT / 2);
    [brage setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [brage setTitle:@"10" forState:UIControlStateNormal];
    brage.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [self addSubview:brage];
    
    _themeLabel.textColor = [UIColor colorWithWhite:0.3059 alpha:1.f];
    _themeLabel.font = [UIFont boldSystemFontOfSize:14.f];
    _chatLabel.textColor = [UIColor colorWithWhite:0.6078 alpha:1.f];
    _timeLabel.textColor = [UIColor colorWithWhite:0.6078 alpha:1.f];
    
    CALayer* line = [CALayer layer];
    line.borderColor = [UIColor colorWithWhite:0.5922 alpha:0.25].CGColor;
    line.borderWidth = 1.f;
    line.frame = CGRectMake(10.5, 79, [UIScreen mainScreen].bounds.size.width - 10.5, 1);
    [self.layer addSublayer:line];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
