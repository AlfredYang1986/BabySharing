//
//  TagQueryCell.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 20/06/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "TagQueryCell.h"
#import "QueryContent.h"
#import "QueryContentItem.h"
#import "TmpFileStorageModel.h"

#define ROW_ITEM_COUNT 3

@implementation TagQueryCell

@synthesize range_content = _range_content;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)getPreferHeight {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    return width / ROW_ITEM_COUNT;
}

+ (NSInteger)getRowItemCount {
    return ROW_ITEM_COUNT;
}

- (void)removeAllSubviews {
    for (UIView* view in self.subviews) {
        [view removeFromSuperview];
    }
}

- (void)setRangeContent:(NSArray*)contents {
   
    [self removeAllSubviews];
    _range_content = contents;
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat step_width = width / ROW_ITEM_COUNT;
    CGFloat height = step_width;
    
    for (NSInteger index = 0; index < MIN(contents.count, ROW_ITEM_COUNT); ++index) {
        CGRect rect = CGRectMake(index * step_width, 0.f, step_width, height);
        UIImageView * tmp = [[UIImageView alloc]initWithFrame:rect];
        tmp.contentMode = UIViewContentModeScaleToFill;
        QueryContent* cur = [contents objectAtIndex:index];
        QueryContentItem* cur_item = cur.items.anyObject;
        tmp.image =[TmpFileStorageModel enumImageWithName:cur_item.item_name withDownLoadFinishBolck:^(BOOL success, UIImage* download_img) {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    tmp.image = download_img;
                    NSLog(@"change img success");
                });
            } else {
                NSLog(@"down load image %@ failed", cur_item.item_name);
            }
        }];
        
        [self addSubview:tmp];
    }
}
@end
