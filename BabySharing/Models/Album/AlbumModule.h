//
//  AlbumModule.h
//  BabySharing
//
//  Created by Alfred Yang on 10/07/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ALAsset;
@class ALAssetsGroup;

typedef void(^AssetsFindishBlock)(NSArray* result);

@interface AlbumModule : NSObject

- (id)init;

- (void)enumPhoteAlumNameWithBlock:(AssetsFindishBlock)block;
- (void)enumFirstAssetWithProprty:(NSString*)type finishBlock:(AssetsFindishBlock)block;
- (void)enumAllAssetWithProprty:(NSString*)type finishBlock:(AssetsFindishBlock)block;
- (void)enumPhotoAblumByAlbumName:(ALAssetsGroup*)group finishBlock:(AssetsFindishBlock)block;

@end