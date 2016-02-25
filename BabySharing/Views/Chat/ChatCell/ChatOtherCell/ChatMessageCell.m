//
//  ChatViewCell.m
//  BabySharing
//
//  Created by Alfred Yang on 12/10/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import "ChatMessageCell.h"
#import "GotyeOCMessage.h"
#import "LoginModel.h"
#import "AppDelegate.h"
#import "RemoteInstance.h"
#import "TmpFileStorageModel.h"
#import "OBShapedButton.h"

#define IMG_WIDTH               40
#define IMG_HEIGHT              IMG_WIDTH

#define MARGIN                  8
#define MARGIN_BIG              10.5

#define TIME_LABEL_MARGIN       10.5
#define TIME_LABEL_HEIGHT       26

#define TIME_FONT_SIZE          13.f
#define CONTENT_FONT_SIZE       14.f

@implementation ChatMessageCell {
    OBShapedButton* time_label;
    UITextView* content;
    UIImageView* imgView;
   
    CALayer* layer;
    
    BOOL isSenderByOwner;
}

@synthesize message = _message;
@synthesize lm = _lm;

- (id)init {
    self = [super init];
    if (self) {
        [self setupSubviews];
    }

    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupSubviews];
    }

    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubviews];
    }

    return self;
}

- (void)awakeFromNib {
    // Initialization code
    [self setupSubviews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupSubviews {
    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    _lm = app.lm;
    self.backgroundColor = [UIColor clearColor];
    
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];

    if (time_label == nil) {
        time_label = [[OBShapedButton alloc]init];
        [self addSubview:time_label];
        time_label.titleLabel.font = [UIFont systemFontOfSize:TIME_FONT_SIZE];
//        time_label.backgroundColor = [UIColor darkGrayColor];
//        time_label.layer.cornerRadius = TIME_LABEL_HEIGHT / 2;
//        time_label.textAlignment = NSTextAlignmentCenter;
//        time_label.clipsToBounds = YES;
        [time_label setBackgroundImage:[UIImage imageNamed:[resourceBundle pathForResource:@"chat_time_label" ofType:@"png"]] forState:UIControlStateNormal];
    }
    
    if (content == nil) {

        content = [[UITextView alloc]init];
        content.editable = NO;
        [self addSubview:content];
        content.layer.cornerRadius = 5.f;
        content.clipsToBounds = YES;
        content.layer.borderColor = [UIColor clearColor].CGColor;
        content.layer.borderWidth = 1.f;
        content.font = [UIFont systemFontOfSize:CONTENT_FONT_SIZE];
        content.scrollEnabled = NO;

        layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, 7, 14);
        [self.layer addSublayer:layer];
    }
    
    if (imgView == nil) {
        imgView = [[UIImageView alloc]init];
        imgView.bounds = CGRectMake(0, 0, IMG_WIDTH, IMG_HEIGHT);
        imgView.layer.borderColor = [UIColor colorWithWhite:0.5922 alpha:0.25].CGColor;
        imgView.layer.borderWidth = 1.5f;
        imgView.layer.cornerRadius = IMG_WIDTH / 2;
        imgView.clipsToBounds = YES;
        [self addSubview:imgView];
    }
}

- (void)layoutSubviews {
    if (isSenderByOwner) {
        
        CGFloat width = [UIScreen mainScreen].bounds.size.width * (1 - 0.18);
        CGFloat offset_x = 0.18 * width + width - MARGIN_BIG;
//        CGFloat offset_y = MARGIN;
        CGFloat offset_y = MARGIN_BIG + TIME_LABEL_MARGIN + TIME_LABEL_HEIGHT;
        imgView.frame = CGRectMake(offset_x - IMG_WIDTH, offset_y, IMG_WIDTH, IMG_HEIGHT);
        
        offset_x -= IMG_WIDTH + MARGIN_BIG;
        
        UIFont* font = [UIFont systemFontOfSize:TIME_FONT_SIZE];
        CGSize label_size = [@"88-88" sizeWithFont:font constrainedToSize:CGSizeMake(FLT_MAX, FLT_MAX)];
        
//        [time_label sizeToFit];
        time_label.bounds = CGRectMake(0, 0, label_size.width + 16, TIME_LABEL_HEIGHT);
        time_label.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, TIME_LABEL_MARGIN + TIME_LABEL_HEIGHT / 2);
        
        CGFloat content_width = width - 3 * MARGIN - 2 * IMG_WIDTH; // - label_size.width;
        UIFont* content_font = [UIFont systemFontOfSize:CONTENT_FONT_SIZE];
        CGSize content_size = [content.text sizeWithFont:content_font constrainedToSize:CGSizeMake(content_width, FLT_MAX)];
//        content.frame = CGRectMake(offset_x - content_size.width - 16, offset_y, content_size.width + 16, MAX(content_size.height + 2 * MARGIN, IMG_HEIGHT));
        content.frame = CGRectMake(offset_x - content_size.width - 16, offset_y, content_size.width + 16, content_size.height + 2 * MARGIN);
//        content.backgroundColor = [UIColor colorWithRed:0.3126 green:0.7529 blue:0.6941 alpha:1.f];
        content.backgroundColor = [UIColor colorWithWhite:1.f alpha:0.8];
//        content.backgroundColor = [UIColor clearColor];
        
        NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
        NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
        layer.contents = (id)[UIImage imageNamed:[resourceBundle pathForResource:@"chat_mine_tri" ofType:@"png"]].CGImage;
        layer.frame = CGRectMake(offset_x - content_size.width - 16 + content_size.width + 16 - 1, offset_y + 10.5, 7, 14);
        
        offset_x -= content_width + MARGIN;
        
    } else {

        CGFloat offset_x = MARGIN_BIG;
        CGFloat offset_y = MARGIN_BIG + TIME_LABEL_MARGIN + TIME_LABEL_HEIGHT;
//        CGFloat offset_y = MARGIN;
        imgView.frame = CGRectMake(offset_x, offset_y, IMG_WIDTH, IMG_HEIGHT);
        
        offset_x += IMG_WIDTH + MARGIN_BIG;
        
        UIFont* font = [UIFont systemFontOfSize:TIME_FONT_SIZE];
        CGSize label_size = [@"88-88" sizeWithFont:font constrainedToSize:CGSizeMake(FLT_MAX, FLT_MAX)];
      
//        [time_label sizeToFit];
        time_label.bounds = CGRectMake(0, 0, label_size.width + 16, TIME_LABEL_HEIGHT);
        time_label.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, TIME_LABEL_MARGIN + TIME_LABEL_HEIGHT / 2);
        
        CGFloat width = [UIScreen mainScreen].bounds.size.width * (1 - 0.18);
        CGFloat content_width = width - 3 * MARGIN - 2 * IMG_WIDTH; // - label_size.width;
        UIFont* content_font = [UIFont systemFontOfSize:CONTENT_FONT_SIZE];
        CGSize content_size = [content.text sizeWithFont:content_font constrainedToSize:CGSizeMake(content_width, FLT_MAX)];
//        content.frame = CGRectMake(offset_x, offset_y, content_size.width + 16, MAX(content_size.height + 2 * MARGIN, IMG_HEIGHT));
        content.frame = CGRectMake(offset_x - content_size.width - 16, offset_y, content_size.width + 16, content_size.height + 2 * MARGIN);
        content.backgroundColor = [UIColor colorWithRed:0.2745 green:0.8588 blue:0.7922 alpha:0.6];

        NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
        NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
        layer.contents = (id)[UIImage imageNamed:[resourceBundle pathForResource:@"chat_other_tri" ofType:@"png"]].CGImage;
        layer.frame = CGRectMake(offset_x, offset_y + 10.5, 7, 14);
        
        offset_x += content_width + MARGIN;
    }
}

- (void)setGotyeOCMessage:(GotyeOCMessage*)msg {
    _message = msg;
    
    isSenderByOwner = [_lm.current_user_id isEqualToString:_message.sender.name];
    [self setSenderImage:@""];
    [self setContent:msg.text];
    [self setContentDate:nil];
}

- (void)setSenderImage:(NSString*)img_name {
    dispatch_queue_t up = dispatch_queue_create("Get Profile Details", nil);
    dispatch_async(up, ^{
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        [dic setValue:_lm.current_auth_token forKey:@"query_auth_token"];
        [dic setValue:_lm.current_user_id forKey:@"query_user_id"];
        [dic setValue:_message.sender.name forKey:@"owner_user_id"];
        
        NSError * error = nil;
        NSData* jsonData =[NSJSONSerialization dataWithJSONObject:[dic copy] options:NSJSONWritingPrettyPrinted error:&error];
        
        NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:[PROFILE_HOST_DOMAIN stringByAppendingString:PROFILE_QUERY_DETAILS]]];
        
        if ([[result objectForKey:@"status"] isEqualToString:@"ok"]) {
            NSDictionary* reVal = [result objectForKey:@"result"];
           
            NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
            NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
            NSString * filePath = [resourceBundle pathForResource:[NSString stringWithFormat:@"default_user"] ofType:@"png"];
            
            NSString* photo_name = [reVal objectForKey:@"screen_photo"];
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
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [imgView setImage:userImg];
            });
        }
    });
}

- (void)setContent:(NSString*)content_text {
    content.text = content_text;
}

- (void)setContentDate:(NSDate*)date2 {
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    NSTimeInterval now_time = [NSDate date].timeIntervalSince1970;
    if (now_time - _message.date > 24 * 60 * 60) {
        [formatter setDateFormat:@"MM-dd"];
    } else {
        [formatter setDateFormat:@"hh:mm"];
    }
    
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:_message.date];
//    time_label.text = [formatter stringFromDate:date];
    [time_label setTitle:[formatter stringFromDate:date] forState:UIControlStateNormal];
}

+ (CGFloat)preferredHeightWithInputText:(NSString*)content {
    /**
     * 1. get screen width
     */
//    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat width = [UIScreen mainScreen].bounds.size.width * (1 - 0.18);
    
    /**
     * 2. get image width and height
     */
//    CGFloat img_width = IMG_WIDTH;
//    CGFloat img_height = IMG_HEIGHT;
    
    /**
     * 3. time label width and height
     */
    UIFont* font = [UIFont systemFontOfSize:TIME_FONT_SIZE];
    CGSize label_size = [@"88-88" sizeWithFont:font constrainedToSize:CGSizeMake(FLT_MAX, FLT_MAX)];
//    CGFloat time_label_width = label_size.width;
//    CGFloat time_lable_height = label_size.height;
   
    /**
     * 4. width left for content
     */
    CGFloat content_width = width - 3 * MARGIN - IMG_WIDTH; // - label_size.width;
    UIFont* content_font = [UIFont systemFontOfSize:CONTENT_FONT_SIZE];
    CGSize content_size = [content sizeWithFont:content_font constrainedToSize:CGSizeMake(content_width, FLT_MAX)];
    
    return MAX(IMG_HEIGHT + 2 * MARGIN, content_size.height + 6 * MARGIN) + TIME_LABEL_HEIGHT + TIME_LABEL_MARGIN;
}
@end
