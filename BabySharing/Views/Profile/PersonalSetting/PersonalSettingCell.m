//
//  PersonalSettingCell.m
//  BabySharing
//
//  Created by Alfred Yang on 29/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "PersonalSettingCell.h"
#import "TmpFileStorageModel.h"

@interface PersonalSettingCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *contentImage;
@end

@implementation PersonalSettingCell

@synthesize titleLabel = _titleLabel;
@synthesize contentImage = _contentImage;
@synthesize contentLabel = _contentLabel;

- (void)awakeFromNib {
    // Initialization code
    _contentImage.hidden = YES;
    _contentImage.layer.borderColor = [UIColor colorWithWhite:1.f alpha:0.25].CGColor;
    _contentImage.layer.borderWidth = 1.5f;
    _contentImage.layer.cornerRadius = 13.f;
    _contentImage.clipsToBounds = YES;
    
    _titleLabel.textColor = [UIColor grayColor];
    _contentLabel.textColor = [UIColor colorWithWhite:0.3059 alpha:1.f];
    _contentLabel.font = [UIFont systemFontOfSize:13.f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)preferredHeightWithImage:(BOOL)bImg {
//    if (bImg) return 67;
//    else return 44;
    return 44;
}

- (void)changeCellTitile:(NSString*)title {
    _titleLabel.text = title;
}

- (void)changeCellContent:(NSString*)content {
    _contentLabel.text = content;
}

- (void)changeCellImage:(NSString*)photo_name {
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    NSString * filePath = [resourceBundle pathForResource:[NSString stringWithFormat:@"User"] ofType:@"png"];
    
    UIImage* userImg = [TmpFileStorageModel enumImageWithName:photo_name withDownLoadFinishBolck:^(BOOL success, UIImage *user_img) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self) {
                    self.contentImage.image = user_img;
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
    [self.contentImage setImage:userImg];
    _contentImage.hidden = NO;
}
@end
