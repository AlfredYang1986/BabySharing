//
//  AlbumCollectionViewDelegate.h
//  BabySharing
//
//  Created by monkeyheng on 16/2/26.
//  Copyright © 2016年 BM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@protocol CollectionViewCellSelectedDelegate <NSObject>

- (void)collectionViewCellSelected:(PHAsset *)pHAsset;

@end

@interface AlbumCollectionViewDelegate : NSObject <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, weak) NSArray<UIImage *> *dataSorce;
@property (nonatomic, weak) NSArray<PHAsset *> *pHAssetArr;
@property (nonatomic, weak) id<CollectionViewCellSelectedDelegate> delegate;

@end
