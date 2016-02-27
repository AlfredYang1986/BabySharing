//
//  AlbumTest.h
//  BabySharing
//
//  Created by monkeyheng on 16/2/27.
//  Copyright © 2016年 BM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "AlbumModule.h"

@interface AlbumTest : NSObject

+ (void)enumAllPhotoWithBlock:(AssetsFindishBlock)block;

@end
