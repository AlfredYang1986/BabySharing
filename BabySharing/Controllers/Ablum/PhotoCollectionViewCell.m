//
//  PhotoCollectionViewCell.m
//  BabySharing
//
//  Created by monkeyheng on 16/2/26.
//  Copyright © 2016年 BM. All rights reserved.
//

#import "PhotoCollectionViewCell.h"

@implementation PhotoCollectionViewCell
- (instancetype)init {
    self = [super init];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    self.photoImageView = [[UIImageView alloc] init];
}

- (void)layoutSubviews {
    self.photoImageView.frame = self.frame;
    self.photoImageView.layer.borderColor = [UIColor greenColor].CGColor;
}

- (void)setIsSelected:(BOOL)isSelected {
    self.photoImageView.layer.borderWidth = isSelected ? 2.0 : 0.0;
    _isSelected = !isSelected;
}

@end
