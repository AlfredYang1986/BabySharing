//
//  TmpFileStorageModel.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 10/01/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "TmpFileStorageModel.h"
#import "RemoteInstance.h"
#import "ModelDefines.h"
#import <AVFoundation/AVFoundation.h>

#define TMP_IMAGE_DIR           @"images"
#define TMP_MOVIE_DIR           @"movies"

@implementation TmpFileStorageModel

+ (NSString*)BMTmpDir {
    return NSTemporaryDirectory();
}

+ (NSString*)BMTmpImageDir {
    NSString* image_dir = [[TmpFileStorageModel BMTmpDir] stringByAppendingPathComponent:TMP_IMAGE_DIR];
    if (![[NSFileManager defaultManager] fileExistsAtPath:image_dir]) {
        NSError* error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:image_dir withIntermediateDirectories:YES attributes:nil error:&error];
    }
    return image_dir;
}

+ (void)deleteBMTmpImageDir {
    NSString* image_dir = [[TmpFileStorageModel BMTmpDir] stringByAppendingPathComponent:TMP_IMAGE_DIR];
    if([[NSFileManager defaultManager] fileExistsAtPath:image_dir]) {
        [[NSFileManager defaultManager] removeItemAtPath:image_dir error:nil];
    }
}

+ (NSString*)BMTmpMovieDir {
    NSString* movie_dir = [[TmpFileStorageModel BMTmpDir] stringByAppendingPathComponent:TMP_MOVIE_DIR];
    if (![[NSFileManager defaultManager] fileExistsAtPath:movie_dir]) {
        NSError* error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:movie_dir withIntermediateDirectories:YES attributes:nil error:&error];
    }
    return movie_dir;
}

+ (void)deleteBMTmpMovieDir {
     NSString* movie_dir = [[TmpFileStorageModel BMTmpDir] stringByAppendingPathComponent:TMP_MOVIE_DIR];
    if([[NSFileManager defaultManager] fileExistsAtPath:movie_dir]) {
        [[NSFileManager defaultManager] removeItemAtPath:movie_dir error:nil];
    }   
}

+ (void)deleteOneMovieFileWithName:(NSString*)name {
    NSString *path = [[TmpFileStorageModel BMTmpMovieDir] stringByAppendingPathComponent:name];
    if([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
}

+ (void)deleteOneMovieFileWithUrl:(NSURL*)url {
    NSString* path = [url absoluteString];
    if([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
}


+ (NSString*) uuidWithString:(NSString*)token {
    
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}

+ (NSString*)generateFileName {
    
    return [TmpFileStorageModel uuidWithString:nil];
}

+ (NSString*)saveToTmpDirWithImage:(UIImage*)img {
    NSString* extent = [TmpFileStorageModel generateFileName];
    NSString* file = [[TmpFileStorageModel BMTmpImageDir] stringByAppendingPathComponent:extent];
    file = [file stringByAppendingPathExtension:@"png"];
    
    [UIImagePNGRepresentation(img) writeToFile:file atomically:YES];
    return extent;
}

+ (void)saveToTmpDirWithImage:(UIImage*)img withName:(NSString*)name {
    NSString* file = [[TmpFileStorageModel BMTmpImageDir] stringByAppendingPathComponent:name];
    file = [file stringByAppendingPathExtension:@"png"];
    
    [UIImagePNGRepresentation(img) writeToFile:file atomically:YES];
}

+ (void)saveAsToAlbumWithImageName:(NSString*)name {
    
}

+ (void)saveAsToAlbumWithMovieName:(NSString *)name {
    
}

+ (NSURL*)enumFileWithName:(NSString*)name andType:(PostPreViewType)type withDownLoadFinishBlock:(fileDidDownloadBlock)block {
    NSString* path = nil;
    if (type == PostPreViewPhote) {
        path = [TmpFileStorageModel BMTmpImageDir];
    } else {
        path = [TmpFileStorageModel BMTmpMovieDir];
    }
    
    NSString* fullname = [path stringByAppendingPathComponent:name];
    if ([[NSFileManager defaultManager] fileExistsAtPath:fullname]) {
        return [NSURL fileURLWithPath:fullname];
    } else {
        /**
         * down load from server
         */
        dispatch_queue_t aq = dispatch_queue_create("download queue", nil);
        dispatch_async(aq, ^{
            NSData* data = [RemoteInstance remoteDownloadFileWithName:name andHost:ATT_DOWNLOAD_HOST];
            NSURL* url = [NSURL fileURLWithPath:fullname];
            unlink([fullname cString]);
            NSLog(@"%@", url);
            NSError* error = nil;
            if ([data writeToFile:fullname options:NSDataWritingFileProtectionComplete error:&error]) {
                NSLog(@"write data to file error: %@", error);
                block(YES, url);
            } else {
                NSLog(@"write data to file error: %@", error);
                block(NO, nil);
            }
        });
        
        return nil;
    }
}

+ (UIImage*)enumImageWithName:(NSString*)name withDownLoadFinishBolck:(imageDidDownloadBlock)block {
    NSString* path = [[[TmpFileStorageModel BMTmpImageDir] stringByAppendingPathComponent:name] stringByAppendingPathExtension:@"png"];
    
    UIImage* reVal = [UIImage imageWithContentsOfFile:path];
    if (!reVal) {
        /**
         * down load from server
         */
        dispatch_queue_t aq = dispatch_queue_create("download queue", nil);
        dispatch_async(aq, ^{
            NSData* data = [RemoteInstance remoteDownloadFileWithName:name andHost:ATT_DOWNLOAD_HOST];
            UIImage* img = [UIImage imageWithData:data];
            [TmpFileStorageModel saveToTmpDirWithImage:img withName:name];
            if (img) block(YES, img);
            else block(NO, img);
        });
    }
    return reVal;
}
@end
