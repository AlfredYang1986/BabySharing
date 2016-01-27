//
//  MessageChatGroupHeader2.m
//  BabySharing
//
//  Created by Alfred Yang on 1/26/16.
//  Copyright © 2016 BM. All rights reserved.
//

#import "MessageChatGroupHeader2.h"
#import "OBShapedButton.h"
#import "TmpFileStorageModel.h"

#define MARGIN_TOP                              30
#define TIME_LABEL_HEIGHT                       26
#define CHAT_CONTENT_MARGIN_BETWEEN             10.5
#define CHAT_CONTENT_LEFT_MARGIN                21
#define MARGIN_BOTTOM                           10

#define SCREEN_PHOTO_WIDTH                      40
#define SCREEN_PHOTO_HEIGHT                     40

#define CHAT_CONTENT_NAME_2_CONTENT_MARGIN      4

#define CONTENT_2_EDGE_MARGIN_RADIO             0.18

#define CHAT_CONTENT_NAME_FONT_SIZE             12.f
#define CHAT_CONTENT_FONT_SIZE                  14.f

@interface MessageChatGroupHeader2 ()
@property (weak, nonatomic) IBOutlet OBShapedButton *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *contentContainer;
@property (weak, nonatomic) IBOutlet UIImageView *screenPhoto;
@property (strong, nonatomic) IBOutlet OBShapedButton *chatContent;

@end

@implementation MessageChatGroupHeader2 {
    UILabel* name_layer;
    UITextView* content_layer;
    
    CALayer* layer;
}

@synthesize timeLabel = _timeLabel;
@synthesize contentContainer = _contentContainer;
@synthesize screenPhoto = _screenPhoto;
@synthesize chatContent = _chatContent;

+ (CGFloat)preferredHeightWithContent:(NSString*)content {
    CGSize content_sz = [self contentSizeWithContent:content];
    CGSize name_sz = [self nameSizeWithName:content];
    return MAX(content_sz.height + name_sz.height + CHAT_CONTENT_NAME_2_CONTENT_MARGIN, SCREEN_PHOTO_HEIGHT) + MARGIN_BOTTOM + CHAT_CONTENT_MARGIN_BETWEEN + TIME_LABEL_HEIGHT + MARGIN_TOP + 10;
}

+ (CGSize)contentSizeWithContent:(NSString*)content {
    UIFont* font = [UIFont systemFontOfSize:CHAT_CONTENT_FONT_SIZE];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat flt_width = width * (1 - CONTENT_2_EDGE_MARGIN_RADIO) - CHAT_CONTENT_LEFT_MARGIN - CHAT_CONTENT_MARGIN_BETWEEN - SCREEN_PHOTO_WIDTH;
    
    return [content sizeWithFont:font constrainedToSize:CGSizeMake(flt_width, FLT_MAX)];
//    return CGSizeMake(sz.width, 2 * sz.height + CHAT_CONTENT_NAME_2_CONTENT_MARGIN);
}

+ (CGSize)nameSizeWithName:(NSString*)name {
    UIFont* font = [UIFont systemFontOfSize:CHAT_CONTENT_NAME_FONT_SIZE];
    return [name sizeWithFont:font constrainedToSize:CGSizeMake(FLT_MAX, FLT_MAX)];
}

- (void)awakeFromNib {

    NSString * bundlePath = [[NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
  
    [_timeLabel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_timeLabel setBackgroundImage:[UIImage imageNamed:[resourceBundle pathForResource:@"chat_time_label" ofType:@"png"]] forState:UIControlStateNormal];
   
    _screenPhoto.layer.cornerRadius = SCREEN_PHOTO_HEIGHT / 2;
    _screenPhoto.layer.borderWidth = 1.5f;
    _screenPhoto.layer.borderColor = [UIColor colorWithWhite:1.f alpha:0.25].CGColor;
    _screenPhoto.clipsToBounds = YES;
  
    _chatContent = [[OBShapedButton alloc]init];
    [_chatContent setBackgroundImage:[UIImage imageNamed:[resourceBundle pathForResource:@"chat_other_bg" ofType:@"png"]] forState:UIControlStateNormal];
//    _chatContent.backgroundColor = [UIColor colorWithRed:0.2745 green:0.8588 blue:0.7922 alpha:0.6];
    _chatContent.layer.cornerRadius = 5.f;
//    _chatContent.layer.borderColor = [UIColor colorWithWhite:0.5922 alpha:0.20].CGColor;
//    _chatContent.layer.borderWidth = 0.5f;
    _chatContent.clipsToBounds = YES;
    [_contentContainer addSubview:_chatContent];
    
    layer = [CALayer layer];
    layer.contents = (id)[UIImage imageNamed:[resourceBundle pathForResource:@"chat_other_tri" ofType:@"png"]].CGImage;
    layer.frame = CGRectMake(0, 8, 7, 12);
    [_contentContainer.layer addSublayer:layer];
    
    /**
     * fake time
     */
    _timeLabel.titleLabel.font = [UIFont systemFontOfSize:CHAT_CONTENT_FONT_SIZE];
    [_timeLabel setTitle:@"2天前" forState:UIControlStateNormal];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _chatContent.frame = CGRectMake(7 + CHAT_CONTENT_NAME_2_CONTENT_MARGIN + SCREEN_PHOTO_WIDTH + CHAT_CONTENT_LEFT_MARGIN, 0, MAX(name_layer.bounds.size.width, content_layer.bounds.size.width), name_layer.bounds.size.height + CHAT_CONTENT_NAME_2_CONTENT_MARGIN + content_layer.bounds.size.height);
    layer.frame = CGRectMake(CHAT_CONTENT_NAME_2_CONTENT_MARGIN + SCREEN_PHOTO_WIDTH + CHAT_CONTENT_LEFT_MARGIN, 10.5, 7, 12);
    _contentContainer.frame = CGRectMake(_contentContainer.frame.origin.x, _contentContainer.frame.origin.y, [UIScreen mainScreen].bounds.size.width, name_layer.bounds.size.height + CHAT_CONTENT_NAME_2_CONTENT_MARGIN + content_layer.bounds.size.height);
}

- (void)setFounderScreenName:(NSString*)name {
    
    if (name) {
        name_layer = [[UILabel alloc]init];
        name_layer.font = [UIFont systemFontOfSize:CHAT_CONTENT_NAME_FONT_SIZE];
        name_layer.text = name;
        name_layer.textColor = [UIColor darkGrayColor];
        [name_layer sizeToFit];
        name_layer.frame = CGRectMake(8, 8, name_layer.frame.size.width, name_layer.frame.size.height);
        [_chatContent addSubview:name_layer];
//        _chatContent.frame = CGRectMake(8 + CHAT_CONTENT_NAME_2_CONTENT_MARGIN + SCREEN_PHOTO_WIDTH + CHAT_CONTENT_LEFT_MARGIN, 0, MAX(name_layer.bounds.size.width, content_layer.bounds.size.width), name_layer.bounds.size.height + CHAT_CONTENT_NAME_2_CONTENT_MARGIN + content_layer.bounds.size.height);
    }
}

- (void)setFounderScreenPhoto:(NSString *)photo_name {
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle * resourceBundle = [NSBundle bundleWithPath:bundlePath];
    NSString * filePath = [resourceBundle pathForResource:[NSString stringWithFormat:@"User"] ofType:@"png"];
    
    UIImage* userImg = [TmpFileStorageModel enumImageWithName:photo_name withDownLoadFinishBolck:^(BOOL success, UIImage *user_img) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self) {
                    self.screenPhoto.image = user_img;
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
    [self.screenPhoto setImage:userImg];
}

- (void)setFounderRelations:(NSNumber*)relation {
    
}

- (void)setFounderRoleTag:(NSString*)role_tag {
    
}

- (void)setChatGroupThemeTitle:(NSString*)title {
    
    if (title) {

        CGSize content_sz = [MessageChatGroupHeader2 contentSizeWithContent:title];
        CGSize name_sz = [MessageChatGroupHeader2 nameSizeWithName:title];

        content_layer = [[UITextView alloc]initWithFrame:CGRectMake(4, name_sz.height + CHAT_CONTENT_NAME_2_CONTENT_MARGIN, content_sz.width + 16, 16 + content_sz.height)];
        content_layer.text = title;
        content_layer.font = [UIFont systemFontOfSize:CHAT_CONTENT_FONT_SIZE];
        content_layer.backgroundColor = [UIColor clearColor];
        content_layer.textColor = [UIColor whiteColor];
        content_layer.editable = NO;
        content_layer.scrollEnabled = NO;
        [_chatContent addSubview:content_layer];
//        _chatContent.frame = CGRectMake(8 + CHAT_CONTENT_NAME_2_CONTENT_MARGIN + SCREEN_PHOTO_WIDTH + CHAT_CONTENT_LEFT_MARGIN, 0, MAX(name_layer.bounds.size.width, content_layer.bounds.size.width), name_layer.bounds.size.height + CHAT_CONTENT_NAME_2_CONTENT_MARGIN + content_layer.bounds.size.height);
    }
}

//- (void)setCHatGroupJoinerNumber:(NSNumber*)number {
//    
//}
//
//- (void)setChatGroupUserList:(NSArray*)user_lst {
//    
//}
@end
