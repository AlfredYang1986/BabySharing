//
//  AlbumCollectionViewDelegate.m
//  BabySharing
//
//  Created by monkeyheng on 16/2/26.
//  Copyright © 2016年 BM. All rights reserved.
//

#import "AlbumCollectionViewDelegate.h"
#import "PhotoCollectionViewCell.h"

@interface AlbumCollectionViewDelegate()

@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation AlbumCollectionViewDelegate

- (instancetype)init {
    self = [super init];
    if (self) {
        self.selectedIndex = 0;
    }
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSorce.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *indentifier = @"PhotoCollectionViewCell";
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:indentifier forIndexPath:indexPath];
    if (indexPath.row == self.selectedIndex) {
        cell.isSelected = YES;
    } else {
        cell.isSelected = NO;
    }
    cell.photoImageView.image = [self.dataSorce objectAtIndex:indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // 点击图片的方法
    [self.delegate collectionViewCellSelected:[self.pHAssetArr objectAtIndex:indexPath.row]];
}

@end
