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
#import "Tools.h"

#define IMG_WIDTH               32
#define IMG_HEIGHT              IMG_WIDTH

#define MARGIN                  8
#define MARGIN_BIG              14

#define TIME_LABEL_MARGIN       10.5
#define TIME_LABEL_HEIGHT       26

#define TIME_FONT_SIZE          10.f
#define NAME_FONT_SIZE          10.f
#define CONTENT_FONT_SIZE       14.f

#define MARGIN_BOTTOM       8
#define NAME_MARGIN_TOP     10

@implementation ChatMessageCell {
//    OBShapedButton* time_label;
    UITextView* content;
    UILabel* time_label;
    UILabel* name_label;
//    UILabel* content;
    UIImageView* imgView;
   
    CALayer* layer;
    
    BOOL isSenderByOwner;
    
    NSString* sender_user_id;
}

@synthesize message = _message;
@synthesize lm = _lm;
@synthesize delegate = _delegate;

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
    
    if (time_label == nil) {
        time_label = [[UILabel alloc]init];
        time_label.font = [UIFont systemFontOfSize:TIME_FONT_SIZE];
        time_label.textColor = [UIColor colorWithWhite:0.2902 alpha:1.f];
        [self addSubview:time_label];
    }
   
    if (name_label == nil) {
        name_label = [[UILabel alloc]init];
        name_label.font = [UIFont systemFontOfSize:NAME_FONT_SIZE];
        name_label.textColor = [UIColor colorWithWhite:0.2902 alpha:1.f];
        [self addSubview:name_label];
    }
    
    if (content == nil) {

        content = [[UITextView alloc]init];
        content.editable = NO;
        [self addSubview:content];
        content.textColor = [UIColor colorWithWhite:0.2902 alpha:1.f];
        content.layer.cornerRadius = 5.f;
        content.clipsToBounds = YES;
        content.layer.borderColor = [UIColor clearColor].CGColor;
        content.layer.borderWidth = 1.f;
        content.font = [UIFont systemFontOfSize:CONTENT_FONT_SIZE];
        content.scrollEnabled = NO;

        layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, 7, 14);
        [self.layer addSublayer:layer];
        
        [content addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew) context:NULL];
    }
    
    if (imgView == nil) {
        imgView = [[UIImageView alloc]init];
        imgView.bounds = CGRectMake(0, 0, IMG_WIDTH, IMG_HEIGHT);
        imgView.layer.borderColor = [UIColor colorWithWhite:1.f alpha:0.3].CGColor;
        imgView.layer.borderWidth = 1.5f;
        imgView.layer.cornerRadius = IMG_WIDTH / 2;
        imgView.clipsToBounds = YES;
        [self addSubview:imgView];
        
        imgView.userInteractionEnabled = YES;
        UITapGestureRecognizer* gusture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(screenPhotoTaped:)];
        [imgView addGestureRecognizer:gusture];
    }
}

#pragma mark - KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    UITextView *tv = object;
    // Center vertical alignment
    
    CGFloat topCorrect = ([tv bounds].size.height - [tv contentSize].height * [tv zoomScale])/2.0;
    topCorrect = ( topCorrect < 0.0 ? 0.0 : topCorrect );
    tv.contentOffset = (CGPoint){.x = 0, .y = -topCorrect};
    
    //    // Bottom vertical alignment
    //    CGFloat topCorrect = ([tv bounds].size.height - [tv contentSize].height);
    //    topCorrect = (topCorrect <0.0 ? 0.0 : topCorrect);
    //    tv.contentOffset = (CGPoint){.x = 0, .y = -topCorrect};
    
}

- (void)dealloc {
    [content removeObserver:self forKeyPath:@"contentSize"];
}

- (void)screenPhotoTaped:(UITapGestureRecognizer*)gusture {
    [_delegate didSelectedScreenPhotoForUserID:sender_user_id];
}

- (void)layoutSubviews {
    if (isSenderByOwner) {
        
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat img_container = (MARGIN_BIG + IMG_WIDTH + 2 * MARGIN);
        CGFloat offset_x = width - img_container;
        CGFloat offset_y = MARGIN_BIG + NAME_MARGIN_TOP;
        imgView.frame = CGRectMake(width - MARGIN_BIG - IMG_WIDTH, offset_y, IMG_WIDTH, IMG_HEIGHT);
        
        name_label.hidden = YES;
        
        CGFloat content_width = width - 2 * img_container; //3 * MARGIN - (width - offset_x) - IMG_WIDTH;
        UIFont* content_font = [UIFont systemFontOfSize:CONTENT_FONT_SIZE];
        CGSize content_size = [content.text sizeWithFont:content_font constrainedToSize:CGSizeMake(content_width, FLT_MAX)];
        content.frame = CGRectMake(offset_x - content_size.width - 2 * MARGIN, offset_y, content_size.width + MARGIN * 2, MAX(content_size.height + 2 * MARGIN, IMG_HEIGHT));
        content.contentSize = CGSizeMake(content_size.width + 16, content_size.height + 2 * MARGIN);
        content.backgroundColor = [UIColor colorWithWhite:1.f alpha:0.8];
        
        NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
        NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
        layer.contents = (id)[UIImage imageNamed:[resourceBundle pathForResource:@"chat_mine_tri" ofType:@"png"]].CGImage;
        layer.frame = CGRectMake(offset_x - content_size.width - 16 + content_size.width + 16 - 1, offset_y + 10.5, 7, 14);
        
        offset_x -= content_size.width + MARGIN;

        [time_label sizeToFit];
        time_label.center = CGPointMake(offset_x - 6 - TIME_LABEL_MARGIN - time_label.bounds.size.width / 2, offset_y + TIME_LABEL_HEIGHT / 2 - 4);
        
    } else {

        CGFloat offset_x = MARGIN_BIG;
        CGFloat offset_y = MARGIN_BIG + NAME_MARGIN_TOP;
        CGFloat img_container = (MARGIN_BIG + IMG_WIDTH + 2 * MARGIN);
        imgView.frame = CGRectMake(offset_x, offset_y, IMG_WIDTH, IMG_HEIGHT);
        
        offset_x += IMG_WIDTH + 2 * MARGIN;

        [name_label sizeToFit];
        name_label.center = CGPointMake(offset_x + name_label.bounds.size.width / 2, name_label.bounds.size.height / 2 + NAME_MARGIN_TOP);
        
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat content_width = width - 2 * img_container;
        UIFont* content_font = [UIFont systemFontOfSize:CONTENT_FONT_SIZE];
        CGSize content_size = [content.text sizeWithFont:content_font constrainedToSize:CGSizeMake(content_width, FLT_MAX)];
        content.frame = CGRectMake(offset_x, offset_y, content_size.width + 2 * MARGIN, MAX(content_size.height + 2 * MARGIN, IMG_HEIGHT));
        content.contentSize = CGSizeMake(content_size.width + 2 * MARGIN, content_size.height + 2 * MARGIN);
        content.backgroundColor = [UIColor colorWithRed:0.2745 green:0.8588 blue:0.7922 alpha:0.6];

        NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
        NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
        layer.contents = (id)[UIImage imageNamed:[resourceBundle pathForResource:@"chat_other_tri" ofType:@"png"]].CGImage;
        layer.frame = CGRectMake(offset_x - 7, offset_y + 10.5, 7, 14);
        
        offset_x += content_size.width + MARGIN;

        [time_label sizeToFit];
        time_label.center = CGPointMake(offset_x + 6 + TIME_LABEL_MARGIN + time_label.bounds.size.width / 2, offset_y + TIME_LABEL_HEIGHT / 2 - 4);
    }
}

- (void)setGotyeOCMessage:(GotyeOCMessage*)msg {
    _message = msg;
    
    isSenderByOwner = [_lm.current_user_id isEqualToString:_message.sender.name];
    [self setSenderImage:@""];
    [self setContent:msg.text];
    [self setContentDate:nil];
    
    sender_user_id = _message.sender.name;
}

- (void)setSenderImage:(NSString*)photo_name {
    dispatch_queue_t up = dispatch_queue_create("Get Profile Details", nil);
    dispatch_async(up, ^{
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
//        [dic setValue:_lm.current_auth_token forKey:@"query_auth_token"];
//        [dic setValue:_lm.current_user_id forKey:@"query_user_id"];
        [dic setValue:_lm.current_auth_token forKey:@"auth_token"];
        [dic setValue:_lm.current_user_id forKey:@"user_id"];
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
                
                name_label.text = [reVal objectForKey:@"screen_name"];
                [name_label sizeToFit];
            });
        }
    });
}

- (void)setContent:(NSString*)content_text {
    content.text = content_text;
}

- (void)setContentDate:(NSDate*)date2 {
    time_label.text = [Tools compareCurrentTime:date2];
}

+ (CGFloat)preferredHeightWithInputText:(NSString*)content andSenderID:(NSString*)sender_user_id {
    /**
     * 1. get screen width
     */
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
  
    /**
     * 4. width left for content
     */
    CGFloat img_container = (MARGIN_BIG + IMG_WIDTH + 2 * MARGIN);
    CGFloat content_width = width - 2 * img_container;
    UIFont* content_font = [UIFont systemFontOfSize:CONTENT_FONT_SIZE];
    CGSize content_size = [content sizeWithFont:content_font constrainedToSize:CGSizeMake(content_width, FLT_MAX)];
  
    AppDelegate* app = [UIApplication sharedApplication].delegate;
    
//    return (MAX(IMG_HEIGHT, content_size.height + 2 * MARGIN) + MARGIN_BIG + MARGIN_BOTTOM) + (app.lm.current_user_id == sender_user_id ? 0 : NAME_MARGIN_TOP);
    return (MAX(IMG_HEIGHT, content_size.height + 2 * MARGIN) + MARGIN_BIG + MARGIN_BOTTOM) + NAME_MARGIN_TOP;
}
@end
