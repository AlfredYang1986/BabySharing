//
//  DropDownItem.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 4/01/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "DropDownItem.h"

@interface DropDownItem()

@property (nonatomic, strong) UIImageView *albumImage;
@property (nonatomic, strong) UILabel *albumTitle;

@end

@implementation DropDownItem

@synthesize group = _group;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.albumImage = [[UIImageView alloc] init];
        self.albumTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
        self.albumTitle.textAlignment = NSTextAlignmentLeft;
        self.albumTitle.textColor = [UIColor colorWithRed:74.0 / 255.0 green:74.0 / 255.0 blue:74.0 / 255.0 alpha:1.0];
        [self.contentView addSubview:self.albumImage];
        [self.contentView addSubview: self.albumTitle];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.albumImage.frame = CGRectMake(10, 10, CGRectGetHeight(self.contentView.frame) - 20, CGRectGetHeight(self.contentView.frame) - 20);
    self.albumTitle.center = CGPointMake(CGRectGetHeight(self.contentView.frame) + CGRectGetWidth(self.albumTitle.frame) / 2, CGRectGetHeight(self.contentView.frame) / 2);
}

- (void)setAlbum:(NSObject *)album {
    _album = album;
    if ([_album isKindOfClass:[PHFetchResult class]]) {
        PHFetchResult *fetchResult = (PHFetchResult *)_album;
        if (fetchResult.count == 0) {
            return;
        }
        PHAsset *firstAsset = [fetchResult firstObject];
        PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
        [imageManager requestImageForAsset:firstAsset targetSize:self.albumImage.frame.size contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            self.albumImage.image = result;
        }];
        self.albumTitle.text = [NSString stringWithFormat:@"所有照片 (%lu)", (unsigned long)fetchResult.count];
    } else if ([_album isKindOfClass:[PHCollection class]]) {
        PHAssetCollection *assetCollection = (PHAssetCollection *)_album;
        PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
        if (fetchResult.count == 0) {
            return;
        }
        PHAsset *firstAsset = [fetchResult firstObject];
        PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
        [imageManager requestImageForAsset:firstAsset targetSize:CGSizeMake(self.albumImage.frame.size.width * 2, self.albumImage.frame.size.width * 2) contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            self.albumImage.image = result;
        }];
        self.albumTitle.text = [NSString stringWithFormat:@"%@ (%lu)", assetCollection.localizedTitle, (unsigned long)fetchResult.count];
    }
}


@end
