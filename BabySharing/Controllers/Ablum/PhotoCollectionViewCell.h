//
//  PhotoCollectionViewCell.h
//  BabySharing
//
//  Created by monkeyheng on 16/2/26.
//  Copyright © 2016年 BM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface PhotoCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *photoImageView;
@property (nonatomic, weak) PHAsset *phAsset;
@property (nonatomic, assign) BOOL isSelected;

@end
