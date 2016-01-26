//
//  MessageChatGroupHeader2.m
//  BabySharing
//
//  Created by Alfred Yang on 1/26/16.
//  Copyright © 2016 BM. All rights reserved.
//

#import "MessageChatGroupHeader2.h"
#import "OBShapedButton.h"

#define MARGIN_TOP                      30
#define TIME_LABEL_HEIGHT               26
#define CHAT_CONTENT_MARGIN_BETWEEN     10.5

#define SCREEN_PHOTO_WIDTH              50
#define SCREEN_PHOTO_HEIGHT             50

#define CONTENT_2_EDGE_MARGIN_RADIO     0.18

#define CHAT_CONTENT_FONT_SIZE          14.f

@interface MessageChatGroupHeader2 ()
@property (weak, nonatomic) IBOutlet OBShapedButton *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *contentContainer;
@property (weak, nonatomic) IBOutlet UIImageView *screenPhoto;
@property (weak, nonatomic) IBOutlet OBShapedButton *chatContent;

@end

@implementation MessageChatGroupHeader2

@synthesize timeLabel = _timeLabel;
@synthesize contentContainer = _contentContainer;
@synthesize screenPhoto = _screenPhoto;
@synthesize chatContent = _chatContent;

+ (CGFloat)preferredHeightWithContent:(NSString*)content {
    
}

+ (CGSize)contentSizeWithContent:(NSString*)content {
    UIFont* font = [UIFont systemFontOfSize:CHAT_CONTENT_FONT_SIZE];
//    CGSize sz = [content sizeWithFont:font constrainedToSize:<#(CGSize)#>]
}

- (void)awakeFromNib {

    NSString * bundlePath = [[NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
   
    [_timeLabel setBackgroundImage:[UIImage imageNamed:[resourceBundle pathForResource:@"chat_time_label" ofType:@"png"]] forState:UIControlStateNormal];
    [_chatContent setBackgroundImage:[UIImage imageNamed:[resourceBundle pathForResource:@"chat_other_label" ofType:@"png"]] forState:UIControlStateNormal];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

- (void)setFounderScreenName:(NSString*)name {
    
}

- (void)setFounderScreenPhoto:(NSString *)photo {
    
}

- (void)setFounderRelations:(NSNumber*)relation {
    
}

- (void)setFounderRoleTag:(NSString*)role_tag {
    
}

- (void)setChatGroupThemeTitle:(NSString*)title {
    
}

//- (void)setCHatGroupJoinerNumber:(NSNumber*)number {
//    
//}
//
//- (void)setChatGroupUserList:(NSArray*)user_lst {
//    
//}
@end
