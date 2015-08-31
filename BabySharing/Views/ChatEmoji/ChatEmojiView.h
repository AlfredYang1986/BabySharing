//
//  ChatEmojiView.h
//  BabySharing
//
//  Created by Alfred Yang on 31/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChatEmoji <NSObject>

- (void)ChatEmojiSelected:(NSString*)emoji;
@end

@interface ChatEmojiView : UIView

@property (nonatomic, weak) id<ChatEmoji> delegate;
@end
