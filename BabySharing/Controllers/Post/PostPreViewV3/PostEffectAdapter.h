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

@protocol GPUImageInput;
@class GPUImageOutput;
@class GPUImagePicture;
//@class GPUImageTiltShiftFilter;
//@class GPUImageSketchFilter;
//@class GPUImageColorInvertFilter;
//@class GPUImageSmoothToonFilter;
@class GPUImageFilterGroup;
@class GPUImageView;
@class GPUImageMovie;

@protocol PostEffectAdapterProtocol <NSObject>

/**
 * movie input and output
 */
- (GPUImageMovie*)getInput;
- (GPUImageView*)getOutput;

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

/**
 * change movie cover
 */
- (void)didChangeCoverPage:(UIImage*)img;

/**
 * query views with title
 */
- (UIView*)queryViewWithTitle:(NSString*)title;

@end

@interface PostEffectAdapter : NSObject

@property (nonatomic, weak, setter=setProtocol:) id<PostEffectAdapterProtocol> delegate;

@property (nonatomic, weak) UIView* content_parent_view;

// for effort of the movie
@property (nonatomic, strong) NSURL* movie_url;
// for effort of the image
//@property (nonatomic, strong, readonly) GPUImagePicture* ip;

// filters
@property (nonatomic, strong, readonly) GPUImageOutput<GPUImageInput> * originFilter;
//@property (nonatomic, strong, readonly) GPUImageTiltShiftFilter* tiltShiftFilter;
//@property (nonatomic, strong, readonly) GPUImageSketchFilter* sketchFilter;
//@property (nonatomic, strong, readonly) GPUImageColorInvertFilter* colorInvertFilter;
//@property (nonatomic, strong, readonly) GPUImageSmoothToonFilter* smoothToonFilter;

@property (nonatomic, strong, readonly) GPUImageFilterGroup* normal;
@property (nonatomic, strong, readonly) GPUImageFilterGroup* saturation;
@property (nonatomic, strong, readonly) GPUImageFilterGroup* blackWhite;
@property (nonatomic, strong, readonly) GPUImageFilterGroup* exposure;
@property (nonatomic, strong, readonly) GPUImageFilterGroup* contrast;
@property (nonatomic, strong, readonly) GPUImageFilterGroup* group;

- (UIView*)getFunctionViewByTitle:(NSString*)title andType:(PostPreViewType)type andPreferedHeight:(CGFloat)height;
- (UIImage*)didSelectEffectFilterForPhoto:(UIButton*)sender;
- (void)didSelectEffectFilterForMovie:(UIButton*)sender;
- (void)didSelectTagForPhoto:(UIButton*)sender;
- (void)didSelectPasteForPhoto:(UIButton*)sender;
- (void)didSelectHideTagView:(UITapGestureRecognizer*)gesture;
- (void)didClickThumb:(UITapGestureRecognizer*)gesture;
- (UIImage*)getMovieThumb;
@end
