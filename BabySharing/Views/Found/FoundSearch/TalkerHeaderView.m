//
//  TalkerHeaderView.m
//  BabySharing
//
//  Created by monkeyheng on 16/3/16.
//  Copyright © 2016年 BM. All rights reserved.
//

#import "TalkerHeaderView.h"
#import "TmpFileStorageModel.h"
@interface TalkerHeaderView()

@property (nonatomic, strong) NSMutableArray<UIImageView *> *arr;
@property (nonatomic, assign) HeaderViewShape shape;

@end

@implementation TalkerHeaderView

- (instancetype)initWithFrame:(CGRect)frame count:(NSInteger)count shape:(HeaderViewShape)shape{
    self = [super initWithFrame:frame];
    if (self) {
        _arr = [NSMutableArray array];
        self.shape = shape;
        [self createSubViewsWithCount:count];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _arr = [NSMutableArray array];
        for (NSInteger i = 0; i < 3; i++) {
            UIImageView *imge = [[UIImageView alloc] init];
            [self addSubview:imge];
            [_arr addObject:imge];
        }
    }
    return self;
}

- (void)createSubViewsWithCount:(NSInteger)count {
    if (count == 0) {
        return;
    }
    if (count == 1) {
        self.padding = 0;
    } else {
        self.padding = (CGRectGetHeight(self.frame) * count - CGRectGetWidth(self.frame)) / ((count - 1) * 2);
    }
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    CGFloat x = CGRectGetHeight(self.frame) / 2;
    for (NSInteger i = 0; i < _imageArr.count; i++) {
        UIImageView *imageView = [_arr objectAtIndex:i];
        [self bringSubviewToFront:imageView];
        imageView.frame = CGRectMake(0, 0, CGRectGetHeight(self.frame), CGRectGetHeight(self.frame));
        imageView.center = CGPointMake(x + CGRectGetHeight(self.frame) * i - self.padding * 2 * i, CGRectGetHeight(self.frame) / 2);
        NSDictionary* iter = [_imageArr objectAtIndex:i];
        NSArray* items = [iter objectForKey:@"items"];
        NSDictionary* item = items.firstObject;
        
        NSString * filePath = [resourceBundle pathForResource:[NSString stringWithFormat:@"default_user"] ofType:@"png"];
        NSString* photo_name = [item objectForKey:@"name"];
        UIImage* userImg = [TmpFileStorageModel enumImageWithName:photo_name withDownLoadFinishBolck:^(BOOL success, UIImage *user_img) {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self) {
                        imageView.image = user_img;
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
        [imageView setImage:userImg];
    }
    
    
//    self.padding = (CGRectGetHeight(self.frame) * count - CGRectGetWidth(self.frame)) / ((count - 1) * 2);
//    CGFloat x = CGRectGetHeight(self.frame) / 2;
//    NSArray<UIColor *> *colorArr = @[[UIColor redColor], [UIColor blueColor], [UIColor yellowColor], [UIColor orangeColor]];
//    for (NSInteger i = count - 1; i >= 0; i--) {
//        UIImageView *imageView = [[UIImageView alloc] init];
//        imageView.frame = CGRectMake(0, 0, CGRectGetHeight(self.frame), CGRectGetHeight(self.frame));
//        if (self.shape != Square) {
//            imageView.layer.cornerRadius = CGRectGetHeight(imageView.frame) / 2;
//            imageView.layer.borderWidth = 2.0f;
//            imageView.layer.borderColor = [UIColor whiteColor].CGColor;
//        }
//        imageView.center = CGPointMake(x + CGRectGetHeight(self.frame) * i - self.padding * 2 * i, CGRectGetHeight(self.frame) / 2);
//        imageView.backgroundColor = [colorArr objectAtIndex:i];
//        [self addSubview:imageView];
//        [_arr addObject:imageView];
//    }
}



- (void)layoutSubviews {
    [super layoutSubviews];
//    NSInteger i = _arr.count - 1;
//    CGFloat x = CGRectGetHeight(self.frame) / 2;
//    for (UIImageView *imageView in _arr) {
//        imageView.center = CGPointMake(x + CGRectGetHeight(self.frame) * i - self.padding * 2 * i, CGRectGetHeight(self.frame) / 2);
//        i--;
//    }
//    self.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), CGRectGetMaxX([_arr firstObject].frame), CGRectGetHeight(self.frame));
}

- (CGRect)newFrame {
    NSInteger i = _arr.count - 1;
    CGFloat x = CGRectGetHeight(self.frame) / 2;
    for (UIImageView *imageView in _arr) {
        imageView.center = CGPointMake(x + CGRectGetHeight(self.frame) * i - self.padding * 2 * i, CGRectGetHeight(self.frame) / 2);
        i--;
    }
    return CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), CGRectGetMaxX([_arr firstObject].frame), CGRectGetHeight(self.frame));
}

- (void)setImageArr:(NSArray *)imageArr {
    _imageArr = imageArr;
    [self createSubViewsWithCount:imageArr.count > 3 ? 3 : imageArr.count ];
}

- (NSArray<UIImageView *> *)getAllHeadImageView {
    return _arr;
}
@end
