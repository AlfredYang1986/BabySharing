//
//  PostGridCell.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 2/01/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "AlbumGridCell.h"
#import "RemoteInstance.h"
#import "TmpFileStorageModel.h"

#define LAYER_WIDTH 20

@implementation AlbumGridCell

@synthesize row = _row;
@synthesize col = _col;
@synthesize viewSelected = _viewSelected;
@synthesize grid_border_color = _grid_border_color;

@synthesize cell_cor_radius = _cell_cor_radius;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderColor = [UIColor whiteColor].CGColor;
//        self.layer.borderWidth = 0.75f;
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)setCellCorRadius:(CGFloat)cell_cor_radius {
    _cell_cor_radius = cell_cor_radius;
    self.layer.cornerRadius = _cell_cor_radius;
}

- (void)setGridBorderColor:(UIColor *)c {
    _grid_border_color = c;
    if (!_viewSelected) {
        self.layer.borderColor = _grid_border_color.CGColor;
    }
}

- (void)setCellViewSelected2:(BOOL)select {
    if (select == NO) {
        [selectLayer removeFromSuperlayer];
    } else {
        if (selectLayer == nil) {
            selectLayer = [CALayer layer];
            CGFloat width = self.frame.size.width;
            CGFloat height = self.frame.size.height;
            selectLayer.frame = CGRectMake(width - LAYER_WIDTH, height - LAYER_WIDTH, LAYER_WIDTH, LAYER_WIDTH);
        
            NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
            NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
            
            NSString* filepath = [resourceBundle pathForResource:@"Tick" ofType:@"png"];
            selectLayer.contents = (id)[UIImage imageNamed:filepath].CGImage;
        }
        [self.layer addSublayer:selectLayer];
    }
    _viewSelected = select;
}

- (void)setCellViewSelected:(BOOL)select {
    if (select == NO) {
        UIColor* c = _grid_border_color == nil ? [UIColor whiteColor] : _grid_border_color;
        self.layer.borderColor = c.CGColor;
        self.layer.borderWidth = 0.75f;
        
    } else {
        self.layer.borderColor = [UIColor colorWithRed:0.3126 green:0.7529 blue:0.6941 alpha:1.f].CGColor;
        self.layer.borderWidth = 2.f;
    }
    _viewSelected = select;
}

- (void)setMovieDurationLayer:(NSNumber*)duration {
    if (durationLayer == nil) {
        durationLayer = [CATextLayer layer];
        CGFloat width = self.frame.size.width;
        CGFloat height = self.frame.size.height;
        durationLayer.fontSize = 10.0;
        durationLayer.frame = CGRectMake(0, height - LAYER_WIDTH, width, LAYER_WIDTH);
        durationLayer.backgroundColor = [UIColor blackColor].CGColor;
        durationLayer.foregroundColor = [UIColor whiteColor].CGColor;

        durationLayer.string= [self seconds2Time:duration];
    }
    [self.layer addSublayer:durationLayer];
}

- (NSString*)seconds2Time:(NSNumber*)duration {
    int secends = duration.intValue;
    int hours = secends / 3600;
    int minutes = (secends - hours * 3600) / 60;
    secends = secends - hours * 3600 - minutes * 60;
   
    return [NSString stringWithFormat:@"%2d:%2d:%2d", hours, minutes, secends];
}

- (void)setShowingPhotoWithName:(NSString*)photo_name {
    NSLog(@"MonkeyHengLog: %@ === %@", @"photo_name", photo_name);
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    NSString * filePath = [resourceBundle pathForResource:[NSString stringWithFormat:@"relase_imge_default"] ofType:@"png"];
    [self setImage:[UIImage imageNamed:filePath]];
    UIImage* userImg = [TmpFileStorageModel enumImageWithName:photo_name withDownLoadFinishBolck:^(BOOL success, UIImage *user_img) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self) {
                    self.image = user_img;
                    NSLog(@"owner img download success");
                }
            });
        } else {
            NSLog(@"down load owner image %@ failed", photo_name);
        }
    }];
    if (userImg != nil) {
        [self setImage:userImg];
//        userImg = [UIImage imageNamed:filePath];
    }
}
@end
