//
//  QueryLikesCell.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 22/01/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "QueryLikesCell.h"
#import "QueryContent.h"
#import "QueryLikes.h"
#import "TmpFileStorageModel.h"

#define IMAGE_WIDTH     32
#define IMAGE_HEIGHT    32
#define IMAGE_MARGIN    5

@interface QueryLikesCell ()
@property (weak, nonatomic) IBOutlet UIView *likePhotosContainer;

@end

@implementation QueryLikesCell {
    NSArray* likes_arr;
}

@synthesize likesLabel = _likesLabel;
@synthesize likePhotosContainer = _likePhotosContainer;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPhotoNameList:(QueryContent*)current_content {

    likes_arr = [current_content.likes.allObjects sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if ([((QueryLikes*)obj1).like_date timeIntervalSince1970] <= [((QueryLikes*)obj2).like_date timeIntervalSince1970])
            return NSOrderedDescending;
        else
            return NSOrderedAscending;
    }];
    
//    NSLog(@"likes array: %@", likes_arr);
   
    NSUInteger count = 0;
    if (likes_arr.count > 6) {
        count = 6;
    } else {
        count = [likes_arr count];
    }
    
    for (int index = 0; index < count; ++index) {
        QueryLikes* like = [likes_arr objectAtIndex:index];
        UIImageView* img = [[UIImageView alloc]initWithFrame:CGRectMake(index * IMAGE_WIDTH, 0, IMAGE_WIDTH, IMAGE_HEIGHT)];
        img.image = [TmpFileStorageModel enumImageWithName:like.like_owner_photo withDownLoadFinishBolck:^(BOOL success, UIImage* download_img) {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    img.image = download_img;
                    NSLog(@"change img success");
                });
            } else {
                NSLog(@"down load image %@ failed", like.like_owner_photo);
            }
        }];
        img.backgroundColor = [UIColor redColor];
        img.userInteractionEnabled = YES;
        img.tag = index + 1000;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didselectImg:)];
        [img addGestureRecognizer:tap];
        
        [_likePhotosContainer addSubview:img];
    }
}

- (void)didselectImg:(UIGestureRecognizer*)sender {
    NSInteger index = sender.view.tag - 1000;
   
    QueryLikes* like = [likes_arr objectAtIndex:index];
    [_delegate didSelectDetialOwnerNameOrImage:like.like_owner_id];
}
@end
