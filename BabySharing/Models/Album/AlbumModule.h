//
//  AlbumModule.h
//  BabySharing
//
//  Created by Alfred Yang on 10/07/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@class ALAsset;
@class ALAssetsGroup;

// 只有调用的时候才在外部启用异步线程

typedef void(^AssetsFindishBlock)(NSArray* result);
typedef void(^PhotoFindishBlock)(NSArray<UIImage *>* thumbnailImage, NSArray<PHAsset *> *phAsset);
typedef void(^RealPhotoFindishBlock)(UIImage *liveImage);


@interface AlbumModule : NSObject

@property (nonatomic, weak) UIViewController *VC;

- (id)init;

- (void)enumPhoteAlumNameWithBlock:(AssetsFindishBlock)block;
- (void)enumFirstAssetWithProprty:(NSString*)type finishBlock:(AssetsFindishBlock)block;
- (void)enumAllAssetWithProprty:(NSString*)type finishBlock:(AssetsFindishBlock)block;
- (void)enumPhotoAblumByAlbumName:(ALAssetsGroup*)group finishBlock:(AssetsFindishBlock)block;


// 以上的方法废弃掉了
+ (void)enumAllPhotoWithBlock:(PhotoFindishBlock)block;
+ (void)enumAllAlbumWithBlock:(AssetsFindishBlock)block;
+ (void)enumAllPhotoWithPHFetchResult:(PHFetchResult *)fetchResult block:(PhotoFindishBlock)block;
+ (void)getRealPhotoWithPHAsset:(PHAsset *)pHAsset block:(RealPhotoFindishBlock)block;

@end