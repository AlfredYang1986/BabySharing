//
//  PhotoTagView.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 13/06/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoTagEnumDefines.h"

typedef enum : NSUInteger {
    PhotoTagViewDirectionLeftToRight,
    PhotoTagViewDirectionRightToLeft,
} PhotoTagViewDirection;

@interface PhotoTagView : UIView

@property (nonatomic) PhotoTagViewStatus status;
//@property (nonatomic, strong, readonly) NSString* content;
//@property (nonatomic, readonly) TagType type;
@property (nonatomic, strong) NSString* content;
@property (nonatomic) TagType type;

//@property (nonatomic, strong) UIImage* typeImg;

@property (nonatomic) CGFloat offset_x;
@property (nonatomic) CGFloat offset_y;

@property (nonatomic, setter=setTagDirection:) PhotoTagViewDirection direction;

- (id)initWithTagName:(NSString*)name andType:(TagType)type;

//- (CGRect)getTagViewPreferBounds;
//- (void)setContentAndFontSize:(NSString*)str;
//- (void)setTypeImg:(UIImage *)typeImg;
//- (UIImage*)getTypeImg;
@end
