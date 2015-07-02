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
} TagType;

@interface PhotoTagView : UIView

@property (nonatomic) PhotoTagViewStatus status;
@property (nonatomic, strong, setter=setContentAndFontSize:) NSString* content;
@property (nonatomic) TagType type;
@property (nonatomic, strong, setter=setTypeImg:, getter=getTypeImg) UIImage* typeImg;

@property (nonatomic) CGFloat offset_x;
@property (nonatomic) CGFloat offset_y;

- (id)init;
- (id)initWithTagName:(NSString*)name;
- (id)initWithTagName:(NSString*)name andType:(TagType)type;

- (CGRect)getTagViewPreferBounds;
- (void)setContentAndFontSize:(NSString*)str;
- (void)setTypeImg:(UIImage *)typeImg;
- (UIImage*)getTypeImg;
@end
