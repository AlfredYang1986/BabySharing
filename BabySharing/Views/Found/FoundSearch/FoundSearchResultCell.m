//
//  FoundSearchResultCell.m
//  BabySharing
//
//  Created by Alfred Yang on 8/12/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import "FoundSearchResultCell.h"
#import "TmpFileStorageModel.h"
#import "RemoteInstance.h"

#define RECOMMEND_COUNT 3

#define MARGIN 13
#define MARGIN_VER 16
// 内部
#define ICON_WIDTH 15
#define ICON_HEIGHT 15

#define TAG_HEIGHT 20
#define TAG_MARGIN 10

@interface FoundSearchResultCell ()
@property (weak, nonatomic) IBOutlet UIImageView *nextIcon;
@property (weak, nonatomic) IBOutlet UILabel *resultCountLabel;

@end

@implementation FoundSearchResultCell

@synthesize resultCountLabel = _resultCountLabel;
@synthesize nextIcon = _nextIcon;

- (void)awakeFromNib {
    // Initialization code
    _resultCountLabel.text = @"共%d个结果";
    [_resultCountLabel sizeToFit];
    
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    
    _nextIcon.image = [UIImage imageNamed:[resourceBundle pathForResource:@"found-more-friend-arror" ofType:@"png"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUserContentImages:(NSArray*)img_arr {
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    for (int index = 0; index < MIN(RECOMMEND_COUNT, img_arr.count); ++index) {
//        NSDictionary* iter = [img_arr objectAtIndex:index];
        NSDictionary* iter = [img_arr objectAtIndex:index];
        NSArray* items = [iter objectForKey:@"items"];
        NSDictionary* item = items.firstObject;
        
        UIImageView* tmp = (UIImageView*)[self viewWithTag:-1 - index];
        
        NSString * filePath = [resourceBundle pathForResource:[NSString stringWithFormat:@"User"] ofType:@"png"];
        NSString* photo_name = [item objectForKey:@"name"];
        UIImage* userImg = [TmpFileStorageModel enumImageWithName:photo_name withDownLoadFinishBolck:^(BOOL success, UIImage *user_img) {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self) {
                        tmp.image = user_img;
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
        [tmp setImage:userImg];
    }
}

- (void)setSearchTag:(NSString*)title andType:(NSNumber*)type {
    
    _tag_name = title;
    _tag_type = type;
    
    UIFont* font = [UIFont systemFontOfSize:11.f];
    CGSize sz_font = [title sizeWithFont:font constrainedToSize:CGSizeMake(FLT_MAX, FLT_MAX)];
    CGSize sz = CGSizeMake(TAG_MARGIN + ICON_WIDTH + sz_font.width + TAG_MARGIN, TAG_HEIGHT);
    
    UIView* btn = [[UIView alloc]initWithFrame:CGRectMake(0, 0, sz.width, sz.height)];
   
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    
    UIImage* image0 = [UIImage imageNamed:[resourceBundle pathForResource:@"tag-time" ofType:@"png"]];
    UIImage* image1 = [UIImage imageNamed:[resourceBundle pathForResource:@"tag-location" ofType:@"png"]];
    
    UIImageView* img = [[UIImageView alloc]initWithFrame:CGRectMake(TAG_MARGIN / 2, TAG_MARGIN / 4, ICON_WIDTH, ICON_HEIGHT)];
    if (type.integerValue == 0) {
        img.image = image0;
    } else {
        img.image = image1;
    }
    [btn addSubview:img];
    
    UILabel* label = [[UILabel alloc]init];
    label.font = font;
    label.text = title;
    label.textColor = [UIColor brownColor];
    label.frame = CGRectMake(TAG_MARGIN + ICON_WIDTH, 0, sz_font.width, TAG_HEIGHT);
    label.textAlignment = NSTextAlignmentLeft;
    [btn addSubview:label];
    
    btn.layer.borderColor = [UIColor brownColor].CGColor;
    btn.layer.borderWidth = 1.f;
    btn.layer.cornerRadius = btn.frame.size.height / 2;
    btn.clipsToBounds = YES;
    
    btn.center = CGPointMake(MARGIN + btn.frame.size.width / 2, [FoundSearchResultCell preferredHeight] / 2);
    [self addSubview:btn];

    CGFloat width = self.frame.size.width;;
    UIView* tmp = [self viewWithTag:-1];
    if (width - MARGIN - sz.width - tmp.frame.origin.x > _resultCountLabel.frame.size.width + 20) {
        _resultCountLabel.hidden = YES;
    }
}

- (void)setSearchResultCount:(NSInteger)count {
    _resultCountLabel.text = [NSString stringWithFormat:@"共%d个结果", count];
    [_resultCountLabel sizeToFit];
    _resultCountLabel.hidden = YES;
}

+ (CGFloat)preferredHeight {
    return 77;
}
@end
