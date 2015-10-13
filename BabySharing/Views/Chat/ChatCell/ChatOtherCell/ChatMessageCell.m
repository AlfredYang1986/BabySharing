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

#define IMG_WIDTH 50
#define IMG_HEIGHT IMG_WIDTH

#define MARGIN 8

#define TIME_FONT_SIZE 12.f
#define CONTENT_FONT_SIZE 15.f

@implementation ChatMessageCell {
    UILabel* time_label;
    UITextView* content;
    UIImageView* imgView;
    
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
    
    if (time_label == nil) {
        time_label = [[UILabel alloc]init];
        [self addSubview:time_label];
        time_label.font = [UIFont systemFontOfSize:12.f];
    }
    
    if (content == nil) {
        content = [[UITextView alloc]init];
        content.editable = NO;
        [self addSubview:content];
        content.layer.cornerRadius = MARGIN;
        content.clipsToBounds = YES;
        content.layer.borderColor = [UIColor grayColor].CGColor;
        content.layer.borderWidth = 1.f;
        content.font = [UIFont systemFontOfSize:15.f];
        content.scrollEnabled = NO;
    }
    
    if (imgView == nil) {
        imgView = [[UIImageView alloc]init];
        imgView.bounds = CGRectMake(0, 0, IMG_WIDTH, IMG_HEIGHT);
        imgView.layer.cornerRadius = IMG_WIDTH / 2;
        imgView.clipsToBounds = YES;
        [self addSubview:imgView];
    }
}

- (void)layoutSubviews {
    if (isSenderByOwner) {
        
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat offset_x = width - MARGIN;
        CGFloat offset_y = MARGIN;
        imgView.frame = CGRectMake(offset_x - IMG_WIDTH, offset_y, IMG_WIDTH, IMG_HEIGHT);
        
        offset_x -= IMG_WIDTH + MARGIN;
        
        UIFont* font = [UIFont systemFontOfSize:TIME_FONT_SIZE];
        CGSize label_size = [@"88-88" sizeWithFont:font constrainedToSize:CGSizeMake(FLT_MAX, FLT_MAX)];
      
        CGFloat content_width = width - 3 * MARGIN - 2 * IMG_WIDTH - label_size.width;
        UIFont* content_font = [UIFont systemFontOfSize:CONTENT_FONT_SIZE];
        CGSize content_size = [content.text sizeWithFont:content_font constrainedToSize:CGSizeMake(content_width, FLT_MAX)];
        content.frame = CGRectMake(offset_x - content_width, offset_y, content_width, MAX(content_size.height + 2 * MARGIN, IMG_HEIGHT));
        
        content.backgroundColor = [UIColor colorWithRed:0.3126 green:0.7529 blue:0.6941 alpha:1.f];
        
        offset_x -= content_width + MARGIN;
       
        [time_label sizeToFit];
        time_label.frame = CGRectMake(offset_x - time_label.bounds.size.width, offset_y, time_label.bounds.size.width, time_label.bounds.size.height);
        
    } else {

        CGFloat offset_x = MARGIN;
        CGFloat offset_y = MARGIN;
        imgView.frame = CGRectMake(offset_x, offset_y, IMG_WIDTH, IMG_HEIGHT);
        
        offset_x += IMG_WIDTH + MARGIN;
        
        UIFont* font = [UIFont systemFontOfSize:TIME_FONT_SIZE];
        CGSize label_size = [@"88-88" sizeWithFont:font constrainedToSize:CGSizeMake(FLT_MAX, FLT_MAX)];
      
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat content_width = width - 3 * MARGIN - 2 * IMG_WIDTH - label_size.width;
        UIFont* content_font = [UIFont systemFontOfSize:CONTENT_FONT_SIZE];
        CGSize content_size = [content.text sizeWithFont:content_font constrainedToSize:CGSizeMake(content_width, FLT_MAX)];
        content.frame = CGRectMake(offset_x, offset_y, content_width, MAX(content_size.height + 2 * MARGIN, IMG_HEIGHT));
        
        offset_x += content_width + MARGIN;
       
        [time_label sizeToFit];
        time_label.frame = CGRectMake(offset_x, offset_y, time_label.bounds.size.width, time_label.bounds.size.height);
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
           
            NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
            NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
            NSString * filePath = [resourceBundle pathForResource:[NSString stringWithFormat:@"User"] ofType:@"png"];
            
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
    time_label.text = [formatter stringFromDate:date];
}

+ (CGFloat)preferredHeightWithInputText:(NSString*)content {
    /**
     * 1. get screen width
     */
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
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
    CGFloat content_width = width - 3 * MARGIN - IMG_WIDTH - label_size.width;
    UIFont* content_font = [UIFont systemFontOfSize:CONTENT_FONT_SIZE];
    CGSize content_size = [content sizeWithFont:content_font constrainedToSize:CGSizeMake(content_width, FLT_MAX)];
    
    return MAX(IMG_HEIGHT + 2 * MARGIN, content_size.height + 6 * MARGIN);
}
@end
