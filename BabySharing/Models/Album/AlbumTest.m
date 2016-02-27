//
//  AlbumTest.m
//  BabySharing
//
//  Created by monkeyheng on 16/2/27.
//  Copyright © 2016年 BM. All rights reserved.
//

#import "AlbumTest.h"

@implementation AlbumTest

+ (void)enumAllPhotoWithBlock:(AssetsFindishBlock)block {
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    PHFetchResult *fetchResult = [PHAsset fetchAssetsWithOptions:options];
    
    PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_queue_t queue = dispatch_queue_create("aaaaa", nil);
    NSMutableArray<UIImage *> *imageArr = [NSMutableArray array];
    CGSize size = CGSizeMake([UIScreen mainScreen].bounds.size.width / 3, [UIScreen mainScreen].bounds.size.width / 3);
    dispatch_async(queue, ^{
        PHAsset *asset;
        for (int i = 0; i < fetchResult.count; i++) {
            asset = [fetchResult objectAtIndex:i];
            NSLog(@"%@ === %d", @"iiiiii", i);
            [imageManager requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage *result, NSDictionary *info) {
                static int i =0;
                if (result == nil) {
                    NSLog(@"%@ === %@", @"result", @"nil");
                } else {
                    NSLog(@"%@ === %d", @"TTTTTT", ++i);
                     [imageArr addObject:result];
                }
               
                if ([asset isEqual:fetchResult.lastObject]) {
                    dispatch_semaphore_signal(semaphore);
                }
            }];
        }
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_async(dispatch_get_main_queue(), ^{
            block(imageArr);
        });
    });
}

@end
