//
//  QueryCommonsCell.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 12/01/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "QueryCommentsCell.h"
#import "QueryComments.h"
#import "TmpFileStorageModel.h"

@implementation QueryCommentsCell

@synthesize delegate = _delegate;
@synthesize comment_post_date_label = _comment_post_date_label;
@synthesize owner_name_label = _owner_name_label;
@synthesize owner_photo_view = _owner_photo_view;
@synthesize commentField = _commentField;
@synthesize current_comments = _current_comments;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCommentOwnerImg:(NSString*)name {
    _owner_photo_view.image = [TmpFileStorageModel enumImageWithName:_current_comments.comment_owner_photo withDownLoadFinishBolck:^(BOOL success, UIImage* download_img) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                _owner_photo_view.image = download_img;
                NSLog(@"change img success");
            });
        } else {
            NSLog(@"down load image %@ failed", _current_comments.comment_owner_photo);
            NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
            NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
            NSString * filePath = [resourceBundle pathForResource:[NSString stringWithFormat:@"User"] ofType:@"png"];
            UIImage *image = [UIImage imageNamed:filePath];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.owner_photo_view.image = image;
            });
        }
    }];

//    _owner_photo_view.backgroundColor = [UIColor redColor];
    _owner_photo_view.userInteractionEnabled = YES;
//    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didselectImg:)];
//    [img addGestureRecognizer:tap];
}
@end
