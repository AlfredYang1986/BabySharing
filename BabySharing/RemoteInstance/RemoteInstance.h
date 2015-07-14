//
//  RemoteInstance.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 29/12/2014.
//  Copyright (c) 2014 YY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface RemoteInstance : NSObject
//+ (BOOL)downloadDataPackageToPath:(NSString*)path;
//+ (void)uploadFileWithURL:(NSURL*)url data:(NSData*)data;

#pragma mark -- json parser
//+ (id)searchResultFormFile:(NSString*)fileName;
//+ (id)searchResultFormURL:(NSURL*)url withWAVData:(NSData*)data;

#pragma mark -- send data to remote server
+ (id)remoteSeverRequestData:(NSData*)data toUrl:(NSURL*)url;

#pragma mark -- handler json result
+ (id)searchDataFromData:(NSData*)data;
#pragma mark -- uploadfiles
//+ (id)uploadPicture:(NSDictionary*)params toUrl:(NSURL*)url;
typedef void (^blockUploadCallback)(BOOL successs, NSString* message);
+ (void)uploadPicture:(UIImage*)image withName:(NSString*)filename toUrl:(NSURL*)url callBack:(blockUploadCallback)callback;
+ (void)uploadFileUrl:(NSURL*)path withName:(NSString*)filename toUrl:(NSURL*)url callBack:(blockUploadCallback)callback;
+ (void)uploadFile:(NSString*)path withName:(NSString*)filename toUrl:(NSURL*)url callBack:(blockUploadCallback)callback;

#pragma mark -- download image files
+ (NSData*)remoteDownDataFromUrl:(NSURL*)url;
+ (NSData*)remoteDownloadFileWithName:(NSString*)name andHost:(NSString*)host;
@end
