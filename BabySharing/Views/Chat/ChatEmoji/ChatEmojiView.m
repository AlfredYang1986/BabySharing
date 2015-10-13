//
//  ChatEmojiView.m
//  BabySharing
//
//  Created by Alfred Yang on 31/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "ChatEmojiView.h"

//将数字转为定义的宏将转成UTF8，取出对应的表情符号：
#define EMOJI_CODE_TO_SYMBOL(x) ((((0x808080F0 | (x & 0x3F000) >> 4) | (x & 0xFC0) << 10) | (x & 0x1C0000) << 18) | (x & 0x3F) << 24);

@implementation ChatEmojiView {
    NSArray* emojis;
}

@synthesize delegate = _delegate;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)init {
    self = [super init];
    if (self) {
        [self setUpSubViews];
    }
    
    return self;
}

- (void)setUpSubViews {
    
    self.backgroundColor = [UIColor whiteColor];
//    self.backgroundColor = [UIColor redColor];
    
    //获取数组
    emojis = [self defaultEmoticons];
    
    //将表情放到UIButton里
    CGFloat W = 30;
    CGFloat H = 30;
    CGFloat X;
    CGFloat Y;
    for (int i = 0; i < emojis.count; i++) {
        X = 10 +(W+5) * (i%10);
        Y = (i/10)* (H +5);
        UIButton *biaoqing =[[UIButton alloc] init];
//        biaoqing.backgroundColor = [UIColor redColor];
        biaoqing.backgroundColor = [UIColor clearColor];
        biaoqing.frame = CGRectMake(X, Y, W, H);
        [self addSubview:biaoqing];
        NSString *Str = emojis[i];
        [biaoqing setTitle:Str forState:UIControlStateNormal];
        biaoqing.tag = i;
        [biaoqing addTarget:self action:@selector(ChatEmojiSelected:) forControlEvents:UIControlEventTouchUpInside];
    }
}

//获取默认表情数组
- (NSArray *)defaultEmoticons {
    NSMutableArray *array = [NSMutableArray new];
    for (int i=0x1F600; i<=0x1F64F; i++) {
        if (i < 0x1F641 || i > 0x1F644) {
            int sym = EMOJI_CODE_TO_SYMBOL(i);
            NSString *emoT = [[NSString alloc] initWithBytes:&sym length:sizeof(sym) encoding:NSUTF8StringEncoding];
            [array addObject:emoT];
        }
    }
    return array;
}

- (void)ChatEmojiSelected:(UIButton*)sender {
    [_delegate ChatEmojiSelected:[emojis objectAtIndex:sender.tag]];
}
@end
