//
//  PostEffectAdapter.h
//  BabySharing
//
//  Created by Alfred Yang on 13/07/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PostDefine.h"
#import "PhotoTagView.h"

@class GPUImagePicture;
@class GPUImageTiltShiftFilter;
@class GPUImageSketchFilter;
@class GPUImageColorInvertFilter;
@class GPUImageSmoothToonFilter;

@protocol PostEffectAdapterProtocol <NSObject>

/**
 * type
 */
- (PostPreViewType)currentType;

/**
 * photo effect
 */
- (UIImage*)originImage;
- (void)imageWithEffect:(UIImage*)img;

/**
 * tags
 */
- (BOOL)canCreateNewTag:(TagType)tag_type;
- (void)tagView:(PhotoTagView*)view forTagType:(TagType)tag_type;
- (void)queryTagContetnWithTagType:(TagType)tag_type andImg:(UIImage*)tag_img;

/**
 * paste img
 */
- (void)pasteWithImage:(UIImage*)img;

@end

@interface PostEffectAdapter : NSObject

@property (nonatomic, weak, setter=setProtocol:) id<PostEffectAdapterProtocol> delegate;

// for effort of the image
@property (nonatomic, strong, readonly) GPUImagePicture* ip;

// filters
@property (nonatomic, strong, readonly) GPUImageTiltShiftFilter* tiltShiftFilter;
@property (nonatomic, strong, readonly) GPUImageSketchFilter* sketchFilter;
@property (nonatomic, strong, readonly) GPUImageColorInvertFilter* colorInvertFilter;
@property (nonatomic, strong, readonly) GPUImageSmoothToonFilter* smoothToonFilter;

- (UIView*)getFunctionViewByTitle:(NSString*)title andType:(PostPreViewType)type andPreferedHeight:(CGFloat)height;
- (UIImage*)didSelectEffectFilterForPhoto:(UIButton*)sender;
- (void)didSelectTagForPhoto:(UIButton*)sender;
- (void)didSelectPasteForPhoto:(UIButton*)sender;
@end
