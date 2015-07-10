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

@implementation AlbumModule {
    ALAssetsLibrary* assetsLibrary;
}

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
                        [assets addObject:result];
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
