//
//  AlbumModule.m
//  BabySharing
//
//  Created by Alfred Yang on 10/07/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "AlbumModule.h"
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

@implementation AlbumModule {
    ALAssetsLibrary* assetsLibrary;
    NSMutableArray *albumArr;
}

+ (void)enumAllPhotoWithBlock:(PhotoFindishBlock)block {

    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    PHFetchResult *fetchResult = [PHAsset fetchAssetsWithOptions:options];
    
    PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_queue_t queue = dispatch_queue_create("aaaaa", nil);
    NSMutableArray<UIImage *> *imageArr = [NSMutableArray array];
    NSMutableArray<PHAsset *> *assetArr = [NSMutableArray array];
    CGSize size = CGSizeMake([UIScreen mainScreen].bounds.size.width / 3, [UIScreen mainScreen].bounds.size.width / 3);
        PHAsset *asset;
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.synchronous = YES;
    for (int i = 0; i < fetchResult.count; i++) {
        asset = [fetchResult objectAtIndex:i];
        [assetArr addObject:asset];
        NSLog(@"%@ === %d", @"iiiiii", i);
        [imageManager requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFit options:option resultHandler:^(UIImage *result, NSDictionary *info) {
            [imageArr addObject:result];
            NSLog(@"%@ === %lu", @"iamgeArr", (unsigned long)imageArr.count);
        }];
    }
    block(imageArr, assetArr);
}

+ (void)enumAllAlbumWithBlock:(AssetsFindishBlock)block {

    
    // 获取所有相册
    PHFetchOptions *allPhotosOptions = [[PHFetchOptions alloc] init];
    allPhotosOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d",PHAssetMediaTypeImage];
    // 所有照片集合
    PHFetchResult *allPhotos = [PHAsset fetchAssetsWithOptions:allPhotosOptions];
    // 获取所有自定义相册
    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    NSMutableArray *albumArr = [NSMutableArray array];
    [albumArr addObject:allPhotos];
    for (PHCollection *album in topLevelUserCollections) {
        [albumArr addObject:album];
    }
    block(albumArr);
}

+ (void)enumAllPhotoWithPHFetchResult:(PHFetchResult *)fetchResult block:(PhotoFindishBlock)block {
    // 缩略图和PHAsset
    dispatch_queue_t queue = dispatch_queue_create("getThumbnailImage", nil);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
    NSMutableArray<UIImage *> *imageArr = [NSMutableArray array];
    NSMutableArray<PHAsset *> *assetArr = [NSMutableArray array];
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
//    dispatch_async(queue, ^{
        for (PHAsset *photo in fetchResult) {
            [assetArr addObject:photo];
            CGSize size = CGSizeMake([UIScreen mainScreen].bounds.size.width / 3, [UIScreen mainScreen].bounds.size.width / 3);
            [imageManager requestImageForAsset:photo targetSize:size contentMode:PHImageContentModeDefault options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                [imageArr addObject:result];
                if ([photo isEqual:[fetchResult lastObject]]) {
                    dispatch_semaphore_signal(semaphore);
                }
            }];
        }
//        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
//        dispatch_async(dispatch_get_main_queue(), ^{
            block(imageArr, assetArr);
//        });
//    });
}

+ (void)getRealPhotoWithPHAsset:(PHAsset *)pHAsset block:(RealPhotoFindishBlock)block{
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    options.networkAccessAllowed = YES;
    [[PHImageManager defaultManager] requestImageDataForAsset:pHAsset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        NSLog(@"%@ === %@", @"pHAsset", [info description]);
        block([UIImage imageWithData:imageData]);
    }];
}

// ~~~~~~~~~~~~~~~~~~~~~~~以下废弃~~~~~~~~~~~~~~~~~~~~~~~~

- (id)init {
    self = [super init];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    assetsLibrary = [[ALAssetsLibrary alloc]init];
}

- (void)enumPhoteAlumNameWithBlock:(AssetsFindishBlock)block {
    NSMutableArray* album_name_arr = [[NSMutableArray alloc]init];
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        NSString* album_name = [group valueForProperty:ALAssetsGroupPropertyName];
        NSLog(@"enum group success %@", album_name);
        NSLog(@"enum group number %ld", (long)[group numberOfAssets]);
        if (album_name != nil) {
            [album_name_arr addObject:group];
            
        } else { // stops
            // finished
            //            [self enumAllAssetWithProprty:ALAssetTypePhoto];
            block([album_name_arr copy]);
        }
        
    } failureBlock:^(NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:error.domain message:error.description delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
    }];
}

- (void)enumFirstAssetWithProprty:(NSString*)type finishBlock:(AssetsFindishBlock)block {
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop_group) {
        NSString* album_name = [group valueForProperty:ALAssetsGroupPropertyName];
        if (album_name != nil) {
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                
                if (result == nil) { // stops
                    block(nil);
                } else {
                    //                    NSURL* asset_url = [result valueForProperty:ALAssetPropertyAssetURL];
                    //                    [images_arr addObject:asset_url];
                    NSString* cur_type = [result valueForProperty:ALAssetPropertyType];
                    if ([cur_type isEqualToString:type]) {
                        *stop = YES;
                        *stop_group = YES;
                        block([NSArray arrayWithObject:result]);
                    }
                }
            }];
        }
        
    } failureBlock:^(NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:error.domain message:error.description delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
    }];
}

- (void)enumAllAssetWithProprty:(NSString*)type finishBlock:(AssetsFindishBlock)block {
    NSMutableArray* assets = [[NSMutableArray alloc]init];
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        NSString* album_name = [group valueForProperty:ALAssetsGroupPropertyName];
        if (album_name != nil) {
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                
                if (result == nil) { // stops
                    block([assets copy]);
                    
                } else {
                    //                    NSURL* asset_url = [result valueForProperty:ALAssetPropertyAssetURL];
                    //                    [images_arr addObject:asset_url];
                    NSString* cur_type = [result valueForProperty:ALAssetPropertyType];
                    if ([cur_type isEqualToString:type]) {
                        //                        [assets addObject:result];
                        [assets insertObject:result atIndex:0];
                    }
                }
            }];
        }
        
    } failureBlock:^(NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:error.domain message:error.description delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
    }];
}

- (void)enumPhotoAblumByAlbumName:(ALAssetsGroup*)group finishBlock:(AssetsFindishBlock)block {
    NSMutableArray* assetsByGroup = [[NSMutableArray alloc]init];
    [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result == nil) { // stops
            block([assetsByGroup copy]);
            
        } else {
            NSString* type = [result valueForProperty:ALAssetPropertyType];
            NSLog(@"alsset type %@", type);
            
            if (type == ALAssetTypePhoto) {
                [assetsByGroup addObject:result];
            }
        }
    }];
}
@end
