//
//  PostModel.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 7/01/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "PostModel.h"
#import "AppDelegate.h"
#import "RemoteInstance.h"
#import "ModelDefines.h"
#import "TmpFileStorageModel.h"
#import "ModelDefines.h"
#import "QueryContent+ContextOpt.h"

@implementation PostModel

/**
 * this is for post movie by url, only use for ALAssertLibrary assert
 */
- (BOOL)postJsonContentWithFileURL:(NSURL*)path withMessage:(NSString *)message {
    
    AppDelegate* delegate = (AppDelegate*)([UIApplication sharedApplication].delegate);
    NSString* auth_token = delegate.lm.current_auth_token;
    NSString* user_id = delegate.lm.current_user_id;
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:auth_token forKey:@"auth_token"];
    [dic setValue:user_id forKey:@"user_id"];
    [dic setValue:message forKey:@"description"];
    
    /**
     * post image to server
     */
    NSMutableArray* arr_items = [[NSMutableArray alloc]init];
    dispatch_queue_t post_queue = dispatch_queue_create("post queue", nil);
    dispatch_async(post_queue, ^(void) {
        NSString* filename = [[TmpFileStorageModel generateFileName] stringByAppendingPathExtension:@"mp4"]; //[path lastPathComponent];
//        NSString* fullpath = [[TmpFileStorageModel BMTmpMovieDir] stringByAppendingPathComponent:filename];
//        if ([[NSFileManager defaultManager]fileExistsAtPath:fullpath]) {
//            NSLog(@"existing");
//        }
        [RemoteInstance uploadFileUrl:path withName:filename toUrl:[NSURL URLWithString:[POST_HOST_DOMAIN stringByAppendingString:POST_UPLOAD]] callBack:^(BOOL successs, NSString *message) {
            if (successs) {
                NSLog(@"post image success");
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                [alert show];
            }
        }];
    });
    
    NSNumber* type = [NSNumber numberWithInteger:ModelAttchmentTypeMovie];
    NSMutableDictionary* dic_tmp = [[NSMutableDictionary alloc]init];
    [dic_tmp setObject:type forKey:@"type"];
    [dic_tmp setObject:[path lastPathComponent] forKey:@"name"];
    
    [arr_items addObject:dic_tmp];
    
    [dic setObject:arr_items forKey:@"items"];
    
    NSError * error = nil;
    NSData* jsonData =[NSJSONSerialization dataWithJSONObject:[dic copy] options:NSJSONWritingPrettyPrinted error:&error];
    
    NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:[POST_HOST_DOMAIN stringByAppendingString:POST_CONTENT]]];
    
    if ([[result objectForKey:@"status"] isEqualToString:@"ok"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"post success" object:nil];
        return YES;
    } else {
        NSDictionary* reError = [result objectForKey:@"error"];
        NSString* msg = [reError objectForKey:@"message"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:msg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
}

/**
 * this is for post movie files
 */
//- (BOOL)postJsonContentWithFileName:(NSString *)path withMessage:(NSString *)message {
- (BOOL)postJsonContentWithFileName:(NSString *)path andThumb:(UIImage*)thumb withMessage:(NSString *)message {

    AppDelegate* delegate = (AppDelegate*)([UIApplication sharedApplication].delegate);
    NSString* auth_token = delegate.lm.current_auth_token;
    NSString* user_id = delegate.lm.current_user_id;
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:auth_token forKey:@"auth_token"];
    [dic setValue:user_id forKey:@"user_id"];
    [dic setValue:message forKey:@"description"];
    
    /**
     * post movie to server
     */
    NSMutableArray* arr_items = [[NSMutableArray alloc]init];
    dispatch_queue_t post_queue = dispatch_queue_create("post queue", nil);
    dispatch_async(post_queue, ^(void) {
        NSString* filename = [path lastPathComponent];
        NSString* fullpath = [[TmpFileStorageModel BMTmpMovieDir] stringByAppendingPathComponent:filename];
        if ([[NSFileManager defaultManager]fileExistsAtPath:fullpath]) {
            NSLog(@"existing");
        }
        [RemoteInstance uploadFile:fullpath withName:filename toUrl:[NSURL URLWithString:[POST_HOST_DOMAIN stringByAppendingString:POST_UPLOAD]] callBack:^(BOOL successs, NSString *message) {
            if (successs) {
                NSLog(@"post movie success");
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                [alert show];
            }
        }];
    });
    
    /**
     * post thumb to server
     */
    NSString* extent = [TmpFileStorageModel saveToTmpDirWithImage:thumb];
    dispatch_queue_t thumb_queue = dispatch_queue_create("thumb queue", nil);
    dispatch_async(thumb_queue, ^(void){
        [RemoteInstance uploadPicture:thumb withName:extent toUrl:[NSURL URLWithString:[POST_HOST_DOMAIN stringByAppendingString:POST_UPLOAD]] callBack:^(BOOL successs, NSString *message) {
            if (successs) {
                NSLog(@"post thumb success");
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                [alert show];
            }
        }];
    });
    
    NSNumber* type = [NSNumber numberWithInteger:ModelAttchmentTypeMovie];
    NSMutableDictionary* dic_tmp = [[NSMutableDictionary alloc]init];
    [dic_tmp setObject:type forKey:@"type"];
    [dic_tmp setObject:[path lastPathComponent] forKey:@"name"];
    [arr_items addObject:dic_tmp];
    
    NSNumber* type1 = [NSNumber numberWithInteger:ModelAttchmentTypeImage];
    NSMutableDictionary* dic_tmp1 = [[NSMutableDictionary alloc]init];
    [dic_tmp1 setObject:type1 forKey:@"type"];
    [dic_tmp1 setObject:extent forKey:@"name"];
    [arr_items addObject:dic_tmp1];
    
    [dic setObject:arr_items forKey:@"items"];
    
    NSError * error = nil;
    NSData* jsonData =[NSJSONSerialization dataWithJSONObject:[dic copy] options:NSJSONWritingPrettyPrinted error:&error];
    
    NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:[POST_HOST_DOMAIN stringByAppendingString:POST_CONTENT]]];
    
    if ([[result objectForKey:@"status"] isEqualToString:@"ok"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"post success" object:nil];
        return YES;
    } else {
        NSDictionary* reError = [result objectForKey:@"error"];
        NSString* msg = [reError objectForKey:@"message"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:msg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
}

/**
 * this is for post pictures
 */
- (BOOL)postJsonContentToServieWithTags:(NSArray*)tags andDescription:(NSString*)message andPhotos:(NSArray*)photos {
    
    AppDelegate* delegate = (AppDelegate*)([UIApplication sharedApplication].delegate);
    NSString* auth_token = delegate.lm.current_auth_token;
    NSString* user_id = delegate.lm.current_user_id;
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:auth_token forKey:@"auth_token"];
    [dic setValue:user_id forKey:@"user_id"];
    [dic setValue:message forKey:@"description"];

    NSMutableArray* arr_items = [[NSMutableArray alloc]init];
    for (UIImage* image in photos) {
        NSString* extent = [TmpFileStorageModel saveToTmpDirWithImage:image];
        /**
         * post image to server
         */
        dispatch_queue_t post_queue = dispatch_queue_create("post queue", nil);
        dispatch_async(post_queue, ^(void){
            [RemoteInstance uploadPicture:image withName:extent toUrl:[NSURL URLWithString:[POST_HOST_DOMAIN stringByAppendingString:POST_UPLOAD]] callBack:^(BOOL successs, NSString *message) {
                if (successs) {
                    NSLog(@"post image success");
                } else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                    [alert show];
                }
            }];
        });
       
        NSNumber* type = [NSNumber numberWithInteger:ModelAttchmentTypeImage];
        NSMutableDictionary* dic_tmp = [[NSMutableDictionary alloc]init];
        [dic_tmp setObject:type forKey:@"type"];
        [dic_tmp setObject:extent forKey:@"name"];
       
        [arr_items addObject:dic_tmp];
    }
    
    [dic setObject:arr_items forKey:@"items"];
    [dic setObject:tags forKey:@"tags"];
    
    NSError * error = nil;
    NSData* jsonData =[NSJSONSerialization dataWithJSONObject:[dic copy] options:NSJSONWritingPrettyPrinted error:&error];
    
    NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:[POST_HOST_DOMAIN stringByAppendingString:POST_CONTENT]]];
    
    if ([[result objectForKey:@"status"] isEqualToString:@"ok"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"post success" object:nil];
        return YES;
    } else {
        NSDictionary* reError = [result objectForKey:@"error"];
        NSString* msg = [reError objectForKey:@"message"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:msg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
}


- (QueryContent*)postCommentToServiceWithPostID:(NSString*)post_id andCommentContent:(NSString*)comment_content {

    AppDelegate* delegate = (AppDelegate*)([UIApplication sharedApplication].delegate);
    NSString* auth_token = delegate.lm.current_auth_token;
    NSString* user_id = delegate.lm.current_user_id;
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:post_id forKey:@"post_id"];
    [dic setValue:auth_token forKey:@"auth_token"];
    [dic setValue:user_id forKey:@"user_id"];
    [dic setValue:comment_content forKey:@"content"];

    NSError * error = nil;
    NSData* jsonData =[NSJSONSerialization dataWithJSONObject:[dic copy] options:NSJSONWritingPrettyPrinted error:&error];
    
    NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:[POST_HOST_DOMAIN stringByAppendingString:POST_COMMENT]]];
    
    if ([[result objectForKey:@"status"] isEqualToString:@"ok"]) {
        NSLog(@"post comment success");
        NSArray* comments_array =  [[result objectForKey:@"result"] objectForKey:@"comments"];
        NSNumber* comments_count =  [[result objectForKey:@"result"] objectForKey:@"comments_count"];
        return [QueryContent refreshCommentToPostWithID:post_id withAttrs:comments_array andTotalCount:comments_count inContext:delegate.qm.doc.managedObjectContext];
        
    } else {
        NSLog(@"post comment failed");
        NSDictionary* reError = [result objectForKey:@"error"];
        NSString* msg = [reError objectForKey:@"message"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:msg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
        return nil;
    }
}


- (QueryContent*)postLikeToServiceWithPostID:(NSString*)post_id {
    
    AppDelegate* delegate = (AppDelegate*)([UIApplication sharedApplication].delegate);
    NSString* auth_token = delegate.lm.current_auth_token;
    NSString* user_id = delegate.lm.current_user_id;
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:post_id forKey:@"post_id"];
    [dic setValue:auth_token forKey:@"auth_token"];
    [dic setValue:user_id forKey:@"user_id"];
    
    NSError * error = nil;
    NSData* jsonData =[NSJSONSerialization dataWithJSONObject:[dic copy] options:NSJSONWritingPrettyPrinted error:&error];
    
    NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:[POST_HOST_DOMAIN stringByAppendingString:POST_LIKE]]];
    
    if ([[result objectForKey:@"status"] isEqualToString:@"ok"]) {
        NSLog(@"post like success");
        NSArray* like_array =  [[result objectForKey:@"result"] objectForKey:@"likes"];
        NSNumber* like_count =  [[result objectForKey:@"result"] objectForKey:@"likes_count"];
        return [QueryContent refreshLikesToPostWithID:post_id withArr:like_array andLikesCount:like_count inContext:delegate.qm.doc.managedObjectContext];
    } else {
        NSLog(@"post like failed");
        NSDictionary* reError = [result objectForKey:@"error"];
        NSString* msg = [reError objectForKey:@"message"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:msg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
        return nil;
    }
}

- (void)postPushToServiceWithPostID:(NSString*)post_id withFinishBlock:(likeFinishBlock)block {
    AppDelegate* delegate = (AppDelegate*)([UIApplication sharedApplication].delegate);
    NSString* auth_token = delegate.lm.current_auth_token;
    NSString* user_id = delegate.lm.current_user_id;
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:post_id forKey:@"post_id"];
    [dic setValue:auth_token forKey:@"auth_token"];
    [dic setValue:user_id forKey:@"user_id"];
    
    NSError * error = nil;
    NSData* jsonData =[NSJSONSerialization dataWithJSONObject:[dic copy] options:NSJSONWritingPrettyPrinted error:&error];
    
    NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:POST_PUSH]];
    
    if ([[result objectForKey:@"status"] isEqualToString:@"ok"]) {
        NSLog(@"post push success");
        NSArray* like_array =  [[result objectForKey:@"result"] objectForKey:@"push"];
        NSNumber* like_count =  [[result objectForKey:@"result"] objectForKey:@"push_count"];
        block(YES, [QueryContent refreshLikesToPostWithID:post_id withArr:like_array andLikesCount:like_count inContext:delegate.qm.doc.managedObjectContext]);
    } else {
        NSLog(@"post push failed");
        //        NSDictionary* reError = [result objectForKey:@"error"];
        //        NSString* msg = [reError objectForKey:@"message"];
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:msg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        //        [alert show];
        //        return nil;
        block(NO, nil);
    }
}

- (void)postLikeToServiceWithPostID:(NSString*)post_id withFinishBlock:(likeFinishBlock)block {
        AppDelegate* delegate = (AppDelegate*)([UIApplication sharedApplication].delegate);
    NSString* auth_token = delegate.lm.current_auth_token;
    NSString* user_id = delegate.lm.current_user_id;
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:post_id forKey:@"post_id"];
    [dic setValue:auth_token forKey:@"auth_token"];
    [dic setValue:user_id forKey:@"user_id"];
    
    NSError * error = nil;
    NSData* jsonData =[NSJSONSerialization dataWithJSONObject:[dic copy] options:NSJSONWritingPrettyPrinted error:&error];
    
    NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:[POST_HOST_DOMAIN stringByAppendingString:POST_LIKE]]];
    
    if ([[result objectForKey:@"status"] isEqualToString:@"ok"]) {
        NSLog(@"post like success");
        NSArray* like_array =  [[result objectForKey:@"result"] objectForKey:@"likes"];
        NSNumber* like_count =  [[result objectForKey:@"result"] objectForKey:@"likes_count"];
        block(YES, [QueryContent refreshLikesToPostWithID:post_id withArr:like_array andLikesCount:like_count inContext:delegate.qm.doc.managedObjectContext]);
    } else {
        NSLog(@"post like failed");
//        NSDictionary* reError = [result objectForKey:@"error"];
//        NSString* msg = [reError objectForKey:@"message"];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:msg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
//        [alert show];
//        return nil;
        block(NO, nil);
    }
}
@end
