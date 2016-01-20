//
//  PhotoTagView.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 13/06/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    PhotoTagViewStatusRight,
    PhotoTagViewStatusLeft,
} PhotoTagViewStatus;

typedef enum : NSUInteger {
    TagTypeLocation,
    TagTypeTime,
    TagTypeTags,
    TagTypeBrand,
} TagType;

@interface PhotoTagView : UIView

@property (nonatomic) PhotoTagViewStatus status;
@property (nonatomic, strong, readonly) NSString* content;
@property (nonatomic, readonly) TagType type;
//@property (nonatomic, strong) UIImage* typeImg;

@property (nonatomic) CGFloat offset_x;
@property (nonatomic) CGFloat offset_y;

- (id)initWithTagName:(NSString*)name andType:(TagType)type;

//- (CGRect)getTagViewPreferBounds;
//- (void)setContentAndFontSize:(NSString*)str;
//- (void)setTypeImg:(UIImage *)typeImg;
//- (UIImage*)getTypeImg;
@end
